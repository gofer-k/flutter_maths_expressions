import 'dart:math';
import 'dart:ui';

class Triangle {
  final Offset a;
  final Offset b;
  final Offset c;

  Triangle({required this.a, required this.b, required this.c});

  double getArea() {
    final ab = b - a;
    final ac = c - a;
    return (ab.dx * ac.dy - ab.dy * ac.dx).abs() / 2.0;
  }

  double getPerimeter() {
    final ab = b - a;
    final bc = c - b;
    final ca = a - c;
    return ab.distance + bc.distance + ca.distance;
  }

  double getAngleA() {
    final ab = b - a;
    final ac = c - a;
    final dotProduct = ab.dx * ac.dx + ab.dy * ac.dy;
    final magnitudeAB = ab.distance;
    final magnitudeAC = ac.distance;

    // The value to pass to acos can sometimes be slightly out of the [-1, 1]
    // range due to floating point inaccuracies. Clamping it prevents errors.
    final cosTheta = (dotProduct / (magnitudeAB * magnitudeAC)).clamp(-1.0, 1.0);

    return acos(cosTheta);
  }

  double getAngleB() {
    final ab = a - b;
    final cb = c - b;
    final dotProduct = ab.dx * cb.dx + ab.dy * cb.dy;
    final magnitudeAB = ab.distance;
    final magnitudeCB = cb.distance;

    // The value to pass to acos can sometimes be slightly out of the [-1, 1]
    // range due to floating point inaccuracies. Clamping it prevents errors.
    final cosTheta = (dotProduct / (magnitudeAB * magnitudeCB)).clamp(-1.0, 1.0);

    return acos(cosTheta);
  }

  double getAngleC() {
    final ab = a - c;
    final bc = b - c;
    final dotProduct = ab.dx * bc.dx + ab.dy * bc.dy;
    final magnitudeAB = ab.distance;
    final magnitudeBC = bc.distance;

    // The value to pass to acos can sometimes be slightly out of the [-1, 1]
    // range due to floating point inaccuracies. Clamping it prevents errors.
    final cosTheta = (dotProduct / (magnitudeAB * magnitudeBC)).clamp(-1.0, 1.0);

    return acos(cosTheta);
  }
}
