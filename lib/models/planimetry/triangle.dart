import 'dart:math';
import 'dart:ui';

import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';

enum AngleType {
  radian,
  degrees,
}

class Triangle extends BaseShape {
  Offset a;
  Offset b;
  Offset c;

  Triangle({required this.a, required this.b, required this.c}) {
    validate(a, b, c);
  }

  void update(Offset a, Offset b, Offset c) {
    validate(a, b, c);
    this.a = a;
    this.b = b;
    this.c = c;
  }

  void validate(Offset a, Offset b, Offset c) {
    assert(a != b && a != c && b != c);

    final ab = (a - b).distance;
    final ac = (a - c).distance;
    final bc = (b - c).distance;
    assert(ab + bc > ac);
    assert(ac + bc > ab);
    assert(ab + ac > bc);
  }

  @override
  double getArea() {
    final ab = b - a;
    final ac = c - a;
    return (ab.dx * ac.dy - ab.dy * ac.dx).abs() / 2.0;
  }

  @override
  double getPerimeter() {
    final ab = b - a;
    final bc = c - b;
    final ca = a - c;
    return ab.distance + bc.distance + ca.distance;
  }

  @override
  Offset getCenter() {
    return (a + b + c) / 3.0;
  }

  double _angleBetween(double aDist, double bDist, double cDist, {AngleType angleType = AngleType.radian}) {
    // Returns angle opposite side 'a' in degrees
    // Law of Cosines: a^2 = b^2 + c^2 - 2bc * cos(A)
    final result = acos((bDist * bDist + cDist * cDist - aDist * aDist) / (2.0 * bDist * cDist));
    return angleType == AngleType.radian ? result : result * 180.0 / pi;
  }

  double getAngleA({AngleType angleType = AngleType.radian}) {
    // Calculate side lengths
    final aDist = (b - c).distance;
    final bDist = (a - c).distance;
    final cDist = (a - b).distance;
    return _angleBetween(aDist, bDist, cDist, angleType: angleType);
  }

  double getAngleB({AngleType angleType = AngleType.radian}) {
    final aDist = (b - c).distance;
    final bDist = (a - c).distance;
    final cDist = (a - b).distance;
    return _angleBetween(bDist, cDist, aDist, angleType: angleType);
  }

  double getAngleC({AngleType angleType = AngleType.radian}) {
    final aDist = (b - c).distance;
    final bDist = (a - c).distance;
    final cDist = (a - b).distance;
    return _angleBetween(cDist, aDist, bDist, angleType: angleType);
  }

  static double edgeDirection(Offset beginVertex, Offset endVertex, {AngleType angleType = AngleType.radian}) {
    final result = (endVertex - beginVertex).direction;
    return angleType == AngleType.radian ? result : result * 180.0 / pi;
  }

  static double getLength(Offset begin, Offset end) {
    return (end - begin).distance;
  }

  double getHeight() {
    final ab = b - a;
    final ac = c - a;
    final dotProduct = ab.dx * ac.dx + ab.dy * ac.dy;
    final magnitudeAB = ab.distance;
    final magnitudeAC = ac.distance;
    final cosTheta = (dotProduct / (magnitudeAB * magnitudeAC)).clamp(
        -1.0, 1.0);
    return magnitudeAB * cos(acos(cosTheta));
  }

  Offset getHeightPoint() {
    final ab = b - a;
    final ac = c - a;
    final dotProduct = ab.dx * ac.dx + ab.dy * ac.dy;
    final magnitudeAB = ab.distance;
    final magnitudeAC = ac.distance;
    final cosTheta = (dotProduct / (magnitudeAB * magnitudeAC)).clamp(
        -1.0, 1.0);
    return a + ab * (magnitudeAB * cos(acos(cosTheta))) / magnitudeAB;
  }

  Offset getMedianPoint(Offset begin, Offset end) {
    return Offset((begin.dx + end.dx) / 2.0, (begin.dy + end.dy) / 2.0);
  }

  Offset getCentroidPoint() {
    return (a + b + c) / 3.0;
  }

  Offset getBisectorPoint(Offset origin, Offset left, Offset right) {
    final leftBranchLength = (left - origin).distance;
    final rightBranchlength = (right - origin).distance;
    final ratio = leftBranchLength / (leftBranchLength + rightBranchlength);
    return left + (right - left) * ratio;
  }

  List<Offset> getMidsegment(Offset origin, Offset begin, Offset end) {
    return [
      getMedianPoint(begin, origin),
      getMedianPoint(end, origin),
    ];
  }

  Offset getCircumcenter() {
    final midAB = getMedianPoint(a, b);
    final midBC = getMedianPoint(b, c);

    final perpSlopeAB = _perpendicularSlope(a, b);
    final perpSlopeBC = _perpendicularSlope(b, c);

    // y-intercept of the perpendicular bisector of AB
    final cAB = midAB.dy - perpSlopeAB * midAB.dx;
    // y-intercept of the perpendicular bisector of BC
    final cBC = midBC.dy - perpSlopeBC * midBC.dx;
    // Handle vertical or horizontal lines to avoid division by zero or infinite slopes
    if (a.dx == b.dx) { // Side AB is vertical
      final x = midAB.dx;
      final y = perpSlopeBC * x + cBC;
      return Offset(x, y);
    }
    if (b.dx == c.dx) { // Side BC is vertical
      final x = midBC.dx;
      final y = perpSlopeAB * x + cAB;
      return Offset(x, y);
    }

    // x-coordinate of the circumcenter
    final circumcenterX = (cBC - cAB) / (perpSlopeAB - perpSlopeBC);
    // y-coordinate of the circumcenter
    final circumcenterY = perpSlopeAB * circumcenterX + cAB;

    return Offset(circumcenterX, circumcenterY);
  }

  void scale(double value) {
    a *= value;
    b *= value;
    c *= value;
  }

  void translate(double dx, double dy) {
    a = a.translate(dx, dy);
    b = b.translate(dx, dy);
    c = c.translate(dx, dy);
  }

  void rotate(double angle, {AngleType angleType = AngleType.radian}) {
    final center = getCenter();
    a = _rotatePoint(a, center, angle, angleType: angleType);
    b = _rotatePoint(b, center, angle, angleType: angleType);
    c = _rotatePoint(c, center, angle, angleType: angleType);
  }

  Offset _rotatePoint(Offset origin, Offset center, double angle, {AngleType angleType = AngleType.radian}) {
    final targetAngle = angleType == AngleType.radian ? angle : angle * 180.0 / pi;
    final origToCenter = origin - center;
    return Offset(
      origToCenter.dx * cos(targetAngle) - origToCenter.dy * sin(targetAngle),
      origToCenter.dx * sin(targetAngle) + origToCenter.dy * cos(targetAngle));
  }

  double _slopeLine(Offset begin, Offset end) {
    if (end.dx != begin.dx) {
      return (end.dy - begin.dy) / (end.dx - begin.dx);
    }
    return 0.0;
  }

  double _perpendicularSlope(Offset begin, Offset end) {
    final slope = _slopeLine(begin, end);
    if (slope != 0.0) {
      return -1.0 / slope;
    }
    return 0.0;
  }
}