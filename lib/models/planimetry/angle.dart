import 'dart:math';
import 'dart:ui';

import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import 'base_shape.dart';
import 'drag_point.dart';

enum AngleType {
  radian,
  degrees,
}

class Angle extends BaseShape {
  final Line leadingLine;
  final Line followingLine;

  const Angle({super.enableDragging, required this.leadingLine, required this.followingLine});

  static toDegrees(double angle) {
    return angle * 180 / pi;
  }

  static toRadian(double angle) {
    return angle * pi / 180;
  }

  static toRadians(double angle) {
  }

  static double normalize({required double angle, double sentinel = 2 * pi}) {
    return (angle - sentinel) % 180.0;
  }

  static double normalizeRad({required double angle, double sentinel = 360.0}) {
    return (angle - sentinel) % (2 * pi);
  }

  static double clampAngle({required double a, AngleType angleType = AngleType.radian}) {
    // Keep in [0, π] or [0, 180]
    if (angleType == AngleType.radian) {
      if (a < 0) return 0;
      if (a > pi) return pi;
      return a;
    }
    if (a < 0) return 0;
    if (a > 180) return 180;
    return a;
  }

  static angleVertex({required Offset vertex, Offset? originVertex, AngleType angleType = AngleType.radian}) {
    final targetVertex = vertex - (originVertex ?? Offset.zero);
    final angle = atan2(targetVertex.dy, targetVertex.dx);
    return angleType == AngleType.radian ? angle : toDegrees(angle);
  }

  @override
  bool isDraggable() {
    return enableDragging || leadingLine.isDraggable() || followingLine.isDraggable();
  }

  @override
  BaseShape copyWith() {
    return Angle(leadingLine: leadingLine, followingLine: followingLine);
  }

  @override
  bool contains(DragPoint localPoint, double tolerance) {
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
  DragPoint? matchPoint(DragPoint localPoint, double tolerance) {
    if (leadingLine.contains(localPoint, tolerance)) {
      return leadingLine.matchPoint(localPoint, tolerance);
    }
    if (followingLine.contains(localPoint, tolerance)) {
      return followingLine.matchPoint(localPoint, tolerance);
    }
    return null;
  }

  @override
  BaseShape moveByPoint(DragPoint localPoint, DragPoint delta, double tolerance) {
    if (isDraggable()) {
      return Angle(
          leadingLine: leadingLine.moveByPoint(
              localPoint, delta, tolerance) as Line,
          followingLine: followingLine.moveByPoint(
              localPoint, delta, tolerance) as Line);
    }
    return this;
  }

  @override
  BaseShape moveBy(DragPoint delta) {
    if (isDraggable()) {
      return Angle(
          leadingLine: leadingLine.moveBy(delta) as Line,
          followingLine: followingLine.moveBy(delta) as Line);
    }
    return this;
  }

  Offset getOriginPoint() {
    return leadingLine.getIntersection(followingLine);
  }

    // An angle 2 lines on the same surface from leadingLine toward line (counter-clockwise direction)
  double getAngle({AngleType angleType = AngleType.radian}) {
    final origin = getOriginPoint();

    // Calculate the angle of each vector relative to the positive x-axis
    // atan2(y, x) returns the angle in radians from -π to +π.
    final angle1 = Angle.angleVertex(vertex: leadingLine.b.point, originVertex: origin);
    final angle2 = Angle.angleVertex(vertex: followingLine.b.point, originVertex: origin);

    // Calculate the counter-clockwise angle from vec1 to vec2
    double sweepAngle = angle2 - angle1;

    // If the sweep is negative, add 2π to make it positive (ensuring a full circle)
    if (sweepAngle < 0) {
      sweepAngle += 2 * pi;
    }
    return angleType == AngleType.radian ? sweepAngle : Angle.toDegrees(sweepAngle);
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
  List<Object?> get props => [leadingLine, followingLine];
}