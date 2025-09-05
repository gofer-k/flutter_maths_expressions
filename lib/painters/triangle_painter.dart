import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planametry/triangle.dart';
import 'package:flutter_maths_expressions/painters/figure_painter.dart';

class TrianglePainter extends FigurePainter {
  final Triangle triangle;
  final double originUnitInPixels;
  late final double minUnitInPixels;

  TrianglePainter({required Matrix4 canvasTransform,
    required Size viewportSize,
    required this.triangle,
    required this.originUnitInPixels}) : super(canvasTransform, viewportSize) {
    // TODO: Refactor this property to base class
    this.minUnitInPixels = 0.25 * originUnitInPixels;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (this.minUnitInPixels <= 0) return;

    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.save(); // 1. Save the current canvas state

    // 2. Apply the main canvas transformation (pan/zoom from gesture detector, etc.)
    canvas.transform(canvasTransform.storage);

    final canvasOrigin = Offset(viewportSize.width / 2, viewportSize.height / 2);
    canvas.translate(canvasOrigin.dx, canvasOrigin.dy);

    Path path = Path();

    // 4. Convert local triangle coordinates to "scaled local" coordinates.
    // These are the coordinates in pixels as if the zoom level was 1.0,
    // relative to the origin set by canvas.translate (if any).
    // y - coordinate is negative against local cartesian coordinates.
    path.moveTo(triangle.a.dx * originUnitInPixels, -triangle.a.dy * originUnitInPixels);
    path.lineTo(triangle.b.dx * originUnitInPixels, -triangle.b.dy * originUnitInPixels);
    path.lineTo(triangle.c.dx * originUnitInPixels, -triangle.c.dy * originUnitInPixels);
    path.close();
    canvas.drawPath(path, paint);

    // Restore the canvas to its state before canvas.save()
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.triangle != triangle ||
        oldDelegate.originUnitInPixels != originUnitInPixels;
  }
}