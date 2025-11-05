import 'package:flutter/material.dart';

class CrossAxesPainter extends CustomPainter {
  final Matrix4 canvasTransform;
  final Size viewportSize;
  final Offset canvasOrigin;
  final double originWidthUnitInPixels;
  final double originHeightUnitInPixels;
  late final double minWidthUnitInPixels;
  late final double minHeightUnitInPixels;

  CrossAxesPainter({required this.canvasTransform, required this.viewportSize,
    required this.originWidthUnitInPixels, required this.originHeightUnitInPixels}) :
    canvasOrigin = Offset(viewportSize.width / 2, viewportSize.height / 2) {
    // TODO: Refactor this property to base class
    minWidthUnitInPixels = 0.25 * originWidthUnitInPixels;
    minHeightUnitInPixels = 0.25 * originHeightUnitInPixels;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint axisPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    final Paint unitMarkPaint = Paint()
      ..color = Colors.black54 // Color for unit marks
      ..strokeWidth = 1.0;

    final TextStyle unitLabelStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    // Transform this point to viewport coordinates
    final Offset viewportOrigin = MatrixUtils.transformPoint(canvasTransform, canvasOrigin);
    final double currentScale = canvasTransform.getMaxScaleOnAxis();
    final double unitWidthInPixels = originWidthUnitInPixels * currentScale;
    final double unitHeightPixels = originHeightUnitInPixels * currentScale;

    paintAxisY(canvas, axisPaint, unitMarkPaint, unitLabelStyle, viewportOrigin, unitHeightPixels);
    paintAxisX(canvas, axisPaint, unitMarkPaint, unitLabelStyle, viewportOrigin, unitWidthInPixels);
  }

  void paintAxisY(
    Canvas canvas,
    Paint axisPaint,
    Paint unitMarkPaint,
    TextStyle unitLabelStyle,
    Offset viewportOrigin,
    double unitInPixels) {
    final double lineX = viewportOrigin.dx;
    const double markLength = 8.0;   // Length of the small tick marks

    drawUnitsY(bool positive, double start, double end, double step) {
      for (double y = start; positive ? y >= end : y <= end; y += step) {
        if (positive && y > viewportSize.height ||
            !positive && y < 0) {
          continue; // Skip if way off screen
        }
        canvas.drawLine(
          Offset(lineX - markLength / 2, y),
          Offset(lineX + markLength / 2, y),
          unitMarkPaint,
        );
        // Calculate unit number (adjusting for screen coordinates vs. cartesian)
        int unitNumber = -((y - viewportOrigin.dy) / unitInPixels).round();
        if (unitNumber == 0) continue; // Don't redraw 0
        _drawText(canvas, unitNumber.toString(), Offset(lineX + markLength, y), unitLabelStyle, isXAxis: false);
      }
    }

    if (lineX >= 0 && lineX <= viewportSize.width) {
      canvas.drawLine(
        Offset(lineX, 0),
        Offset(lineX, viewportSize.height),
        axisPaint,
      );

      if (unitInPixels >= minHeightUnitInPixels) {
        drawUnitsY(true, viewportOrigin.dy - unitInPixels, 0, -unitInPixels);
        drawUnitsY(false, viewportOrigin.dy + unitInPixels, viewportSize.height, unitInPixels);
      }
    }
  }

  void paintAxisX(
    Canvas canvas,
    Paint axisPaint,
    Paint unitMarkPaint,
    TextStyle unitLabelStyle,
    Offset viewportOrigin,
    double unitInPixels) {
    final double lineY = viewportOrigin.dy;
    const double markLength = 8.0;

    drawUnitsX(bool positive, double start, double end, double step) {
      for (double x = start; positive ? x <= end : x >= end; x += step) {
        if (positive && x < 0 ||
            !positive && x > viewportSize.width) {
          continue;
        }
        canvas.drawLine(
          Offset(x, lineY - markLength / 2),
          Offset(x, lineY + markLength / 2),
          unitMarkPaint,
        );
        int unitNumber = ((x - viewportOrigin.dx) / unitInPixels).round();
        if (unitNumber == 0) continue;
        _drawText(canvas, unitNumber.toString(), Offset(x, lineY + markLength), unitLabelStyle, isXAxis: true);
      }
    }

    if (lineY >= 0 && lineY <= viewportSize.height) {
      canvas.drawLine(
        Offset(0, lineY),
        Offset(viewportSize.width, lineY),
        axisPaint,
      );

      if (unitInPixels >= minWidthUnitInPixels) {
        drawUnitsX(true, viewportOrigin.dx + unitInPixels, viewportSize.width, unitInPixels);
        drawUnitsX(false, viewportOrigin.dx - unitInPixels, 0, -unitInPixels);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, TextStyle style, {required bool isXAxis}) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: viewportSize.width);

    Offset textOffset;
    if (isXAxis) {
      // Center text below the mark for X-axis
      textOffset = Offset(
        position.dx - textPainter.width / 2,
        position.dy + 2, // Small padding below mark
      );
    } else {
      // Position text to the right of the mark for Y-axis
      textOffset = Offset(
        position.dx + 2, // Small padding to the right
        position.dy - textPainter.height / 2,
      );
    }

    // Basic boundary checks (optional, but good for robustness)
    if (textOffset.dx < 0 || textOffset.dx + textPainter.width > viewportSize.width ||
        textOffset.dy < 0 || textOffset.dy + textPainter.height > viewportSize.height) {
      // Optionally skip drawing if it's mostly off-screen to avoid clutter,
      // or implement more sophisticated clipping/position adjustment.
      // For now, we'll draw it; consider if you want to clip.
    }

    textPainter.paint(canvas, textOffset);
  }

  void paintText(Canvas canvas, String text, Offset desiredPosition, Paint mainPaint, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: mainPaint.color, // Use color from the main axis paint
          fontSize: fontSize,     // Use passed fontSize
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: viewportSize.width);

    double actualX = desiredPosition.dx;
    if (text == 'Y' && actualX + textPainter.width > viewportSize.width) { // Special handling for Y if needed
      actualX = viewportSize.width - textPainter.width - 4;
    } else if (text == 'X') { // Adjust X to be near end of axis
      actualX = viewportSize.width - textPainter.width - 8;
    }

    double actualY = desiredPosition.dy;
    if (text == 'Y') {
      actualY = 8; // Near the top for Y
    } else if (text == 'X' && actualY + textPainter.height > viewportSize.height) { // For X, ensure it's above bottom
      actualY = viewportSize.height - textPainter.height - 4;
    }

    final Offset finalPosition = Offset(actualX, actualY);
    textPainter.paint(canvas, finalPosition);
  }

  @override
  bool shouldRepaint(covariant CrossAxesPainter oldDelegate) {
    // Repaint if the transform changes (pan/zoom) or viewport size changes
    return oldDelegate.canvasTransform != canvasTransform ||
        oldDelegate.viewportSize != viewportSize;
  }
}