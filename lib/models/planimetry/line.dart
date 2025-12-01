import 'dart:math';
import 'dart:ui';

import 'package:flutter_maths_expressions/models/planimetry/angle.dart';
import 'package:flutter_maths_expressions/models/planimetry/drag_point.dart';
import 'base_shape.dart';

class Line extends BaseShape {
  final DragPoint a;
  final DragPoint b;

  const Line({super.enableDragging, required this.a, required this.b})
      : assert(a != b);

  @override
  List<Object?> get props => [a, b];

  @override
  bool isDraggable() {
    return enableDragging || a.isDraggable() || b.isDraggable();
  }

  @override
  BaseShape copyWith() {
    return Line(a: a, b: b,);
  }

  @override
  DragPoint? matchPoint(DragPoint localPoint, double tolerance) {
    if (a.matchPoint(localPoint, tolerance) != null) {
      return a;
    }
    if (b.matchPoint(localPoint, tolerance) != null) {
      return b;
    }
    return null;
  }

  @override
  bool contains(DragPoint localPoint, double tolerance) {
    if (matchPoint(localPoint, tolerance) != null) {
      return true;
    }
    // TODO: check match to the line
    return false;
  }

  @override
  BaseShape moveBy(DragPoint delta) {
    if (enableDragging || a.enableDragging || b.enableDragging) {
      return Line(a: a.enableDragging ? a + delta : a,
          b: b.enableDragging ? b + delta : b);
    }
    return this;
  }

  @override
  BaseShape moveByPoint(DragPoint localPoint, DragPoint delta,
      double tolerance) {
    if (enableDragging || a.enableDragging || b.enableDragging) {
      final newA = a.matchPoint(localPoint, tolerance);
      final newB = b.matchPoint(localPoint, tolerance);
      return Line(
          a: newA != null ? newA + delta : a,
          b: newB != null ? newB + delta : b);
    }
    return this;
  }

  Line reserved() {
    return Line(a: b, b: a);
  }

  // An line's angle positive toward x-line (clock wise direction)
  double getAngle({AngleType angleType = AngleType.radian}) {
    //TODO: check out this implementation
    final ab = a - b;
    final dotProduct = ab.dx * ab.dx + ab.dy * ab.dy;
    final magnitudeAB = ab.distance;
    final cosTheta = (dotProduct / magnitudeAB).clamp(-1.0, 1.0);
    final result = acos(cosTheta);
    return angleType == AngleType.radian ? result : result * 180 / pi;
  }

  double getDistance() {
    return (a-b).distance;
  }

  // An angle 2 lines on the same surface positive toward x-line (clock wise direction)
  double getAngleBetweenLines({required Line otherLine, AngleType angleType = AngleType.radian}) {
    final ab = a - b;
    final otherAb = otherLine.a - otherLine.b;
    final dotProduct = ab.dx * otherAb.dx + ab.dy * otherAb.dy;
    final magnitudeAB = ab.distance;
    final magnitudeOtherAb = otherAb.distance;
    final cosTheta = (dotProduct / (magnitudeAB * magnitudeOtherAb)).clamp(-1.0, 1.0);
    final result = acos(cosTheta);
    return angleType == AngleType.radian ? result : result * 180 / pi;
  }

  double getSlope() {
    if (b.dx != a.dx) {
      return (b.dy - a.dy) / (b.dx - a.dx);
    }
    return double.nan;
  }

  Offset getMidpoint() {
    return ((a + b) / 2.0).point;
  }

  List<double> getDirectionalFactors() {
    final slope = getSlope();
    final yIntercept = a.dy - slope * a.dx;
    return List.unmodifiable([slope, yIntercept]);
  }

  /// Returns the factors [A, B, C] for the general form of a line equation
  List<double> getGeneralFactors() {
    final double A = b.dy - a.dy;
    final double B = a.dx - b.dx;
    final double C = -A * a.dx - B * a.dy;

    // The factors are returned in an immutable list for safety.
    return List.unmodifiable([A, B, C]);
  }

  Offset getPerpendicularPoint(Offset point) {
    final factors = getGeneralFactors();
    final double A = factors[0];
    final double B = factors[1];
    final double C = factors[2];

    final ab = (A * A + B * B);
    final double x = ab != 0.0 ? (A * C - B * point.dy) / ab : double.nan;
    final double y = ab != 0.0 ? (B * C - A * point.dx) / (A * A + B * B) : double.nan;
    return Offset(x, y);
  }

  Offset getIntersection(Line otherLine) {
    final factors = getGeneralFactors();
    final double A = factors[0];
    final double B = factors[1];
    final double C = factors[2];
    final otherFactors = otherLine.getGeneralFactors();
    final double otherA = otherFactors[0];
    final double otherB = otherFactors[1];
    final double otherC = otherFactors[2];

    final double denominator = A * otherB - B * otherA;
    if (denominator == 0.0) {
      return Offset(double.nan, double.nan);
    }
    final double x = (B * otherC - C * otherB) / denominator;
    final double y = (C * otherA - A * otherC) / denominator;
    return Offset(x, y);
  }
}