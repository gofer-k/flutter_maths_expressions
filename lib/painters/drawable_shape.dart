import 'package:flutter/cupertino.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';
import 'package:flutter_maths_expressions/painters/figure_painter.dart';

class DrawableShape<T extends FigurePainter> {
  final BaseShape shape;
  final List<TextSpan> labelsSpans;
  final T Function(Matrix4, Size, double, double, BaseShape) createPainter;
  late T painter;

  DrawableShape({required this.shape, required this.labelsSpans, required this.createPainter});

  T paint(Matrix4 canvasTransform, Size viewportSize,
      double originWidthUnitInPixels, double originHeightUnitInPixels) {
    painter = createPainter(
        canvasTransform, viewportSize,
        originWidthUnitInPixels,
        originHeightUnitInPixels, shape);
    return painter;
  }

  bool contains(Offset localPoint, double tolerance) {
    return shape.contains(localPoint, tolerance);
  }

  DrawableShape<T> moveBy(Offset delta) {
    return DrawableShape<T>(shape: shape.moveBy(delta),
      labelsSpans: this.labelsSpans,
      createPainter: this.createPainter);
  }

  DrawableShape<T> moveByPoint({required Offset point, required Offset delta, required double tolerance}) {
    final newShape = shape.movePointBy(point, delta, tolerance);
    return DrawableShape<T>(
      shape: newShape,
      labelsSpans: this.labelsSpans,
      createPainter: this.createPainter
    );
  }

  Offset? matchPoint(Offset localPoint, double d) {
    return shape.matchPoint(localPoint, d);
  }
}


