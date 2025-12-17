import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/circle.dart';
import 'figure_painter.dart';

class CirclePainter extends FigurePainter {
  CirclePainter(super.widthUnitInPixels, super.heightUnitInPixels, super.shapes, {required super.canvasTransform, required super.viewportSize});

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
  }
}