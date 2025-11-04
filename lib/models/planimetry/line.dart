import 'dart:math';
import 'dart:ui';

import 'package:flutter_maths_expressions/models/planimetry/triangle.dart';

import 'base_shape.dart';

class Line extends BaseShape {
  Offset a;
  Offset b;

  Line({required this.a, required this.b}) {
    assert(a != b);
  }

  update(Offset a, Offset b) {
    this.a = a;
    this.b = b;
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

  @override
  double getArea() {
    throw UnimplementedError();
  }

  @override
  double getPerimeter() {
    throw UnimplementedError();
  }

  @override
  Offset getCenter() {
    throw UnimplementedError();
  }
}