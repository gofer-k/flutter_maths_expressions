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
  bisector,
  midsegment,
  circumcenter,
  incenter
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

  void _displayDashedLine({required Canvas canvas, required Offset begin, required Offset end, double dashWidth = 5.0, double dashSpace = 3.0}) {
    final Paint paintDashedLine = Paint()
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
      canvas.drawLine(currentPoint, nextPoint, paintDashedLine);

      // Move the current point for the next dash (past the dash and the space)
      currentPoint += direction * (dashWidth + dashSpace);
      drawnLength += dashWidth + dashSpace;
    }
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
    final triangle = shape as Triangle;
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
        final medianPoint = triangle.getMedianPoint(triangle.a, triangle.c);
        final Offset mPos =
        Offset(medianPoint.dx * originUnitInPixels, -medianPoint.dy * originUnitInPixels);

        canvas.drawLine(bPos, mPos, paintMedianLine);
        paintText(canvas, "M", mPos, xOffset: -4.0, yOffset: -2.0);
      } catch(e) {
        logger.e;
      }
    }
    if (showProperties.contains(ShowTriangleProperty.centroidPoint)) {
      {
        final Offset medianPoint = triangle.getMedianPoint(
            triangle.b, triangle.c);
        final Offset medianPos =
        Offset(medianPoint.dx * originUnitInPixels,
            -medianPoint.dy * originUnitInPixels);
        _displayDashedLine(canvas: canvas, begin: aPos, end: medianPos);
        paintText(canvas, r"M_a", medianPos, xOffset: 4.0, yOffset: -20.0);
      }
      {
        final Offset medianPoint = triangle.getMedianPoint(
            triangle.a, triangle.c);
        final Offset medianPos =
        Offset(medianPoint.dx * originUnitInPixels,
            -medianPoint.dy * originUnitInPixels);
        _displayDashedLine(canvas: canvas, begin: bPos, end: medianPos);
        paintText(canvas, r"M_b", medianPos, xOffset: -8.0, yOffset: 2.0);
      }
      {
        final Offset medianPoint = triangle.getMedianPoint(
            triangle.a, triangle.b);
        final Offset medianPos =
        Offset(medianPoint.dx * originUnitInPixels,
            -medianPoint.dy * originUnitInPixels);
        _displayDashedLine(canvas: canvas, begin: cPos, end: medianPos);
        paintText(canvas, r"M_c", medianPos, xOffset: -36.0, yOffset: -20.0);
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
        paintText(canvas, r"C_p", centroidPos, xOffset: 2.0, yOffset: 1.0);
      }
    }
    if (showProperties.contains(ShowTriangleProperty.bisector)) {
      try {
        final Offset bisectorPoint = triangle.getBisectorPoint(triangle.b, triangle.a, triangle.c);
        final Offset bisectorPos =
        Offset(bisectorPoint.dx * originUnitInPixels, -bisectorPoint.dy * originUnitInPixels);

        _displayDashedLine(canvas: canvas, begin: bPos, end: bisectorPos);
        paintText(canvas, "P", bisectorPos, xOffset: -4.0, yOffset: -2.0);
        drawAngleArc(canvas, bPos, bisectorPos, aPos, Colors.red);
        drawAngleArc(canvas, bPos, bisectorPos, aPos, Colors.red, arcRadius: 30);
        drawAngleArc(canvas, bPos, cPos, bisectorPos, Colors.blue);
        drawAngleArc(canvas, bPos, cPos, bisectorPos, Colors.blue, arcRadius: 30);
      } catch(e) {
        logger.e;
      }
    }
    if (showProperties.contains(ShowTriangleProperty.midsegment)) {
      try {
        final Paint paintPoint = Paint()
          ..color = Colors.red
          ..strokeWidth = 2.0
          ..style = PaintingStyle.fill;

        final midSegment = triangle.getMidsegment(triangle.b, triangle.a, triangle.c);
        final Offset dPos =
        Offset(midSegment.first.dx * originUnitInPixels,
            -midSegment.first.dy * originUnitInPixels);
        final Offset ePos =
        Offset(midSegment.last.dx * originUnitInPixels,
            -midSegment.last.dy * originUnitInPixels);
        _displayDashedLine(canvas: canvas, begin: dPos, end: ePos);
        canvas.drawCircle(dPos, 5.0, paintPoint);
        canvas.drawCircle(ePos, 5.0, paintPoint);
        paintText(canvas, "D", midSegment.first, xOffset: -4.0, yOffset: -2.0);
        paintText(canvas, "E", midSegment.first, xOffset: -4.0, yOffset: -2.0);
      } catch(e) {
        logger.e;
      }
    }
    if (showProperties.contains(ShowTriangleProperty.circumcenter)) {
      try {
        final Paint paintPoint = Paint()
          ..color = Colors.red
          ..strokeWidth = 2.0
          ..style = PaintingStyle.fill;

        final circumcenter = triangle.getCircumcenter();
        final Offset oPos =
        Offset(circumcenter.dx * originUnitInPixels, -circumcenter.dy * originUnitInPixels);
        {
          final medPoint = triangle.getMedianPoint(triangle.a, triangle.b);
          final Offset mPos =
          Offset(medPoint.dx * originUnitInPixels, -medPoint.dy * originUnitInPixels);
          _displayDashedLine(canvas: canvas, begin: oPos, end: mPos);
        }
        {
          final medPoint = triangle.getMedianPoint(triangle.a, triangle.c);
          final Offset mPos =
          Offset(medPoint.dx * originUnitInPixels, -medPoint.dy * originUnitInPixels);
          _displayDashedLine(canvas: canvas, begin: oPos, end: mPos);
        }
        {
          final medPoint = triangle.getMedianPoint(triangle.b, triangle.c);
          final Offset mPos =
          Offset(medPoint.dx * originUnitInPixels, -medPoint.dy * originUnitInPixels);
          _displayDashedLine(canvas: canvas, begin: oPos, end: mPos);
        }
        canvas.drawCircle(oPos, 5.0, paintPoint);
        paintText(canvas, "O", oPos, xOffset: -4.0, yOffset: -2.0);

        final rc = (oPos - aPos).distance;
        canvas.drawCircle(oPos, rc, Paint()
          ..color = Colors.grey.shade800
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke);
      } catch(e) {
        logger.e;
      }
    }
    if (showProperties.contains(ShowTriangleProperty.incenter)) {
      try {
        final Paint paintPoint = Paint()
          ..color = Colors.red
          ..strokeWidth = 2.0
          ..style = PaintingStyle.fill;

        final incenter = triangle.getIncenter();
        final Offset oPos =
        Offset(incenter.dx * originUnitInPixels, -incenter.dy * originUnitInPixels);
        final bisectorAPoint = triangle.getBisectorPoint(triangle.a, triangle.b, triangle.c);
        final Offset bisectorAPos =
        Offset(bisectorAPoint.dx * originUnitInPixels, -bisectorAPoint.dy * originUnitInPixels);
        {
          _displayDashedLine(canvas: canvas, begin: oPos, end: bisectorAPos);
        }
        {
          final bisectorPoint = triangle.getBisectorPoint(triangle.b, triangle.c, triangle.a);
          final Offset bisectorPos =
          Offset(bisectorPoint.dx * originUnitInPixels, -bisectorPoint.dy * originUnitInPixels);
          _displayDashedLine(canvas: canvas, begin: oPos, end: bisectorPos);
        }
        {
          final bisectorPoint = triangle.getBisectorPoint(triangle.c, triangle.a, triangle.b);
          final Offset bisectorPos =
          Offset(bisectorPoint.dx * originUnitInPixels, -bisectorPoint.dy * originUnitInPixels);
          _displayDashedLine(canvas: canvas, begin: oPos, end: bisectorPos);
        }
        canvas.drawCircle(oPos, 5.0, paintPoint);
        paintText(canvas, "O", oPos, xOffset: -4.0, yOffset: -2.0);

        final ri = (oPos - bisectorAPos).distance;
        canvas.drawCircle(oPos, ri, Paint()
          ..color = Colors.grey.shade800
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke);
      } catch(e) {
        logger.e;
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