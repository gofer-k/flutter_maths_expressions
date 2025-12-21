import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/circle.dart';

import 'figure_painter.dart';

enum ShowCircleProperty { fullCircle, circularSegment }

class CirclePainter extends FigurePainter {
  final double? chordHeight;
  final List<ShowCircleProperty> showCircleProperty;

  CirclePainter(
    super.widthUnitInPixels,
    super.heightUnitInPixels,
    super.shapes,
    this.showCircleProperty, {
    required super.canvasTransform,
    required super.viewportSize,
    this.chordHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (shapes == null && shapes!.isEmpty && shapes?.first is Circle) return;

    // Apply the main canvas transformation (pan/zoom from gesture detector, etc.)
    canvas.transform(canvasTransform.storage);

    final canvasOrigin = Offset(
      viewportSize.width / 2,
      viewportSize.height / 2,
    );
    canvas.translate(canvasOrigin.dx, canvasOrigin.dy);

    final Paint paintCircle = Paint()
      ..color = Colors.black12
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final circle = shapes?.first as Circle;
    if (circle.radius < 0.01) {
      return;
    }
    final centerPoint = convertLocalToGlobal(circle.center);
    final radiusInGlobal = circle.radius * heightUnitInPixels;
    canvas.drawCircle(centerPoint, radiusInGlobal, paintCircle);

    if (showCircleProperty.contains(ShowCircleProperty.circularSegment) &&
        chordHeight != null) {
      final Paint paintCircularSegment = Paint()
        ..color = Colors.purpleAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.fill;

      final double theta =
          2.0 * acos((circle.radius - chordHeight!) / circle.radius);
      final double startAngle = -theta / 2 + pi / 2;
      final double sweepAngle = theta;

      // Compute end points of chord on the circle
      final Offset p1 =
          centerPoint +
          Offset(
            cos(startAngle) * radiusInGlobal,
            sin(startAngle) * radiusInGlobal,
          );
      final Path path = Path()
        ..moveTo(p1.dx, p1.dy)
        // arc along the circle between p1 and p2
        ..arcTo(
          Rect.fromCircle(center: centerPoint, radius: radiusInGlobal),
          startAngle,
          sweepAngle,
          false,
        )
        // close with the chord (straight line p2 -> p1)
        ..lineTo(p1.dx, p1.dy)
        ..close();
      canvas.drawPath(path, paintCircularSegment);
    }
  }
}
