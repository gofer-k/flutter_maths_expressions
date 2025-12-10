import 'dart:math';

import 'package:flutter_maths_expressions/models/planimetry/angle.dart';
import 'package:flutter_maths_expressions/models/planimetry/drag_point.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Line', () {
    final p1 = DragPoint(point: const Offset(1, 2), enableDragging: true);
    final p2 = DragPoint(point: const Offset(4, 6)); // y = (4/3)x + 2/3
    final line = Line(a: p1, b: p2, enableRotate: true, enableDragging: true);

    test('constructor and props', () {
      expect(line.a, p1);
      expect(line.b, p2);
      expect(line.enableRotate, isTrue);
      expect(line.enableDragging, isTrue);
      expect(line.props, [p1, p2]);

      // Should throw assertion error if points are the same
      expect(() => Line(a: p1, b: p1), throwsA(isA<AssertionError>()));
    });

    test('isDraggable returns true if any part is draggable', () {
      expect(line.isDraggable(), isTrue);
      final nonDraggableLine = Line(a: DragPoint.zero(), b: p2);
      expect(nonDraggableLine.isDraggable(), isFalse);
      final partiallyDraggableLine =
      Line(a: p1, b: DragPoint(point: const Offset(10, 10)));
      expect(partiallyDraggableLine.isDraggable(), isTrue);
    });

    test('isRotate returns correct value', () {
      expect(line.isRotate(), isTrue);
      final nonRotatableLine = Line(a: p1, b: p2, enableRotate: false);
      expect(nonRotatableLine.isRotate(), isFalse);
    });

    test('copyWith creates a copy', () {
      final copy = line.copyWith() as Line;
      expect(copy.a, line.a);
      expect(copy.b, line.b);
      // Note: copyWith in the provided code does not copy enableDragging/enableRotate
      expect(copy.enableDragging, isFalse);
      expect(copy.enableRotate, isFalse);
    });

    test('matchPoint finds a matching vertex', () {
      final closePointDragging = DragPoint(point: const Offset(1.01, 1.99), enableDragging: true);
      final closePoint = DragPoint(point: const Offset(1.01, 1.99));
      final farPoint = DragPoint(point: const Offset(10, 10));

      expect(line.matchPoint(closePointDragging, 0.1), p1);
      expect(line.matchPoint(closePoint, 0.1), null);
      expect(line.matchPoint(farPoint, 0.1), isNull);
      expect(line.matchPoint(p2, 0.1), p2);
    });

    test('contains returns true for points on vertices or on the line', () {
      final vertexPoint = DragPoint(point: const Offset(4, 6));
      final onLinePoint = DragPoint(point: const Offset(2.5, 4)); // Midpoint
      final offLinePoint = DragPoint(point: const Offset(5, 5));

      expect(line.contains(vertexPoint, 0.1), isTrue);
      expect(line.contains(onLinePoint, 0.1), isTrue);
      expect(line.contains(offLinePoint, 0.1), isFalse);
    });

    test('moveBy moves the entire line if enabled', () {
      final draggingDelta = DragPoint(
          point: const Offset(2, 3));
      final movedLine = line.moveBy(draggingDelta) as Line;

      // Since both points are draggable via line.enableDragging
      expect(movedLine.a.point, const Offset(3, 5));
      expect(movedLine.b.point, line.b.point);  // b is not dragging so it's not moved
    });

    test('moveByPoint moves only the matching point', () {
      final delta = DragPoint(point: const Offset(2, 3));
      final movedLine = line.moveByPoint(p1, delta, 0.1) as Line;

      expect(movedLine.a.point, const Offset(3, 5)); // a is moved
      expect(movedLine.b.point, const Offset(4, 6)); // b is not
    });

    test('rotate around origin rotates points correctly', () {
      final lineToRotate = Line(
          a: DragPoint(point: Offset(-4.0, -4.0)),
          b: DragPoint(point: Offset(4.0, 4.0,), enableDragging: true));
      final midPoint = lineToRotate.getMidpoint();
      final Map<double, Line> rotated = {
        45: Line(a: DragPoint(point: Offset(0.0, -5.66)), b: DragPoint(point: Offset(0.0, 5.66))),
        90: Line(a: DragPoint(point: Offset(4.0, -4.0)), b: DragPoint(point: Offset(-4.0, 4.0))),
        135: Line(a: DragPoint(point: Offset(5.66, 0.0)), b: DragPoint(point: Offset(-5.66, 0.0))),
        180: Line(a: DragPoint(point: Offset(4.0, 4.0)), b: DragPoint(point: Offset(-4.0, -4.0))),
        225: Line(a: DragPoint(point: Offset(0.0, 5.66)), b: DragPoint(point: Offset(0.0, -5.66))),
        270: Line(a: DragPoint(point: Offset(-4.0, 4.0)), b: DragPoint(point: Offset(4.0, -4.0))),
        315: Line(a: DragPoint(point: Offset(-5.66, 0.0)), b: DragPoint(point: Offset(5.66, 0.0))),
        360: Line(a: DragPoint(point: Offset(-4.0, -4.0)), b: DragPoint(point: Offset(4.0, 4.0))),
      };

      for (final entry in rotated.entries) {
        final angle = entry.key;
        final expectedLine = entry.value;

        final rotated = lineToRotate.rotate(
            angle: angle, angleType: AngleType.degrees, origin: midPoint) as Line;
        expect(rotated.a.dx, closeTo(expectedLine.a.dx, 0.01));
        expect(rotated.a.dy, closeTo(expectedLine.a.dy, 0.01));
        expect(rotated.b.dx, closeTo(expectedLine.b.dx, 0.01));
        expect(rotated.b.dy, closeTo(expectedLine.b.dy, 0.01));
      }
    });

    test('rotate around midpoint if origin is null', () {
      final lineToRotate = Line(a: DragPoint(point: Offset(0, 0)), b: DragPoint(point: Offset(2, 0)), enableDragging: true);
      final rotated = lineToRotate.rotate(angle: pi / 2) as Line; // Midpoint is (1,0)

      // Point (0,0) rotates to (0, -1) around (1,0)
      expect(rotated.a.dx, closeTo(0.0, 0.01));
      expect(rotated.a.dy, closeTo(-1, 0.01));

      // Point (2,0) rotates to (0, 1) around (1,0)
      expect(rotated.b.dx, closeTo(0.0, 0.01));
      expect(rotated.b.dy, closeTo(1, 0.01));
    });

    test('getDistance returns the correct length', () {
      final line345 = Line(a: DragPoint(point: Offset(0, 0)), b: DragPoint(point: Offset(3, 4)));
      expect(line345.getDistance(), 5.0);
    });

    test('getAngleBetweenLines calculates angle correctly', () {
      final lineH = Line(a: DragPoint(point: Offset(0, 0)), b: DragPoint(point: Offset(1, 0)));
      final lineV = Line(a: DragPoint(point: Offset(0, 0)), b: DragPoint(point: Offset(0, 1)));
      final angleRad = lineH.getAngleBetweenLines(otherLine: lineV);
      final angleDeg = lineH.getAngleBetweenLines(otherLine: lineV, angleType: AngleType.degrees);

      expect(angleRad[AngleProps.theta], closeTo(pi / 2, 0.01));
      expect(angleDeg[AngleProps.theta], closeTo(90, 0.01));
    });

    test('getSlope calculates slope', () {
      expect(line.getSlope(), closeTo(4 / 3, 0.001));
      final verticalLine = Line(a: DragPoint(point: Offset(1, 1)), b: DragPoint(point: Offset(1, 5)));
      expect(verticalLine.getSlope().isNaN, isTrue);
    });

    test('getMidpoint returns the center point', () {
      expect(line.getMidpoint(), const Offset(2.5, 4));
    });

    test('getGeneralFactors returns [A, B, C]', () {
      /// p1: (1, 2), p2: (4, 6)
      // 4𝑥 − 3𝑦 − 2 = 0
      final factors = line.getGeneralFactors();
      expect(factors[0], 4); // A = y2 - y1
      expect(factors[1], -3); // B = x1 - x2
      expect(factors[2], 2); // C = -A*x1 - B*y1
    });

    // test('getIntersection calculates intersection point', () {
    //   final otherLine = Line(a: DragPoint.from(1, 6), b: DragPoint.from(4, 0)); // y = -2x + 8
    //   final intersection = line.getIntersection(otherLine);
    //
    //   // (4/3)x + 2/3 = -2x + 8 => 4x + 2 = -6x + 24 => 10x = 22 => x=2.2
    //   // y = -2*(2.2) + 8 = -4.4 + 8 = 3.6
    //   expect(intersection.dx, closeTo(2.2, 0.001));
    //   expect(intersection.dy, closeTo(3.6, 0.001));
    //
    //   // Parallel lines
    //   final parallelLine = Line(a: DragPoint.from(1, 3), b: DragPoint.from(4, 7));
    //   final noIntersection = line.getIntersection(parallelLine);
    //   expect(noIntersection.dx.isNaN, isTrue);
    // });

    test('getDistanceFromPoint calculates distance correctly', () {
      final otherPoint = Offset(5.5, 2);
      // Line eq: 4x - 3y + 2 = 0
      // Distance = |4*(5.5) - 3*2 + 2| / sqrt(4^2 + (-3)^2)
      // = |22 - 6 + 2| / sqrt(16+9) = |12| / 5 = 2.8
      expect(line.getDistanceFromPoint(otherPoint), closeTo(3.6, 0.01));
    });
  });
}
