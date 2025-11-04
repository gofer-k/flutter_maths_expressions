import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';

abstract class FigurePainter<T> extends CustomPainter {
  late final Matrix4 canvasTransform;
  late final Size viewportSize;
  late final double? unitInPixels;
  late final BaseShape? shape;

  FigurePainter(this.unitInPixels, this.shape, {required this.canvasTransform, required this.viewportSize});

  void paintText(Canvas canvas, String text, Offset position, {double xOffset = 4.0, double yOffset = 4.0}) {
    final textStyle = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 100, // Arbitrary max width
    );

    // Adjust the position to be slightly offset from the vertex
    final adjustedPosition = Offset(
        position.dx + xOffset, position.dy + yOffset);

    textPainter.paint(canvas, adjustedPosition);
  }

  // TODO: Arc direction is not correct after rotate and translate a shape
  void paintArc(Canvas canvas, Offset pos, double beginAngle, double endAngle, Color colorStroke, {double arcRadius = 25.0}) {
    final Paint arcPaint = Paint()
      ..color = colorStroke
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCircle(center: pos, radius: arcRadius);
    canvas.drawArc(rect, beginAngle, endAngle, false, arcPaint);
  }
}