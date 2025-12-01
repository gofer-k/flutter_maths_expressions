import 'dart:math';
import 'dart:ui';

import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import 'angle.dart';
import 'drag_point.dart';

class Polygon extends BaseShape {
  final List<Line> lines;

  const Polygon({super.enableDragging, this.lines = const <Line>[]});

  @override
  List<Object?> get props => [lines];

  static Polygon fromLines(int numLines, Line originLine) {
    final lines = <Line>[];
    double anglePerLine = 2 * pi / numLines;
    final originPoint = originLine.a.point;
    final lineLength = originLine.getDistance();

    final dragPoints = List.generate(numLines, (i) {
      final currentAngle = anglePerLine * i;
      final point = Offset(
        originPoint.dx + lineLength * cos(currentAngle),
        originPoint.dy + lineLength * sin(currentAngle),
      );
      return DragPoint(point: point, enableDragging: true);
    }, growable: false);

    for (int i = 0; i < numLines; i++) {
      final a = dragPoints[i];
      final b = dragPoints[(i + 1) % numLines];
      lines.add(Line(a: a, b: b));
    }
    return Polygon(lines: lines);
  }

  @override
  bool isDraggable() {
    return enableDragging ||
        lines.any((line) => line.isDraggable() == enableDragging);
  }

  @override
  BaseShape copyWith() {
    return Polygon(lines: lines, enableDragging: enableDragging);
  }

  @override
  bool contains(DragPoint localPoint, double tolerance) {
    return lines.any((line) => line.contains(localPoint, tolerance));
  }

  @override
  DragPoint? matchPoint(DragPoint localPoint, double tolerance) {
    final index = lines.indexWhere((line) =>
    line.matchPoint(localPoint, tolerance) != null);
    return index >= 0 ? lines[index].matchPoint(localPoint, tolerance) : null;
  }

  @override
  BaseShape moveByPoint(DragPoint localPoint, DragPoint delta,
      double tolerance) {
    if (isDraggable()) {
      return Polygon(
          lines: lines.map((line) =>
          line.moveByPoint(
              localPoint, delta, tolerance) as Line).toList(),
          enableDragging: enableDragging);
    }
    return this;
  }

  @override
  BaseShape moveBy(DragPoint delta) {
    if (isDraggable()) {
      return Polygon(
          lines: lines.map((line) => line.moveBy(delta) as Line).toList(),
          enableDragging: enableDragging);
    }
    return this;
  }

  double getSumAngles(int numLines, AngleType angleType) {
    final angle = angleType == AngleType.radian ? pi : 180;
    return (numLines - 2.0) * angle;
  }
}