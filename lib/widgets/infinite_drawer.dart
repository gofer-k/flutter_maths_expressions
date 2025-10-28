
import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/hierarchical_fab_menu.dart';
import 'package:infinite_canvas/infinite_canvas.dart';

import '../models/dock_side.dart';
import '../painters/cross_axes_painter.dart';
import '../painters/drawable_shape.dart';
import '../painters/legend_painter.dart';

class InfiniteDrawer extends StatefulWidget {
  final bool enableRotation;
  final bool enablePanning;
  final bool enableScaling;
  final bool enableCrossAxes;
  final DockSide actionsDockSide;
  final List<DrawableShape> drawableShapes;

  const InfiniteDrawer({super.key,
    this.enableRotation = true,
    this.enablePanning = true,
    this.enableScaling = true,
    this.enableCrossAxes = true,
    this.actionsDockSide = DockSide.rightBottom, required this.drawableShapes,
  });

  @override
  State<StatefulWidget> createState() => _InfiniteDrawerState();
}

class _InfiniteDrawerState extends State<InfiniteDrawer> {
  late InfiniteCanvasController _controller;
  late Size gridSize;
  late double unitInPixels;
  late HierarchicalFABMenu _fabMenu;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteCanvasController();
    _controller.transform.addListener(_onCanvasTransformChanged);
    gridSize = Size.square(20);
    unitInPixels = 2 * gridSize.width;

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
    const gridSize = Size.square(20);
    final unitInPixels = 2 * gridSize.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
          return Stack(
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
                    originUnitInPixels: unitInPixels, // Adjust as needed
                  ),
                ),
              for (final shape in widget.drawableShapes) ...[
                ClipRect(
                  child: CustomPaint(size: viewportSize,
                    painter: shape.paint(_controller.transform.value,
                    viewportSize,
                    unitInPixels))),
                CustomPaint(size: viewportSize, painter:
                  LegendPainter(
                    canvasTransform: _controller.transform.value,
                    viewportSize: viewportSize,
                    labelsSpans: shape.labelsSpans,
                    startPosition: Offset(viewportSize.width - 100, 0.95)
                  )
                ),
              ],
              if (widget.enableRotation || widget.enablePanning || widget.enableScaling)
              // FAB menu instance should created while initState() when the widget's state be persist.
              // Or FAB menu hasn't to persist its state that may be created here.
                _fabMenu
            ]
          );
        }
      )
    );
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
}