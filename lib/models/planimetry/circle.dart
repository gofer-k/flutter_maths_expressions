import 'dart:math';
import 'dart:ui';

import 'package:flutter_maths_expressions/models/planimetry/angle.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import 'base_shape.dart';
import 'drag_point.dart';

class Circle extends BaseShape {
  final Offset center;
  final double radius;
  const Circle({super.enableDragging, super.enableRotate, required this.center, required this.radius});

  @override
  List<Object?> get props => [center, radius];

  @override
  BaseShape copyWith() {
    return Circle(center: center, radius: radius);
  }

  @override
  DragPoint? matchPoint(DragPoint localPoint, double tolerance) {
    final double distance = (localPoint.point - center).distance;
    if ((distance - radius).abs() <= tolerance) {
      return localPoint;
    }
    return null;
  }

  @override
  bool contains(DragPoint localPoint, double tolerance) {
    if (matchPoint(localPoint, tolerance) != null) {
      return true;
    }
    return false;
  }

  double getCircumference() {
    return 2 * pi * radius;
  }

  double getArea() {
    return pi * radius * radius;
  }

  double getChordDistanceByAngle({required double alpha, AngleType angleType = AngleType.radian}) {
    final angle = angleType == AngleType.radian ? alpha : Angle.toRadian(alpha);
    return 2 * radius * sin(angle / 2.0);
  }

  double getChordDistanceByHeight(double height) {
    assert(height.abs() < radius);
    return 2 * sqrt(2 * height * radius - height * height);
  }

  Line buildChord({required double height, bool draggable = false}) {
    assert(height.abs() < radius);
    final distChord = getChordDistanceByHeight(height);
    final xChord = distChord / 2.0;
    final yChord = center.dy - radius + height;
    final chord = Line(
      a: DragPoint(point: Offset(center.dx - xChord, yChord)),
      b: DragPoint(point: Offset(center.dx + xChord, yChord)),
      enableDragging: draggable);
    return chord;
  }
}