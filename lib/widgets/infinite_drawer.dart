
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

  @override
  void initState() {
    super.initState();
    _controller = InfiniteCanvasController();
    _controller.transform.addListener(_onCanvasTransformChanged);
    gridSize = Size.square(20);
    unitInPixels = 2 * gridSize.width;
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
                CustomPaint(size: viewportSize, painter: shape.paint(_controller.transform.value, viewportSize, unitInPixels)),
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
                HierarchicalFABMenu(actionsDockSide: widget.actionsDockSide, insetsFab: 4.0,
                  mainMenu: [
                    if (widget.enableScaling)
                      FABMenu(true, action: FABAction(actionIcon: Icons.zoom_out_rounded),
                          [
                            FABAction(actionIcon: Icons.zoom_in_rounded),
                            FABAction(actionIcon: Icons.zoom_out_rounded),
                            FABAction(actionIcon: Icons.lock_reset_rounded),
                          ]
                      ),
                    if (widget.enablePanning)
                      FABMenu(true, action: FABAction(actionIcon: Icons.open_with_rounded),
                        [
                          FABAction(actionIcon: Icons.arrow_upward_rounded),
                          FABAction(actionIcon: Icons.arrow_back_rounded),
                          FABAction(actionIcon: Icons.arrow_forward_rounded),
                          FABAction(actionIcon: Icons.arrow_downward_rounded),
                          FABAction(actionIcon: Icons.fit_screen_rounded),
                        ]
                      ),
                  ]
                ),
            ]
          );
        }
      )
    );
  }

  // Widget _scalingWidget(BuildContext context) {
  //   return Column(
  //     children: [
  //       FloatingActionButton(
  //         mini: true, // Makes the button smaller
  //         onPressed: () {
  //           // Implement zoom in logic for _controller
  //           _controller.zoomIn();              },
  //         heroTag: "zoomInBtn", // Unique heroTag for each FAB
  //         child: const Icon(Icons.zoom_in),
  //       ),
  //       const SizedBox(height: 6), // Spacing between buttons
  //       FloatingActionButton(
  //         mini: true,
  //         onPressed: () {
  //           _controller.zoomOut();
  //         },
  //         heroTag: "zoomOutBtn",
  //         child: const Icon(Icons.zoom_out),
  //       ),
  //     ],
  //   );
  // }

  // Widget _panningWidget(BuildContext context) {
  //   final paddingScape = 6.0;
  //
  //   return  Column(
  //     crossAxisAlignment: CrossAxisAlignment.center, // Center the middle row
  //     children: [
  //       // Pan Up Button
  //       FloatingActionButton(
  //         mini: true,
  //         onPressed: () {
  //           _controller.panUp();
  //         },
  //         heroTag: "panUpBtn",
  //         child: const Icon(Icons.arrow_upward),
  //       ),
  //       SizedBox(height: paddingScape),
  //       // Middle Row: Pan Left, (Optional Spacer), Pan Right
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center, // Center buttons in the row
  //         mainAxisSize: MainAxisSize.min, // Important to keep Row compact
  //         children: [
  //           // Pan Left Button
  //           FloatingActionButton(
  //             mini: true,
  //             onPressed: () {
  //               _controller.panLeft();                      },
  //             heroTag: "panLeftBtn",
  //             child: const Icon(Icons.arrow_back),
  //           ),
  //           SizedBox(width: paddingScape),
  //           // Reset Zoom Button
  //           FloatingActionButton(
  //             mini: true,
  //             onPressed: () {
  //               _controller.zoomReset();
  //             },
  //             heroTag: "resetBtn",
  //             child: const Icon(Icons.lock_reset),
  //           ),
  //           SizedBox(width: paddingScape),
  //           // Pan Right Button
  //           FloatingActionButton(
  //             mini: true,
  //             onPressed: () {
  //               _controller.panRight();
  //             },
  //             heroTag: "panRightBtn",
  //             child: const Icon(Icons.arrow_forward),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: paddingScape),
  //       // Pan Down Button
  //       FloatingActionButton(
  //         mini: true,
  //         onPressed: () {
  //           _controller.panDown();
  //         },
  //         heroTag: "panDownBtn",
  //         child: const Icon(Icons.arrow_downward),
  //       ),
  //     ],
  //   );
  // }

  // Widget mainFloatingActions(BuildContext context) {
  //   return Positioned(
  //     left: positionLeft,
  //     right: positionRight,
  //     bottom: positionBottom,
  //     top: positionTop,
  //     child: Column(
  //       mainAxisAlignment: mainAxisAlignment, // Aligns buttons top to the bottom
  //       crossAxisAlignment: crossAxisAlignment, // Aligns buttons left to the right
  //       children: <Widget>[
  //         // Roll out/in - actions
  //
  //       // FloatingActionButton(
  //       //   mini: true, // Makes the button smaller
  //       //   onPressed: () {
  //       //
  //       //   },
  //       //   heroTag: "main", // Unique heroTag for each FAB
  //       //   child: const Icon(Icons.add_box_outlined),
  //       // ),
  //       // const SizedBox(height: 6), // Spacing between buttons
  //       ],
  //     ),
  //   );
  // }

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