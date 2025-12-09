import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/angle.dart';

import '../models/planimetry/polygon.dart';
import 'figure_painter.dart';

class PolygonPainter extends FigurePainter {
  final Color angleColor;
  final bool enableDrapDrop;
  late final double minWidthUnitInPixels;
  late final double minHeightUnitInPixels;

  PolygonPainter(
    super.widthUnitInPixels,
    super.heightUnitInPixels,
    super.shape, {
    required super.canvasTransform,
    required super.viewportSize,
    required this.angleColor,
    this.enableDrapDrop = false,
  }) {
    minWidthUnitInPixels = 0.25 * widthUnitInPixels;
    minHeightUnitInPixels = 0.25 * heightUnitInPixels;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (shapes == null && shapes!.isEmpty && shapes?.first is Polygon) return;

    // Apply the main canvas transformation (pan/zoom from gesture detector, etc.)
    canvas.transform(canvasTransform.storage);

    final canvasOrigin = Offset(
      viewportSize.width / 2,
      viewportSize.height / 2,
    );
    canvas.translate(canvasOrigin.dx, canvasOrigin.dy);

    final Paint paintLine = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint fixedPaintPoint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    final Paint draggablePaintPoint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    final polygon = shapes?.first as Polygon;
    if (polygon.lines.length < 3) {
      return;
    }

    final pointLabels = polygon.getVertexLabels();

    Path path = Path();
    Offset currentPos = convertLocalToGlobal(polygon.lines.first.a.point);
    path.moveTo(currentPos.dx, currentPos.dy);

    for (int i = 0; i < polygon.lines.length; i++) {
      // Identify the lines that form the current vertex
      final currentLine = polygon.lines[i];
      // The previous line is the last one in the list if we are at the first vertex
      final previousLine =
          polygon.lines[(i - 1 + polygon.lines.length) % polygon.lines.length];

      // Get the global coordinates of the three points defining the vertex
      final currentVertexPoint = convertLocalToGlobal(currentLine.a.point);
      final nextVertexPoint = convertLocalToGlobal(currentLine.b.point);
      final previousVertexPoint = convertLocalToGlobal(previousLine.a.point);

      // Draw the path segment
      path.lineTo(nextVertexPoint.dx, nextVertexPoint.dy);

      // --- Calculate Label Offset ---
      // Get vectors pointing away from the current vertex
      final vec1 = (previousVertexPoint - currentVertexPoint);
      final vec2 = (nextVertexPoint - currentVertexPoint);

      // The exterior angle bisector is the sum of the normalized vectors
      final bisector = (vec1 / vec1.distance) + (vec2 / vec2.distance);

      // Normalize the bisector and scale it to define the offset distance
      // This positions the label outside the polygon.
      // The `12.0` is a configurable distance for the label from its point.
      // final labelOffset = bisector.distance > 1e-6
      //     ? (bisector / bisector.distance) * 15.0
      //     : Offset(0, 15); // Fallback for straight lines (180-degree angle)
      final labelOffset = bisector.distance > 1e-6
          ? -(bisector / bisector.distance) * 10.0
          : Offset(0, 10); // Fallback for straight lines (180-degree angle)

      // Draw the vertex point
      final paintPoint = currentLine.isDraggable()
          ? draggablePaintPoint
          : fixedPaintPoint;
      canvas.drawCircle(currentVertexPoint, 5.0, paintPoint);

      // --- Paint the text with the dynamically calculated offset ---
      final label = pointLabels[i];
      paintText(
        canvas,
        label,
        currentVertexPoint,
        xOffset: labelOffset.dx,
        yOffset: labelOffset.dy,
      );
    }
    path.close();
    canvas.drawPath(path, paintLine);

    for (int idx = 0; idx < polygon.lines.length; ++idx) {
      int nextIndex = (idx + 1) % polygon.lines.length;
      final line = polygon.lines[idx];
      final leadingLine = line.reserved();
      final followingLine = polygon.lines[nextIndex];

      if (leadingLine.a.point == followingLine.a.point) {
        final angle = Angle(
          leadingLine: leadingLine,
          followingLine: followingLine,
        );
        final angleVal = angle.getAngle();
        drawAngleArc(
          canvas,
          convertLocalToGlobal(leadingLine.a.point),
          convertLocalToGlobal(leadingLine.b.point),
          convertLocalToGlobal(followingLine.b.point),
          angleColor,
          arcRadius: 25.0,
          clockWise: angleVal >= pi ? true : false,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PolygonPainter oldDelegate) {
    return super.shouldRepaint(oldDelegate) ||
        oldDelegate.minHeightUnitInPixels != minHeightUnitInPixels ||
        oldDelegate.minWidthUnitInPixels != minWidthUnitInPixels;
  }
}
