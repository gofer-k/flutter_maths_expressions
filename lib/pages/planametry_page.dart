import 'package:flutter/material.dart';
import 'package:infinite_canvas/infinite_canvas.dart';

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
  }

  @override
  void dispose() {
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                    edgesUseStraightLines: true,
                  ),
                  CustomPaint(
                    size: viewportSize,
                    painter: CrossAxis(
                      canvasTransform: _controller.transform.value,
                      viewportSize: viewportSize,
                    ),
                  ),
                ]
              );
            }
          )
        ),
      ),
    );
  }
}

class CrossAxis extends CustomPainter {
  final Matrix4 canvasTransform;
  final Size viewportSize;

  CrossAxis({required this.canvasTransform, required this.viewportSize});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.0;

    // We want the line to be at X=0 in the *canvas* coordinate system.
    // We need to find where X=0 of the canvas is on the viewport.

    // Create a point representing (0, any_y) in canvas coordinates
    final Offset canvasOrigin = Offset(0, 0);

    // Transform this point to viewport coordinates
    final Offset viewportOrigin = MatrixUtils.transformPoint(canvasTransform, canvasOrigin);

    // The x-coordinate for our vertical line in viewport space
    final double lineX = viewportOrigin.dx;

    // Only draw the line if it's within the visible viewport bounds
    // (It should always be if the canvas can pan freely, but good for robustness)
    if (lineX >= 0 && lineX <= viewportSize.width) {
      canvas.drawLine(
        Offset(lineX, 0),                            // Start from top of viewport
        Offset(lineX, viewportSize.height),        // End at bottom of viewport
        linePaint,
      );
    }

    // The x-coordinate for our vertical line in viewport space
    final double lineY = viewportOrigin.dy;

    // Only draw the line if it's within the visible viewport bounds
    // (It should always be if the canvas can pan freely, but good for robustness)
    if (lineY >= 0 && lineY <= viewportSize.height) {
      canvas.drawLine(
        Offset(0, lineY),                            // Start from top of viewport
        Offset(lineY, viewportSize.width),        // End at bottom of viewport
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CrossAxis oldDelegate) {
    // Repaint if the transform changes (pan/zoom) or viewport size changes
    return oldDelegate.canvasTransform != canvasTransform ||
      oldDelegate.viewportSize != viewportSize;
  }
}