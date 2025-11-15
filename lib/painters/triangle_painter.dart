import 'dart:math' as logger;

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/triangle.dart';
import 'package:flutter_maths_expressions/painters/figure_painter.dart';

enum ShowTriangleProperty {
  center,
  angleA,
  angleB,
  angleC,
  height,
  heightPoint,
  medianPont,
  centroidPoint,
}

class TrianglePainter extends FigurePainter {
  // final Triangle triangle;
  final double originUnitInPixels;
  late final double minUnitInPixels;
  final List<ShowTriangleProperty> showProperties;
  
  TrianglePainter(super.unitInPixels, super.shape, this.showProperties,
    {required super.canvasTransform,
    required super.viewportSize,
    required this.originUnitInPixels}) {
    minUnitInPixels = 0.25 * originUnitInPixels;
  }

  // void _paintAngleText(Canvas canvas, String text, Offset vertex, double startAngle, double sweepAngle, Color colorText) {
  //   final textStyle = TextStyle(
  //     color: colorText,
  //     fontSize: 16,
  //   );
  //   final textSpan = TextSpan(
  //     text: text,
  //     style: textStyle,
  //   );
  //   final textPainter = TextPainter(
  //     text: textSpan,
  //     textDirection: TextDirection.ltr,
  //   );
  //   textPainter.layout();
  //
  //   // Calculate the angle of the bisector
  //   final double bisectorAngle = startAngle + sweepAngle / 2.0;
  //
  //   // Calculate the position for the text along the bisector
  //   // The position is calculated from the vertex outwards
  //   final double x = vertex.dx + _arcRadius * cos(bisectorAngle);
  //   final double y = vertex.dy + _arcRadius * sin(bisectorAngle);
  //   final Offset textPosition = Offset(x, y);
  //
  //   // Center the text on the calculated position
  //   final centeredOffset = Offset(
  //     textPosition.dx - textPainter.width / 2,
  //     textPosition.dy - textPainter.height / 2,
  //   );
  //
  //   textPainter.paint(canvas, centeredOffset);
  // }

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
    final triangle = shape as Triangle;
    final medianPoint = triangle.getMedianPoint(triangle.a, triangle.c);

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

    paintText(canvas, 'A', aPos, xOffset: -4.0, yOffset: -2.0);
    paintText(canvas, 'B', bPos, xOffset: -4.0, yOffset: -20.0);
    paintText(canvas, 'C', cPos, xOffset: 0.0, yOffset: -2.0);

    if (showProperties.contains(ShowTriangleProperty.angleA)) {
      drawAngleArc(canvas, aPos, bPos, cPos, Colors.red);
    }
    if (showProperties.contains(ShowTriangleProperty.angleB)) {
      drawAngleArc(canvas, bPos, cPos, aPos, Colors.blue);
    }
    if (showProperties.contains(ShowTriangleProperty.angleC)) {
      drawAngleArc(canvas, cPos, aPos, bPos, Colors.green);
    }
    if (showProperties.contains(ShowTriangleProperty.height)) {
      final Paint paintHeight = Paint()
        ..color = Colors.black26
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      try {
        final m = (cPos.dy - aPos.dy) / (cPos.dx - aPos.dx);
        final m2 = m * m;
        final xD = (m2 * aPos.dx - m * (bPos.dy - aPos.dy) + bPos.dx) / (m2 + 1);
        final dPos = Offset(
           (m2 * aPos.dx - m * (bPos.dy - aPos.dy) + bPos.dx) / (m2 + 1),
           m * xD - m * aPos.dx + aPos.dy);

        canvas.drawLine(bPos, dPos, paintHeight);
        paintText(canvas, "D", dPos, xOffset: -4.0, yOffset: -2.0);
      } catch(e) {
        logger.e;
      }
    }
    if (showProperties.contains(ShowTriangleProperty.medianPont)) {
      final Paint paintMedianLine = Paint()
        ..color = Colors.green
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      try {
        final Offset mPos =
        Offset(medianPoint.dx * originUnitInPixels, -medianPoint.dy * originUnitInPixels);

        canvas.drawLine(bPos, mPos, paintMedianLine);
        paintText(canvas, "M", mPos, xOffset: -4.0, yOffset: -2.0);
      } catch(e) {
        logger.e;
      }
    }
    if (showProperties.contains(ShowTriangleProperty.centroidPoint)) {
      // Define the geometry of the dashes
      const double dashWidth = 5.0; // Length of each dash
      const double dashSpace = 3.0; // Space bet

      final displayMedianLine = (Offset begin, Offset end) {
        final Paint paintMedianLine = Paint()
          ..color = Colors.green
          ..strokeWidth = 2.0;
        // Calculate the vector from start to end
        final Offset delta = end - begin;
        final double distance = delta.distance;

        // Create a direction vector (normalized)
        final Offset direction = delta / distance;
        double drawnLength = 0.0;
        // Move to the starting point
        Offset currentPoint = begin;

        while (drawnLength < distance) {
          // Calculate the end of the current dash
          final double dashEnd = drawnLength + dashWidth;
          final double remaining = distance - drawnLength;
          final double currentDashLength = dashEnd > distance
              ? remaining
              : dashWidth;

          final Offset nextPoint = currentPoint + direction * currentDashLength;

          // Draw the dash
          canvas.drawLine(currentPoint, nextPoint, paintMedianLine);

          // Move the current point for the next dash (past the dash and the space)
          currentPoint += direction * (dashWidth + dashSpace);
          drawnLength += dashWidth + dashSpace;
        }
      };
      {
        final Offset medianPoint = triangle.getMedianPoint(
            triangle.b, triangle.c);
        final Offset medianPos =
        Offset(medianPoint.dx * originUnitInPixels,
            -medianPoint.dy * originUnitInPixels);
        displayMedianLine(aPos, medianPos);
      }
      {
        final Offset medianPoint = triangle.getMedianPoint(
            triangle.a, triangle.c);
        final Offset medianPos =
        Offset(medianPoint.dx * originUnitInPixels,
            -medianPoint.dy * originUnitInPixels);
        displayMedianLine(bPos, medianPos);
      }
      {
        final Offset medianPoint = triangle.getMedianPoint(
            triangle.a, triangle.b);
        final Offset medianPos =
        Offset(medianPoint.dx * originUnitInPixels,
            -medianPoint.dy * originUnitInPixels);
        displayMedianLine(cPos, medianPos);
      }
      {
        final Offset centroidPoint = triangle.getCentroidPoint();
        final Offset centroidPos =
        Offset(centroidPoint.dx * originUnitInPixels, -centroidPoint.dy * originUnitInPixels);

        final Paint paintCentroidPoint = Paint()
          ..color = Colors.red
          ..strokeWidth = 2.0
          ..style = PaintingStyle.fill;
        canvas.drawCircle(centroidPos, 5.0, paintCentroidPoint);
      }
    }
    // Restore the canvas to its state before canvas.save()
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.shape != shape ||
        oldDelegate.originUnitInPixels != originUnitInPixels;
  }
}