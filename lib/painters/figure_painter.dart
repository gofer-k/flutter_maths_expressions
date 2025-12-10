import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';

abstract class FigurePainter<T> extends CustomPainter {
  late final Matrix4 canvasTransform;
  late final Size viewportSize;
  late double widthUnitInPixels;
  late double heightUnitInPixels;
  late final List<BaseShape>? shapes;

  FigurePainter(
    this.widthUnitInPixels,
    this.heightUnitInPixels,
    this.shapes, {
    required this.canvasTransform,
    required this.viewportSize,
  });

  static Offset convertGlobalToLocal({
    required Offset globalPoint,
    required Offset originCoordinate,
    required double widthUnitInPixels,
    required double heightUnitInPixels,
  }) {
    final localPoint = globalPoint - originCoordinate;
    return Offset(
      localPoint.dx / widthUnitInPixels,
      -localPoint.dy / heightUnitInPixels,
    );
  }

  Offset convertLocalToGlobal(Offset local) {
    return Offset(local.dx * widthUnitInPixels, -local.dy * heightUnitInPixels);
  }

  void paintText(
    Canvas canvas,
    String text,
    Offset position, {
    double xOffset = 4.0,
    double yOffset = 4.0,
  }) {
    final textStyle = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    final textSpan = TextSpan(text: text, style: textStyle);
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
      position.dx + xOffset,
      position.dy + yOffset,
    );

    textPainter.paint(canvas, adjustedPosition);
  }

  void drawAngleArc(
    Canvas canvas,
    Offset center,
    Offset leg1,
    Offset leg2,
    Color colorStroke, {
    double widthLine = 2.0,
    double arcRadius = 25.0,
    bool clockWise = true,
  }) {
    final Paint arcPaint = Paint()
      ..color = colorStroke
      ..strokeWidth = widthLine
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCircle(center: center, radius: arcRadius);

    final v1 = (leg1 - center).direction;
    final v2 = (leg2 - center).direction;

    // Ensure sweep is positive and within 0..2π
    double sweep = (v2 - v1);
    if (clockWise) {
      if (sweep < 0) sweep += 2 * pi;
    } else {
      if (sweep > 0) sweep -= 2 * pi;
    }
    canvas.drawArc(rect, v1, sweep, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant FigurePainter<T> oldDelegate) {
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.shapes != shapes ||
        oldDelegate.widthUnitInPixels != widthUnitInPixels ||
        oldDelegate.heightUnitInPixels != heightUnitInPixels ||
        oldDelegate.viewportSize != viewportSize;
  }
}
