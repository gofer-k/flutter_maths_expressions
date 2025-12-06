
import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/drag_point.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';
import 'package:flutter_maths_expressions/painters/figure_painter.dart';
import 'package:flutter_maths_expressions/widgets/hierarchical_fab_menu.dart';
import 'package:infinite_canvas/infinite_canvas.dart';

import '../models/dock_side.dart';
import '../models/planimetry/angle.dart';
import '../painters/cross_axes_painter.dart';
import '../painters/dragging_shape_painter.dart';
import '../painters/drawable_shape.dart';
import '../painters/legend_painter.dart';

typedef DragShapeCallback = void Function(
    List<DrawableShape?> oldShapes,
    DragPoint originPoint,
    DragPoint targetPoint);
typedef RotatingShapeCallback = void Function(
    List<DrawableShape?> oldShapes,
    Offset originPoint,
    double rotationAngle,
    AngleType angleType);
typedef RotateEndShapeCallback = void Function(
    List<DrawableShape?> oldShapes,
    Offset originPoint,
    double rotationAngle,
    AngleType angleType);

class InfiniteDrawer extends StatefulWidget {
  final bool enableRotate;
  final bool enablePanning;
  final bool enableScaling;
  final bool enableCrossAxes;
  final DockSide actionsDockSide;
  final List<DrawableShape> drawableShapes;
  final DragShapeCallback? onDragShape;
  final RotatingShapeCallback? onRotateShape;
  final RotateEndShapeCallback? onRotateEndShape;

  const InfiniteDrawer({super.key,
    this.enableRotate = false,
    this.enablePanning = true,
    this.enableScaling = true,
    this.enableCrossAxes = true,
    this.actionsDockSide = DockSide.rightBottom,
    this.onDragShape,
    this.onRotateShape,
    this.onRotateEndShape,
    required this.drawableShapes,
  });

  @override
  State<StatefulWidget> createState() => _InfiniteDrawerState();
}

class _InfiniteDrawerState extends State<InfiniteDrawer> {
  late InfiniteCanvasController _controller;
  late Size gridSize;
  late double widthUnitInPixels;
  late double heightUnitInPixels;
  late HierarchicalFABMenu _fabMenu;

  // State to track the shape being dragged
  final List<DrawableShape?> _draggingShapes = List.empty(growable: true);

  // State to track the dragging point for visual feedback
  DragPoint _draggingStartPoint = DragPoint(point: Offset.infinite, enableDragging: true);
  DragPoint _draggingTargetPoint = DragPoint(point: Offset.infinite, enableDragging: true);
  final List<DrawableShape> _rotatingShapes = [];
  double _rotationAngle = 0.0;
  Offset _rotationOriginPoint = Offset.infinite;
  
  @override
  void initState() {
    super.initState();
    _controller = InfiniteCanvasController();
    _controller.transform.addListener(_onCanvasTransformChanged);
    gridSize = Size.square(20);
    widthUnitInPixels = 2 * gridSize.width;
    heightUnitInPixels = 2 * gridSize.height;

    _fabMenu = HierarchicalFABMenu(actionsDockSide: widget.actionsDockSide, insetsFab: 4.0,
        mainMenu: [
          if (widget.enableScaling)
            FABMenu(true, action: FABAction(actionIcon: Icons.zoom_out_rounded),
                [
                  FABAction(actionIcon: Icons.zoom_in_rounded,
                      onPressed: (){ _controller.zoomIn(); }),
                  FABAction(actionIcon: Icons.zoom_out_rounded,
                      onPressed: (){ _controller.zoomOut(); }),
                  FABAction(actionIcon: Icons.lock_reset_rounded,
                      onPressed: (){ _controller.zoomReset(); }),
                ]
            ),
          if (widget.enablePanning)
            FABMenu(true, action: FABAction(actionIcon: Icons.open_with_rounded),
                [
                  FABAction(actionIcon: Icons.arrow_upward_rounded,
                      onPressed: (){ _controller.panUp(); }),
                  FABAction(actionIcon: Icons.arrow_back_rounded,
                      onPressed: (){ _controller.panLeft(); }),
                  FABAction(actionIcon: Icons.arrow_forward_rounded,
                      onPressed: (){ _controller.panRight(); }),
                  FABAction(actionIcon: Icons.arrow_downward_rounded,
                      onPressed: (){ _controller.panDown(); }),
                  FABAction(actionIcon: Icons.fit_screen_rounded,
                      onPressed: () { _controller.zoomReset(); }),
                ]
            ),
        ]
    );
  }

  @override
  void dispose() {
    _controller.transform.removeListener(_onCanvasTransformChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onScaleStart: (details){
              _startRotateShape(details);
              // If no rotation was started, check for a drag
              _startDraggingShapes(details);
            },
            onScaleUpdate: (details) {
              _updateRotateShape(details);
              _updateDraggingShapes(details);
            },
            onScaleEnd: (details) {
              _finishDraggingShapes(details);
              _finishRotateShapes(details);
              // Reset all states
              setState(() {
                _draggingShapes.clear();
                _draggingTargetPoint = DragPoint.infinite(drag: true);
                _draggingStartPoint = DragPoint.infinite(drag: true);
                _rotatingShapes.clear();
                _rotationAngle = 0.0;
                _rotationOriginPoint = Offset.infinite;
              });
            },
            child: Stack(
              children: [
                InfiniteCanvas(
                  controller: _controller,
                  gridSize: gridSize,
                  menuVisible: false,
                  canAddEdges: true,
                ),
                if (widget.enableCrossAxes)
                  CustomPaint(
                    size: viewportSize,
                    painter: CrossAxesPainter(
                        canvasTransform: _controller.transform.value,
                        viewportSize: viewportSize,
                        originWidthUnitInPixels: widthUnitInPixels,
                        originHeightUnitInPixels: heightUnitInPixels),
                  ),
                for (final shape in widget.drawableShapes) ...[
                  ClipRect(
                    child: CustomPaint(size: viewportSize,
                      painter: shape.paint(_controller.transform.value,
                        viewportSize,
                        widthUnitInPixels,
                        heightUnitInPixels))),
                  CustomPaint(size: viewportSize, painter:
                    LegendPainter(
                      canvasTransform: _controller.transform.value,
                      viewportSize: viewportSize,
                      labelsSpans: shape.labelsSpans,
                      startPosition: Offset(viewportSize.width - 100, 0.95)
                    )
                  ),
                ],
                if (_draggingShapes.isNotEmpty  && _draggingStartPoint !=_draggingTargetPoint)
                  _drawDraggingShapes(viewportSize),
                if (_rotatingShapes.isNotEmpty && _rotationAngle != 0.0)
                  _drawRotatingShapes(viewportSize),
                if (widget.enablePanning || widget.enableScaling)
                // FAB menu instance should created while initState() when the widget's state be persist.
                // Or FAB menu hasn't to persist its state that may be created here.
                  _fabMenu
              ]
            )
          );
        }
      )
    );
  }

  Widget _drawDraggingShapes(Size viewportSize) {
    return ClipRect(
      child: CustomPaint(size: viewportSize,
          painter: DraggingShapePainter(
            widthUnitInPixels,
            heightUnitInPixels,
            Line(a: _draggingStartPoint, b: _draggingTargetPoint),
            ShowDrapProperty.line,
            canvasTransform: _controller.transform.value,
            viewportSize: viewportSize,
            color: Colors.blue,
          )),
    );
  }

  Widget _drawRotatingShapes(Size viewportSize) {
    return ClipRect(
      child: Builder(builder: (context) {
        final rotationPainters = _rotatingShapes.map((shape) {
          // You can create a specific painter for rotation feedback,
          // or reuse an existing one like DraggingShapePainter.
          // Here, we'll create an Arc painter to show the rotation angle.
          if (shape.shape is Line) {
            final line = shape.shape as Line;
            final rotatedLine = line.rotate(angle: _rotationAngle, origin: _rotationOriginPoint);
            return CustomPaint(
              size: viewportSize,
              painter: DraggingShapePainter(
                widthUnitInPixels,
                heightUnitInPixels,
                rotatedLine,
                ShowDrapProperty.line,
                canvasTransform: _controller.transform.value,
                viewportSize: viewportSize,
                color: Colors.greenAccent,
              ),
            );
          }
          return SizedBox.shrink();
        }).toList();
        return Stack(children: rotationPainters);
      }),
    );
  }

  void _startRotateShape(ScaleStartDetails details) {
    if (!widget.enableRotate) return;
    
    final localPoint = DragPoint(
        point: _toLocal(_controller.toLocal(details.localFocalPoint)),
        enableDragging: true);

    final focalPoint = DragPoint(
        point: _toLocal(_controller.toLocal(details.focalPoint)),
        enableDragging: true);

    if (widget.onRotateShape != null && widget.enableRotate) {
      for (final shape in widget.drawableShapes.reversed) {
        if (shape.shape is Line) {
          final line = shape.shape as Line;
          if (line.matchOnLine(localPoint, 0.25)) {
            setState(() {
              _rotatingShapes.add(shape);
              _rotationOriginPoint = line.getMidpoint();
              _rotationAngle = 0.0;
            });
            return;
          }
        }
      }
    }
  }

  void _updateRotateShape(ScaleUpdateDetails details) {
    if (/*_rotatingShapes.isNotEmpty || */details.rotation != _rotationAngle) {
      final rotationDelta = details.rotation - _rotationAngle;
      if (widget.onRotateShape != null) {
        // widget.onRotateShape!(
        //   _rotatingShapes,
        //   _rotationOriginPoint,
        //   rotationDelta,
        //   AngleType.radian,
        // );
      }
      setState(() {
        _rotationAngle = details.rotation;
      });
    }
  }

  void _finishRotateShapes(ScaleEndDetails details) {
    // if(_rotatingShapes.isNotEmpty && widget.onRotateEndShape != null) {
    if (_rotatingShapes.isNotEmpty && widget.onRotateShape != null) {
      widget.onRotateShape!(
        _rotatingShapes,
        _rotationOriginPoint,
        _rotationAngle,
        AngleType.radian,
      );
        // widget.onRotateEndShape!(_rotatingShapes, _rotationOriginPoint,
        //     _rotationAngle, AngleType.degrees);
    }
  }

  void _startDraggingShapes(ScaleStartDetails details) {
    if (!widget.enablePanning) return;
    
    final localPoint = DragPoint(
        point: _toLocal(_controller.toLocal(details.localFocalPoint)),
        enableDragging: true);
    for (final shape in widget.drawableShapes.reversed) {
      final snapPoint = shape.matchPoint(localPoint, 0.25);
      if (snapPoint != null) {
        setState(() {
          _draggingShapes.add(shape);
          _draggingStartPoint = snapPoint;
          _draggingTargetPoint = snapPoint;
        });
      }
    }
  }
  
  void _updateDraggingShapes(ScaleUpdateDetails details) {
    if (_draggingStartPoint.isFinite) {
      final localPoint = DragPoint(
          point: _toLocal(_controller.toLocal(details.localFocalPoint)),
          enableDragging: true);

      setState(() {
        // Consider snap the point to the grid
        _draggingTargetPoint = localPoint;
      });
    }
  }

  void _finishDraggingShapes(ScaleEndDetails details) {
    if (widget.onDragShape != null && _draggingShapes.isNotEmpty) {
      widget.onDragShape!(_draggingShapes, _draggingStartPoint, _draggingTargetPoint);
    }
  }

  void _onCanvasTransformChanged() {
    if (mounted) {
      // Good practice to check if the widget is still in the tree
      setState(() {
        // This tells Flutter to rebuild widgets that depend on the state changed here.
        // In this case, it ensures CustomPaint gets the new _controller.transform.value.
      });
    }
  }

  Offset _toLocal(Offset globalPosition) {
    final canvasPoint = _controller.toLocal(globalPosition);
    final viewportSize = Size(context.size!.width, context.size!.height);
    return FigurePainter.convertGlobalToLocal(
      globalPoint: canvasPoint,
      originCoordinate: Offset(viewportSize.width / 2, viewportSize.height / 2),
      widthUnitInPixels: widthUnitInPixels,
      heightUnitInPixels: heightUnitInPixels,
    );
  }

  Offset snapPointToGrid(Offset point, Size gridSize, double threshold) {
    if (gridSize.width <= 0 || gridSize.height <= 0) {
      return point; // Avoid division by zero
    }

    // Calculate the nearest grid point by dividing, rounding, and then multiplying back.
    final dx = point.dx.round().toDouble();
    final dy = point.dy.round().toDouble();
    final snappedPoint = Offset(dx, dy);
    // Calculate the distance between the original point and the snapped point.
    final distance = (snappedPoint - point).distance;
    // If the point is within the snapping threshold, return the snapped point.
    // Otherwise, return the original point.
    if (distance < threshold) {
      return snappedPoint;
    }
    return point;
  }
}