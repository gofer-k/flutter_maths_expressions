import 'package:flutter/material.dart';

import '../models/planimetry/line.dart';
import 'figure_painter.dart';

enum ShowLineProperty {
  vertex,
  lineAngle,
  angleBetweenLines,
}

class LinePainter extends FigurePainter {
  final double originUnitInPixels;
  late final double minUnitInPixels;
  final List<ShowLineProperty> showProperties;

  LinePainter(super.unitInPixels, super.shape, this.showProperties,
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

    // Convert local triangle coordinates to pixel coordinates
    final line = shape as Line;

    final Offset aPos =
    Offset(line.a.dx * originUnitInPixels, -line.a.dy * originUnitInPixels);
    final Offset bPos =
    Offset(line.b.dx * originUnitInPixels, -line.b.dy * originUnitInPixels);

    canvas.drawLine(aPos, bPos, paint);

    paintText(canvas, 'A', aPos, xOffset: -4.0, yOffset: -2.0);
    paintText(canvas, 'B', bPos, xOffset: -4.0, yOffset: -20.0);

    if (showProperties.contains(ShowLineProperty.vertex)) {
      // paintArc(canvas, aPos, (bPos - aPos).direction, line.getAngleA(), Colors.red);
    }
    if (showProperties.contains(ShowLineProperty.lineAngle)) {
      // paintArc(canvas, cPos, (aPos - cPos).direction, triangle.getAngleC(), Colors.green);
    }
    if (showProperties.contains(ShowLineProperty.angleBetweenLines)) {
      // final Paint paintHeight = Paint()
      //   ..color = Colors.black26
      //   ..strokeWidth = 2.0
      //   ..style = PaintingStyle.stroke;
      // try {
      //   final m = (cPos.dy - aPos.dy) / (cPos.dx - aPos.dx);
      //   final m2 = m * m;
      //   final xD = (m2 * aPos.dx - m * (bPos.dy - aPos.dy) + bPos.dx) / (m2 + 1);
      //   final dPos = Offset(
      //       (m2 * aPos.dx - m * (bPos.dy - aPos.dy) + bPos.dx) / (m2 + 1),
      //       m * xD - m * aPos.dx + aPos.dy);
      //
      //   canvas.drawLine(bPos, dPos, paintHeight);
      //   paintText(canvas, "D", dPos, xOffset: -4.0, yOffset: -2.0);
      // } catch(e) {
      // }
    }

    // Restore the canvas to its state before canvas.save()
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.shape != shape ||
        oldDelegate.originUnitInPixels != originUnitInPixels;
  }
}