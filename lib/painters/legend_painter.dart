import 'package:flutter/cupertino.dart';
import 'figure_painter.dart';

class LegendPainter extends FigurePainter {
  final List<TextSpan> labelsSpans;
  final Offset startPosition;

  LegendPainter({
    required Matrix4 canvasTransform,
    required Size viewportSize,
    required this.labelsSpans,
    required this.startPosition}) : super(canvasTransform, viewportSize);

  @override
  void paint(Canvas canvas, Size size) {
    double currentX = startPosition.dx;
    final double y = startPosition.dy;

    for (final span in labelsSpans) {
      final textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(currentX, y));
      currentX += textPainter.width;
    }
  }

  @override
  bool shouldRepaint(covariant LegendPainter oldDelegate) {
    return startPosition != oldDelegate.startPosition ||
      labelsSpans != oldDelegate.labelsSpans;
  }

}