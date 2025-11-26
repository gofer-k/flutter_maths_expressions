import 'dart:ui';

abstract class BaseShape {
  double getArea();
  double getPerimeter();
  Offset getCenter();
  // Checks if a local point in specific near the shape.
  bool contains(Offset localPoint, double tolerance) {
    return false;
  }

  Offset? snapToPoint(Offset localPoint, double tolerance) {
    return null;
  }

  // Moves the shape by a delta in local coordinates.
  void moveBy(Offset delta) {}

  bool movePointBy(Offset localPoint, Offset delta, double tolerance) {
    return false;
  }

  void moveLineBy(Offset delta) {}

  static Offset? snapPoint(Offset originPoint, Offset localPoint, double tolerance) {
    if ((originPoint - localPoint).distance < tolerance) {
      return originPoint;
    }
    return null;
  }
}