import 'dart:ui';

import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';

class DragPoint extends BaseShape {
  final Offset point;
  const DragPoint({super.enableDragging, required this.point});

  double get dx => point.dx;
  double get dy => point.dy;

  double get distance => point.distance;

  double get distanceSquared => point.distanceSquared;

  bool get isFinite => point.isFinite;
  bool get isInfinite => point.isInfinite;

  static DragPoint zero({drag = false}) => DragPoint(point: Offset(0.0, 0.0), enableDragging: drag);
  static DragPoint infinite({drag = false}) => DragPoint(point: Offset(0.0, 0.0), enableDragging: drag);
  static DragPoint fromOffset(Offset offset, {drag = false}) => DragPoint(point: offset, enableDragging: drag);

  @override
  DragPoint copyWith() {
    return DragPoint(point: point, enableDragging: enableDragging);
  }

  @override
  bool contains(DragPoint localPoint, double tolerance) {
    return BaseShape.snapPoint(this, localPoint, tolerance)
       != null && enableDragging == localPoint.enableDragging
       ? true : false;
  }

  @override
  DragPoint? matchPoint(DragPoint localPoint, double tolerance) {
    return contains(localPoint, tolerance) ? this : null;
  }

  // Moves the shape by a delta in local coordinates.
  @override
  BaseShape moveBy(DragPoint delta) {
    return DragPoint(enableDragging: enableDragging, point: point + delta.point);
  }

  @override
  bool operator ==(Object other) {
    return other is DragPoint && point == other.point && enableDragging == other.enableDragging;
  }

  DragPoint operator +(DragPoint other) {
    return DragPoint(point: point + other.point, enableDragging: enableDragging);
  }

  DragPoint operator -(DragPoint other) {
    return DragPoint(point: point - other.point, enableDragging: enableDragging);
  }

  DragPoint operator *(double factor) {
    return DragPoint(point: point * factor, enableDragging: enableDragging);
  }

  DragPoint operator /(double factor) {
    if ((factor != 0.0)) {
      return DragPoint(point: point / factor, enableDragging: enableDragging);
    }
    return DragPoint(point: Offset.infinite);
  }

  @override
  List<Object?> get props => [point];

  @override
  int get hashCode => Object.hash(point, enableDragging);
}
