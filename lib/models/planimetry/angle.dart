import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import 'base_shape.dart';

enum AngleType {
  radian,
  degrees,
}

@immutable
class Angle extends BaseShape {
  final Line leadingLine;
  final Line followingLine;

  const Angle({required this.leadingLine, required this.followingLine});

  /// Creates a new immutable Angle object with the given values updated.

  @override
  BaseShape copyWith() {
    return Angle(leadingLine: leadingLine, followingLine: followingLine);
  }

  @override
  bool contains(Offset localPoint, double tolerance) {
    // Check match local point to the sha[e control points
    if (leadingLine.contains(localPoint, tolerance)) {
      return true;
    }
    if (followingLine.contains(localPoint, tolerance)) {
      return true;
    }
    return false;
  }

  @override
  Offset? matchPoint(Offset localPoint, double tolerance) {
    if (leadingLine.contains(localPoint, tolerance)) {
      return leadingLine.matchPoint(localPoint, tolerance);
    }
    if (followingLine.contains(localPoint, tolerance)) {
      return followingLine.matchPoint(localPoint, tolerance);
    }
    return null;
  }

  @override
  BaseShape movePointBy(Offset localPoint, Offset delta, double tolerance) {
    return Angle(
      leadingLine: leadingLine.movePointBy(localPoint, delta, tolerance) as Line,
      followingLine: followingLine.movePointBy(localPoint, delta, tolerance) as Line);
  }

  @override
  BaseShape moveLineBy(Offset delta) {
    return Angle(
        leadingLine: leadingLine.moveBy(delta) as Line,
        followingLine: followingLine.moveBy(delta) as Line);
  }

  Offset getOriginPoint() {
    return leadingLine.getIntersection(followingLine);
  }

    // An angle 2 lines on the same surface from leadingLine toward line (counter-clockwise direction)
  double getAngle({AngleType angleType = AngleType.radian}) {
    final origin = getOriginPoint();

    // Create vectors from the origin point to another point on each line
    final vec1 = leadingLine.b - origin;
    final vec2 = followingLine.b - origin;

    // Calculate the angle of each vector relative to the positive x-axis
    // atan2(y, x) returns the angle in radians from -π to +π.
    final angle1 = atan2(vec1.dy, vec1.dx);
    final angle2 = atan2(vec2.dy, vec2.dx);

    // Calculate the counter-clockwise angle from vec1 to vec2
    double sweepAngle = angle2 - angle1;

    // If the sweep is negative, add 2π to make it positive (ensuring a full circle)
    if (sweepAngle < 0) {
      sweepAngle += 2 * pi;
    }
    return angleType == AngleType.radian ? sweepAngle : sweepAngle * 180 / pi;
  }

  // An angle 2 lines on the same surface positive toward x-line (clock wise direction)
  List<double> getComplementaryAngles({AngleType angleType = AngleType.radian}) {
    double angle = getAngle(angleType: angleType);
    return List.unmodifiable(
        [angle, angleType == AngleType.radian ? pi/0.5 - angle : 90 - angle]);
  }

  List<double> getSupplementaryAngle({AngleType angleType = AngleType.radian}) {
    double angle = getAngle(angleType: angleType);
    return List.unmodifiable(
        [angle, angleType == AngleType.radian ? pi - angle : 180 - angle]);
  }

  @override
  double getArea() {
    throw UnimplementedError();
  }

  @override
  Offset getCenter() {
    throw UnimplementedError();
  }

  @override
  double getPerimeter() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [leadingLine, followingLine];
}