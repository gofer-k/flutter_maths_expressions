import 'dart:math';

import 'package:flutter/material.dart';

import '../models/planimetry/angle.dart';
import 'figure_painter.dart';

enum ShowAngleType {
  angle,
  complementary,
  supplementary,
}

enum ShowProperty {
  line,
  points,
  interception,
  enableDrapDrop
}

class AnglePainter extends FigurePainter {
  final Color angleColor;
  final double widthLine;
  final double arcRadius;
  final List<ShowProperty> showProperties;
  late final double minWidthUnitInPixels;
  late final double minHeightUnitInPixels;

  AnglePainter(super.widthUnitInPixels, super.heightUnitInPixels, super.shape,
      this.showProperties,
      { required super.canvasTransform,
        required super.viewportSize,
        required this.angleColor,
        this.widthLine = 2.0,
        this.arcRadius = 25.0
      }) {
    minWidthUnitInPixels = 0.25 * widthUnitInPixels;
    minHeightUnitInPixels = 0.25 * heightUnitInPixels;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (minWidthUnitInPixels <= 0 || minHeightUnitInPixels <= 0) return;

    // Apply the main canvas transformation (pan/zoom from gesture detector, etc.)
    canvas.transform(canvasTransform.storage);

    final canvasOrigin = Offset(viewportSize.width / 2, viewportSize.height / 2);
    canvas.translate(canvasOrigin.dx, canvasOrigin.dy);

    final angle = shape as Angle;
    final leadingLine = angle.leadingLine;
    final followingLine = angle.followingLine;

    final Offset aPos = convertLocalToGlobal(leadingLine.a.point);
    final Offset bPos = convertLocalToGlobal(leadingLine.b.point);
    final Offset cPos = convertLocalToGlobal(followingLine.a.point);
    final Offset dPos = convertLocalToGlobal(followingLine.b.point);

    final Offset intersectinPoint = leadingLine.getIntersection(followingLine);
    final Offset intersectinPos = convertLocalToGlobal(intersectinPoint);

    if (showProperties.contains(ShowProperty.line)) {
      final Paint paintLine = Paint()
        ..color = Colors.black
        ..strokeWidth = widthLine
        ..style = PaintingStyle.stroke;

      canvas.drawLine(aPos, bPos, paintLine);
      canvas.drawLine(cPos, dPos, paintLine);
    }

    final Paint fixedPaintPoint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    if (showProperties.contains(ShowProperty.points)) {
      final Paint draggablePaintPoint = Paint()
        ..color = Colors.green
        ..strokeWidth = 3.0
        ..style = PaintingStyle.fill;

      canvas.drawCircle(aPos, 5.0, leadingLine.a.enableDragging ? draggablePaintPoint : fixedPaintPoint);
      canvas.drawCircle(bPos, 5.0, leadingLine.b.enableDragging ? draggablePaintPoint : fixedPaintPoint);
      canvas.drawCircle(cPos, 5.0, followingLine.a.enableDragging ? draggablePaintPoint : fixedPaintPoint);
      canvas.drawCircle(dPos, 5.0, followingLine.b.enableDragging ? draggablePaintPoint : fixedPaintPoint);
    }

    if(intersectinPos.isFinite && showProperties.contains(ShowProperty.interception)) {
      canvas.drawCircle(intersectinPos, 5.0, fixedPaintPoint);
      final angleVal = angle.getAngle();
      drawAngleArc(canvas, intersectinPos,
          bPos,
          dPos,
          angleColor,
          widthLine: widthLine,
          arcRadius: arcRadius, clockWise: angleVal >= pi ? true : false);
    }
  }

  @override
  bool shouldRepaint(covariant AnglePainter oldDelegate) {
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.shape != shape ||
        oldDelegate.minHeightUnitInPixels != minHeightUnitInPixels ||
        oldDelegate.minWidthUnitInPixels != minWidthUnitInPixels ||
        oldDelegate.widthLine != widthLine ||
        oldDelegate.arcRadius != arcRadius ||
        oldDelegate.angleColor != angleColor;
  }
}