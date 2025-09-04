import 'package:flutter/material.dart';
import 'package:infinite_canvas/infinite_canvas.dart';

import '../painters/cross_axes_painter.dart';
import '../widgets/background_container.dart';

class PlanametryPage extends StatefulWidget {
  final String title;
  const PlanametryPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _PlanametryPageState();
}

class _PlanametryPageState extends State<PlanametryPage> {
  late InfiniteCanvasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteCanvasController();
    _controller.transform.addListener(_onCanvasTransformChanged);
  }

  @override
  void dispose() {
    _controller.transform.removeListener(_onCanvasTransformChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
      // endColor: Colors.grey.shade800,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.title, style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
              return Stack(
                children: [
                  InfiniteCanvas(
                    controller: _controller,
                    gridSize: const Size.square(20),
                    menuVisible: false,
                    canAddEdges: true,
                    // edgesUseStraightLines: true,
                  ),
                  CustomPaint(
                    size: viewportSize,
                    painter: CrossAxesPainter(
                      canvasTransform: _controller.transform.value,
                      viewportSize: viewportSize,
                    ),
                  ),
                ]
              );
            }
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Aligns buttons to the bottom
          crossAxisAlignment: CrossAxisAlignment.end, // Aligns buttons to the right
          children: <Widget>[
            // Zoom Buttons
            FloatingActionButton(
              mini: true, // Makes the button smaller
              onPressed: () {
                // Implement zoom in logic for _controller
                final currentScale = _controller.scale;
                _controller.zoomIn();              },
              heroTag: "zoomInBtn", // Unique heroTag for each FAB
              child: const Icon(Icons.zoom_in),
            ),
            const SizedBox(height: 8), // Spacing between buttons
            FloatingActionButton(
              mini: true,
              onPressed: () {
                _controller.zoomOut();
              },
              heroTag: "zoomOutBtn",
              child: const Icon(Icons.zoom_out),
            ),
            const SizedBox(height: 16), // Spacing between groups of buttons
            // D-pad / Cross Layout for Pan Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center the middle row
              children: [
                // Pan Up Button
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    _controller.panUp();
                  },
                  heroTag: "panUpBtn",
                  child: const Icon(Icons.arrow_upward),
                ),
                const SizedBox(height: 8),
                // Middle Row: Pan Left, (Optional Spacer), Pan Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center buttons in the row
                  mainAxisSize: MainAxisSize.min, // Important to keep Row compact
                  children: [
                    FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        _controller.panLeft();                      },
                      heroTag: "panLeftBtn",
                      child: const Icon(Icons.arrow_back),
                    ),
                    // const SizedBox(width: 40), // Example: Width of a mini FAB
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        _controller.panRight();
                      },
                      heroTag: "panRightBtn",
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Pan Down Button
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    _controller.panDown();
                  },
                  heroTag: "panDownBtn",
                  child: const Icon(Icons.arrow_downward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCanvasTransformChanged() {
    print("DEBUG: _onCanvasTransformChanged called. New transform: ${_controller.transform.value.getTranslation()} Scale: ${_controller.transform.value.getMaxScaleOnAxis()}");
    if (mounted) {
      // Good practice to check if the widget is still in the tree
      setState(() {
        // This tells Flutter to rebuild widgets that depend on the state changed here.
        // In this case, it ensures CustomPaint gets the new _controller.transform.value.
      });
    }
  }
}
