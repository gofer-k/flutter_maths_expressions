import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planametry/triangle.dart';
import 'package:flutter_maths_expressions/painters/figure_painter.dart';

class TrianglePainter extends FigurePainter {
  final Triangle triangle;
  final double originUnitInPixels;
  final double _arcRadius = 25.0;
  late final double minUnitInPixels;

  TrianglePainter({required Matrix4 canvasTransform,
    required Size viewportSize,
    required this.triangle,
    required this.originUnitInPixels}) : super(canvasTransform, viewportSize) {
    minUnitInPixels = 0.25 * originUnitInPixels;
  }

  void _paintAngleText(Canvas canvas, String text, Offset vertex, double startAngle, double sweepAngle, Color colorText) {
    final textStyle = TextStyle(
      color: colorText,
      fontSize: 16,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate the angle of the bisector
    final double bisectorAngle = startAngle + sweepAngle / 2.0;

    // Calculate the position for the text along the bisector
    // The position is calculated from the vertex outwards
    final double x = vertex.dx + _arcRadius * cos(bisectorAngle);
    final double y = vertex.dy + _arcRadius * sin(bisectorAngle);
    final Offset textPosition = Offset(x, y);

    // Center the text on the calculated position
    final centeredOffset = Offset(
      textPosition.dx - textPainter.width / 2,
      textPosition.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, centeredOffset);
  }

  void _paintText(Canvas canvas, String text, Offset position, {double xOffset = 4.0, double yOffset = 4.0}) {
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

  void _paintArc(Canvas canvas, Offset pos, double beginAngle, double endAngle, Color colorStroke) {
    final Paint arcPaint = Paint()
      ..color = colorStroke
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCircle(center: pos, radius: _arcRadius);
    canvas.drawArc(rect, beginAngle, endAngle, false, arcPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (minUnitInPixels <= 0) return;

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

    // Convert local triangle coordinates to pixel coordinates
    final Offset aPos =
    Offset(triangle.a.dx * originUnitInPixels, -triangle.a.dy * originUnitInPixels);
    final Offset bPos =
    Offset(triangle.b.dx * originUnitInPixels, -triangle.b.dy * originUnitInPixels);
    final Offset cPos =
    Offset(triangle.c.dx * originUnitInPixels, -triangle.c.dy * originUnitInPixels);

    // 4. Convert local triangle coordinates to "scaled local" coordinates.
    // These are the coordinates in pixels as if the zoom level was 1.0,
    // relative to the origin set by canvas.translate (if any).
    // y - coordinate is negative against local cartesian coordinates.
    path.moveTo(aPos.dx, aPos.dy);
    path.lineTo(bPos.dx, bPos.dy);
    path.lineTo(cPos.dx, cPos.dy);
    path.close();
    canvas.drawPath(path, paint);

    _paintText(canvas, 'A', aPos, xOffset: -4.0, yOffset: -2.0);
    _paintText(canvas, 'B', bPos, xOffset: -4.0, yOffset: -20.0);
    _paintText(canvas, 'C', cPos, xOffset: 0.0, yOffset: -2.0);

    _paintArc(canvas, aPos, (bPos - aPos).direction, triangle.getAngleA(), Colors.red);

    _paintArc(canvas, bPos, (cPos - bPos).direction, triangle.getAngleB(), Colors.blue);

    _paintArc(canvas, cPos, (aPos - cPos).direction, triangle.getAngleC(), Colors.green);

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