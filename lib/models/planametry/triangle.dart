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
}