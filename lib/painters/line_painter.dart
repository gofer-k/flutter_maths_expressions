import 'package:flutter/material.dart';

import '../models/planimetry/line.dart';
import 'figure_painter.dart';

enum ShowLineProperty { solid, dashed, dotted }

class LinePainter extends FigurePainter {
  late final double minWidthUnitInPixels;
  late final double minHeightUnitInPixels;
  final Color color;
  final double widhtLine;
  final List<ShowLineProperty> showProperties;

  LinePainter(
    super.widthUnitInPixels,
    super.heightUnitInPixels,
    super.shapes,
    this.showProperties, {
    required super.canvasTransform,
    required super.viewportSize,
    this.color = Colors.blueGrey,
    this.widhtLine = 1.0,
  }) {
    minWidthUnitInPixels = 0.25 * widthUnitInPixels;
    minHeightUnitInPixels = 0.25 * heightUnitInPixels;
  }

  static void displayDashedLine({
    required Canvas canvas,
    required Offset begin,
    required Offset end,
    double dashWidth = 5.0,
    double dashSpace = 3.0,
    Color color = Colors.blueGrey,
    double width = 1.0,
  }) {
    final Paint paintDashedLine = Paint()
      ..color = color
      ..strokeWidth = width;
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
    if (shapes == null && shapes!.isEmpty && shapes?.first is Line) return;

    canvas.save(); // 1. Save the current canvas state

    // Apply the main canvas transformation (pan/zoom from gesture detector, etc.)
    canvas.transform(canvasTransform.storage);

    final canvasOrigin = Offset(
      viewportSize.width / 2,
      viewportSize.height / 2,
    );
    canvas.translate(canvasOrigin.dx, canvasOrigin.dy);

    // Convert local triangle coordinates to pixel coordinates
    final line = shapes?.first as Line;

    final Offset aPos = convertLocalToGlobal(line.a.point);
    final Offset bPos = convertLocalToGlobal(line.b.point);
    if (aPos == bPos) return;

    if (showProperties.contains(ShowLineProperty.solid)) {
      final Paint paint = Paint()
        ..color = color
        ..strokeWidth = widhtLine
        ..style = PaintingStyle.stroke;
      canvas.drawLine(aPos, bPos, paint);
    }
    if (showProperties.contains(ShowLineProperty.dashed)) {
      displayDashedLine(
        canvas: canvas,
        begin: aPos,
        end: bPos,
        color: color,
        width: widhtLine,
      );
    }
    if (showProperties.contains(ShowLineProperty.dotted)) {
      displayDashedLine(
        canvas: canvas,
        begin: aPos,
        end: bPos,
        color: color,
        dashWidth: 2.0,
        dashSpace: 2.0,
        width: widhtLine,
      );
    }
    // Restore the canvas to its state before canvas.save()
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return super.shouldRepaint(oldDelegate) ||
        oldDelegate.minHeightUnitInPixels != minHeightUnitInPixels ||
        oldDelegate.minWidthUnitInPixels != minWidthUnitInPixels;
  }
}
