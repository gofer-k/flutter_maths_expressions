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
  final Offset canvasOrigin;

  CrossAxis({required this.canvasTransform, required this.viewportSize}) :
        canvasOrigin = Offset(viewportSize.width / 2, viewportSize.height / 2);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint axisPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    // Transform this point to viewport coordinates
    final Offset viewportOrigin = MatrixUtils.transformPoint(canvasTransform, canvasOrigin);

    paintAxisY(canvas, axisPaint, viewportOrigin);
    paintAxisX(canvas, axisPaint, viewportOrigin);
  }

  void paintAxisY(Canvas canvas, Paint axisPaint, Offset viewportOrigin) {
    // The x-coordinate for our vertical line in viewport space
    final double lineX = viewportOrigin.dx;

    // Only draw the line if it's within the visible viewport bounds
    // (It should always be if the canvas can pan freely, but good for robustness)
    if (lineX >= 0 && lineX <= viewportSize.width) {
      canvas.drawLine(
        Offset(lineX, 0),                            // Start from top of viewport
        Offset(lineX, viewportSize.height),        // End at bottom of viewport
        axisPaint,
      );

      paintText(canvas, 'Y', Offset(lineX - 16, 10), axisPaint);
    }
  }

  void paintAxisX(Canvas canvas, Paint axisPaint, Offset viewportOrigin) {
    // The x-coordinate for our vertical line in viewport space
    final double lineY = viewportOrigin.dy;

    // Only draw the line if it's within the visible viewport bounds
    // (It should always be if the canvas can pan freely, but good for robustness)
    if (lineY >= 0 && lineY <= viewportSize.height) {
      canvas.drawLine(
        Offset(0, lineY),                            // Start from top of viewport
        Offset(lineY, viewportSize.width),        // End at bottom of viewport
        axisPaint,
      );
      paintText(canvas, 'X', Offset(10, lineY + 16), axisPaint);
    }
  }

  void paintText(Canvas canvas, String text, Offset offset, Paint paint) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: paint.color,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: viewportSize.width);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CrossAxis oldDelegate) {
    // Repaint if the transform changes (pan/zoom) or viewport size changes
    return oldDelegate.canvasTransform != canvasTransform ||
      oldDelegate.viewportSize != viewportSize;
  }
}