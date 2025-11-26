import 'package:flutter/cupertino.dart';
import 'figure_painter.dart';

class LegendPainter extends FigurePainter {
  final List<TextSpan> labelsSpans;
  final Offset startPosition;

  LegendPainter({
    required super.canvasTransform,
    required super.viewportSize,
    required this.labelsSpans,
    required this.startPosition}) : super(0.0, 0.0, null);

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