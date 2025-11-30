import 'package:equatable/equatable.dart';
import 'package:flutter_maths_expressions/models/planimetry/drag_point.dart';

abstract class BaseShape extends Equatable {
  final bool enableDragging;

  @override
  List<Object?> get props => [enableDragging];

  const BaseShape({this.enableDragging = false});
  BaseShape copyWith() {
    return this;
  }
  // Checks if a local point in specific near the shape.
  bool contains(DragPoint localPoint, double tolerance) {
    return false;
  }

  bool isDraggable() {
    return enableDragging;
  }

  DragPoint? matchPoint(DragPoint localPoint, double tolerance) {
    return null;
  }

  // Moves the shape by a delta in local coordinates.
  BaseShape moveBy(DragPoint delta) {
    return this;
  }

  BaseShape movePointBy(DragPoint localPoint, DragPoint delta, double tolerance) {
    return this;
  }

  static DragPoint? snapPoint(DragPoint originPoint, DragPoint localPoint, double tolerance) {
    if ((originPoint - localPoint).distance < tolerance) {
      return localPoint;
    }
    return null;
  }
}