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

    final canvasOrigin = Offset(viewportSize.width / 2, viewportSize.height / 2);

    // This is the scaling factor to apply to your triangle's coordinates.
    // It's derived from how many pixels represent one unit (using the INSTANCE variable),
    // adjusted by the current canvas scale.
    // Use 'this.minUnitInPixels' here
    final double effectiveScale = this.minUnitInPixels * this.canvasTransform.getMaxScaleOnAxis();

    Path path = Path();

    // Apply the canvas transform to the canvas before drawing.
    canvas.save(); // Save the current canvas state

    canvas.transform(canvasTransform.storage); // Apply the Matrix4 transformation
    canvas.translate(canvasOrigin.dy, canvasOrigin.dy);

    // Scale the triangle points using their dx/dy properties and the effectiveScale
    path.moveTo(triangle.a.dx * effectiveScale, triangle.a.dy * effectiveScale);
    path.lineTo(triangle.b.dx * effectiveScale, triangle.b.dy * effectiveScale);
    path.lineTo(triangle.c.dx * effectiveScale, triangle.c.dy * effectiveScale);
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