import 'package:flutter/cupertino.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';
import 'package:flutter_maths_expressions/painters/figure_painter.dart';

import '../models/planimetry/angle.dart';
import '../models/planimetry/drag_point.dart';

class DrawableShape<T extends FigurePainter> {
  late final BaseShape shape;
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

  bool contains(DragPoint localPoint, double tolerance) {
    return shape.contains(localPoint, tolerance);
  }

  DrawableShape<T> moveBy(DragPoint delta) {
    return DrawableShape<T>(shape: shape.moveBy(delta),
      labelsSpans: this.labelsSpans,
      createPainter: this.createPainter);
  }

  DrawableShape<T> moveByPoint({required DragPoint point, required DragPoint delta, required double tolerance}) {
    final newShape = shape.moveByPoint(point, delta, tolerance);
    return DrawableShape<T>(
      shape: newShape,
      labelsSpans: this.labelsSpans,
      createPainter: this.createPainter
    );
  }

  DragPoint? matchPoint(DragPoint localPoint, double d) {
    return shape.matchPoint(localPoint, d);
  }

  DrawableShape<T> rotate({required double rotationAngle, Offset? originPoint, required AngleType angleType}) {
    final newShape = shape.rotate(angle: rotationAngle, origin: originPoint, angleType: angleType);
    return DrawableShape<T>(shape: newShape,
      labelsSpans: this.labelsSpans,
      createPainter: this.createPainter);
  }
}


