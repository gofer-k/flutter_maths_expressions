import 'package:flutter/cupertino.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';
import 'package:flutter_maths_expressions/painters/figure_painter.dart';

class DrawableShape<T extends FigurePainter> {
  final BaseShape shape;
  final List<TextSpan> labelsSpans;
  final T Function(Matrix4, Size, double, BaseShape) createPainter;
  late T painter;

  DrawableShape({required this.shape, required this.labelsSpans, required this.createPainter});

  T paint(Matrix4 canvasTransform, Size viewportSize, double originUnitInPixels) {
    painter = createPainter(canvasTransform, viewportSize, originUnitInPixels, shape);
    return painter;
  }
}

