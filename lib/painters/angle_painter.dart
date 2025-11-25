import 'dart:math';

import 'package:flutter/material.dart';

import '../models/planimetry/angle.dart';
import 'figure_painter.dart';

enum ShowAngleType {
  angle,
  complementary,
  supplementary,
}

class AnglePainter extends FigurePainter {
  final List<ShowAngleType> showProperties;
  final double originUnitInPixels;
  late final double minUnitInPixels;

  AnglePainter(super.unitInPixels, super.shape, this.showProperties,
      { required super.canvasTransform,
        required super.viewportSize,
        required this.originUnitInPixels}) {
    minUnitInPixels = 0.25 * originUnitInPixels;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (minUnitInPixels <= 0) return;

    // canvas.save(); // 1. Save the current canvas state

    // 2. Apply the main canvas transformation (pan/zoom from gesture detector, etc.)
    canvas.transform(canvasTransform.storage);

    final canvasOrigin = Offset(viewportSize.width / 2, viewportSize.height / 2);
    canvas.translate(canvasOrigin.dx, canvasOrigin.dy);

    if (showProperties.contains(ShowAngleType.complementary)) {
      final Paint paintLine = Paint()
        ..color = Colors.black
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final leadingAngleColor = Colors.blue;

      final followingAngleColor = Colors.red;

      final Paint paintPoint = Paint()
        ..color = Colors.green
        ..strokeWidth = 2.0
        ..style = PaintingStyle.fill;

      final angle = shape as Angle;
      final leadingLine = angle.leadingLine;
      final followingLine = angle.followingLine;

      final Offset aPos =
      Offset(leadingLine.a.dx * originUnitInPixels, -leadingLine.a.dy * originUnitInPixels);
      final Offset bPos =
      Offset(leadingLine.b.dx * originUnitInPixels, -leadingLine.b.dy * originUnitInPixels);
      final Offset cPos =
      Offset(followingLine.a.dx * originUnitInPixels, -followingLine.a.dy * originUnitInPixels);
      final Offset dPos =
      Offset(followingLine.b.dx * originUnitInPixels, -followingLine.b.dy * originUnitInPixels);

      final Offset intersectinPoint = leadingLine.getIntersection(followingLine);
      final Offset intersectinPos =
      Offset(intersectinPoint.dx * originUnitInPixels, -intersectinPoint.dx * originUnitInPixels);

      canvas.drawLine(aPos, bPos, paintLine);
      canvas.drawCircle(aPos, 5.0, paintPoint);
      canvas.drawCircle(bPos, 5.0, Paint()
        ..color = Colors.amber
        ..strokeWidth = 2.0
        ..style = PaintingStyle.fill);

      canvas.drawLine(cPos, dPos, paintLine);
      canvas.drawCircle(cPos, 5.0, paintPoint);
      canvas.drawCircle(dPos, 5.0, Paint()
        ..color = Colors.deepOrange
        ..strokeWidth = 2.0
        ..style = PaintingStyle.fill);

      canvas.drawCircle(intersectinPos, 5.0, Paint()
        ..color = Colors.purple
        ..strokeWidth = 2.0
        ..style = PaintingStyle.fill
      );
      final angleVal = angle.getAngle();
      drawAngleArc(canvas, intersectinPos,
          bPos,
          dPos,
          leadingAngleColor, arcRadius: 65.0, clockWise: angleVal >= pi ? true : false);
    }
  }

  @override
  bool shouldRepaint(covariant AnglePainter oldDelegate) {
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.shape != shape ||
        oldDelegate.originUnitInPixels != originUnitInPixels;
  }
}