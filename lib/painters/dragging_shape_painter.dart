import 'package:flutter/material.dart';

import '../models/planimetry/line.dart';
import 'figure_painter.dart';
import 'line_painter.dart';

enum ShowDrapProperty {
  line,
  point,
  shape,
}

class DraggingShapePainter extends FigurePainter {
  late final double minWidthUnitInPixels;
  late final double minHeightUnitInPixels;
  final Color color;
  final ShowDrapProperty showProperty;

  DraggingShapePainter(super.widthUnitInPixels, super.heightUnitInPixels, super.shape,
      this.showProperty,
      {required super.canvasTransform,
       required super.viewportSize,
       this.color = Colors.blueGrey}) {
    minWidthUnitInPixels = 0.25 * widthUnitInPixels;
    minHeightUnitInPixels = 0.25 * heightUnitInPixels;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Apply the main canvas transformation (pan/zoom from gesture detector, etc.)
    canvas.transform(canvasTransform.storage);

    final canvasOrigin = Offset(viewportSize.width / 2, viewportSize.height / 2);
    canvas.translate(canvasOrigin.dx, canvasOrigin.dy);

    if (shape == null) return;

    if (showProperty == ShowDrapProperty.line) {
      // Convert local triangle coordinates to pixel coordinates
      final line = shape as Line;

      final Offset aPos = convertLocalToGlobal(line.a.point);
      final Offset bPos = convertLocalToGlobal(line.b.point);
      if (aPos == bPos)  return;

      LinePainter.displayDashedLine(canvas: canvas, begin: aPos, end: bPos, color: color, width: 2.0);

      final Paint paintPoint = Paint()
          ..color = Colors.black
          ..strokeWidth = 2.0
          ..style = PaintingStyle.fill;
      canvas.drawCircle(aPos, 5.0, paintPoint);
      canvas.drawCircle(bPos, 5.0, paintPoint);
    }

    // Restore the canvas to its state before canvas.save()
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DraggingShapePainter oldDelegate) {
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.shape != shape ||
        oldDelegate.widthUnitInPixels != widthUnitInPixels ||
        oldDelegate.heightUnitInPixels != heightUnitInPixels ||
        oldDelegate.minHeightUnitInPixels != minHeightUnitInPixels ||
        oldDelegate.minWidthUnitInPixels != minWidthUnitInPixels;
  }
}