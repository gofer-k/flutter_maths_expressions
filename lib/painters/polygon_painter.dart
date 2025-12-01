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

  PolygonPainter(super.widthUnitInPixels, super.heightUnitInPixels, super.shape,
      { required super.canvasTransform,
        required super.viewportSize,
        required this.angleColor,
        this.enableDrapDrop = false,
      }) {
    minWidthUnitInPixels = 0.25 * widthUnitInPixels;
    minHeightUnitInPixels = 0.25 * heightUnitInPixels;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Apply the main canvas transformation (pan/zoom from gesture detector, etc.)
    canvas.transform(canvasTransform.storage);

    final canvasOrigin = Offset(viewportSize.width / 2, viewportSize.height / 2);
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

    final polygon = shape as Polygon;
    if (polygon.lines.length < 3) {
      return;
    }

    Path path = Path();

    Offset currentPos = convertLocalToGlobal(polygon.lines.first.a.point);
    path.moveTo(currentPos.dx, currentPos.dy);

    for (final line in polygon.lines) {
      final Offset nextPos = convertLocalToGlobal(line.b.point);
      path.lineTo(nextPos.dx, nextPos.dy);
      canvas.drawCircle(currentPos, 5.0, polygon.lines.first.isDraggable() ? draggablePaintPoint : fixedPaintPoint);
      currentPos = nextPos;
    }
    path.close();
    canvas.drawPath(path, paintLine);

    for (int currIndex = 0; currIndex < polygon.lines.length; ++currIndex) {
      int nextIndex = (currIndex + 1) % polygon.lines.length;
      final leadingLine = polygon.lines[currIndex].reserved();
      final followingLine = polygon.lines[nextIndex];

      if (leadingLine.a.point == followingLine.a.point) {
        final angle = Angle(leadingLine: leadingLine, followingLine: followingLine);
        final angleVal = angle.getAngle();
        drawAngleArc(canvas,
          convertLocalToGlobal(leadingLine.a.point),
          convertLocalToGlobal(leadingLine.b.point),
          convertLocalToGlobal(followingLine.b.point),
          angleColor, arcRadius: 25.0, clockWise: angleVal >= pi ? true : false);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PolygonPainter oldDelegate) {
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.shape != shape ||
        oldDelegate.minHeightUnitInPixels != minHeightUnitInPixels ||
        oldDelegate.minWidthUnitInPixels != minWidthUnitInPixels;
  }
}