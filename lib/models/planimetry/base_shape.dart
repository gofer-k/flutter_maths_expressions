import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseShape extends Equatable {
  const BaseShape();
  BaseShape copyWith() {
    return this;
  }

  double getArea();
  double getPerimeter();
  Offset getCenter();
  // Checks if a local point in specific near the shape.
  bool contains(Offset localPoint, double tolerance) {
    return false;
  }

  Offset? matchPoint(Offset localPoint, double tolerance) {
    return null;
  }

  // Moves the shape by a delta in local coordinates.
  BaseShape moveBy(Offset delta) {
    return this;
  }

  BaseShape movePointBy(Offset localPoint, Offset delta, double tolerance) {
    return this;
  }

  BaseShape moveLineBy(Offset delta) {
    return moveBy(delta);
  }

  static Offset? snapPoint(Offset originPoint, Offset localPoint, double tolerance) {
    if ((originPoint - localPoint).distance < tolerance) {
      return localPoint;
    }
    return null;
  }
}