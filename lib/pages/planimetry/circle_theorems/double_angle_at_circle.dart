import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/painters/circle_painter.dart';

import '../../../models/dock_side.dart';
import '../../../models/planimetry/angle.dart';
import '../../../models/planimetry/circle.dart';
import '../../../models/planimetry/drag_point.dart';
import '../../../models/planimetry/line.dart';
import '../../../painters/angle_painter.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/line_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';
import '../angle_theorems/alternate_angles.dart';

class DoubleAngleAtCircleTheorem extends StatefulWidget {
  final String title;

  const DoubleAngleAtCircleTheorem({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _DoubleAngleAtCircleTheoremState();
}

class _DoubleAngleAtCircleTheoremState
    extends State<DoubleAngleAtCircleTheorem> {
  DockSide dock = DockSide.leftTop;
  final circle = Circle(center: Offset.zero, radius: 3.0);
  late Line mutualChord = circle.buildChord(height: 1.5, draggable: true);
  late double angleValue = 0.0;
  late double doubleAngleValue = 0.0;

  final axesLine = Line(
    a: DragPoint(point: Offset(0.0, 6.0)),
    b: DragPoint(point: Offset(0.0, -6.0)),
  );
  late double originBaseY = mutualChord.a.dy;
  late double originXmin = mutualChord.a.dx;
  late double originXmax = mutualChord.b.dx;
  late double originHigherY = circle.center.dy + circle.radius;
  late double originLowerY = circle.center.dy;

  late Angle originalDoubleAngle = Angle(
    leadingLine: Line(
      a: DragPoint(point: Offset(0.0, originHigherY)),
      b: DragPoint(point: Offset(originXmin, originBaseY))),
    followingLine: Line(
      a: DragPoint(point: Offset(0.0, originHigherY)),
      b: DragPoint(point: Offset(originXmax, originBaseY)))
  );
  late Angle originalAngle = Angle(
    leadingLine: Line(
      a: DragPoint(point: Offset(0.0, originLowerY)),
      b: DragPoint(point: Offset(originXmin, originBaseY))),
    followingLine: Line(
      a: DragPoint(point: Offset(0.0, originLowerY)),
      b: DragPoint(point: Offset(originXmax, originBaseY)),
    ),
  );
  late List<Angle> mutableAngles = List.empty(growable: true);
  final List<DrawableShape> _drawablesShapes = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mutableAngles.add(originalAngle.copyWith() as Angle);
    mutableAngles.add(originalDoubleAngle.copyWith() as Angle);
    angleValue = mutableAngles.first.getAngle(angleType: AngleType.degrees);
    doubleAngleValue = mutableAngles.last.getAngle(angleType: AngleType.degrees);
    changeDrawableShapes();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      beginColor: Colors.grey.shade50,
      endColor: Colors.grey.shade500,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: Column(
            children: [
              Expanded(flex: 2, child: drawableView(dock)),
              const SizedBox(height: 4),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    DisplayExpression(
                      context: context,
                      expression:
                      r"\alpha = \beta",
                      scale: 2.0,
                    ),
                    DisplayExpression(
                      context: context,
                      expression:
                          r"\alpha = "
                          "${angleValue.toStringAsFixed(2)}"
                          r"^\circ",
                      scale: 1.8,
                    ),
                    DisplayExpression(
                      context: context,
                      expression:
                          r"\beta = "
                          "${doubleAngleValue.toStringAsFixed(2)}"
                          r"^\circ",
                      scale: 1.8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeDrawableShapes() {
    _drawablesShapes.clear();
    _drawablesShapes.add(
      changeDrawableLine(line: axesLine, legend: true, lineColor: Colors.grey.shade700, widthLine: 3.0, lineType: ShowLineProperty.dashed),
    );
    _drawablesShapes.add(DrawableShape<CirclePainter>(
      shape: circle,
      labelsSpans: [],
      createPainter: (
        Matrix4 canvasTransform,
        Size viewportSize,
        double widthUnitInPixels,
        double heightUnitInPixels,
        circle
      ){
        return CirclePainter(
          widthUnitInPixels,
          heightUnitInPixels,
          [circle],
          canvasTransform: canvasTransform,
          viewportSize: viewportSize,
        );
      }
    ));
    _drawablesShapes.add(
      changeDrawableLine(line: mutualChord, legend: false, lineColor: Colors.deepPurple, widthLine: 2.5, lineType: ShowLineProperty.dashed),
    );
    _drawablesShapes.add(
      changeDrawableAngle(
        angle: mutableAngles.first, // double-size angle
        color: Colors.green,
        widthLine: 2.5,
        lineColor: Colors.grey.shade600,
        arcRadius: 45.0,
      ),
    );
    _drawablesShapes.add(
      changeDrawableAngle(
        angle: mutableAngles.last,  // angle
        color: Colors.red,
        widthLine: 2.5,
        lineColor: Colors.grey.shade600,
        arcRadius: 55.0,
      ),
    );
  }

  DrawableLine changeDrawableLine({
    required Line line,
    bool legend = true,
    Color lineColor = Colors.grey,
    double widthLine = 3.0,
    ShowLineProperty lineType = ShowLineProperty.solid,
  }) {
    return DrawableLine(
      shape: line,
      labelsSpans: [
        if (legend)
          TextSpan(
            text: "α, ",
            style: TextStyle(color: Colors.green, fontSize: 28),
          ),
        if (legend)
          TextSpan(
            text: "β, ",
            style: TextStyle(color: Colors.red, fontSize: 28),
          ),
      ],
      createPainter:
          (
            Matrix4 canvasTransform,
            Size viewportSize,
            double widthUnitInPixels,
            double heightUnitInPixels,
            line,
          ) {
            return LinePainter(
              widthUnitInPixels,
              heightUnitInPixels,
              [line],
              [lineType],
              canvasTransform: canvasTransform,
              viewportSize: viewportSize,
              widthLine: widthLine,
              color: lineColor,
            );
          },
    );
  }

  DrawableAngle changeDrawableAngle({
    required Angle angle,
    required Color color,
    double widthLine = 2.0,
    Color lineColor = Colors.black,
    double arcRadius = 25.0,
  }) {
    return DrawableShape<AnglePainter>(
      shape: angle,
      labelsSpans: [],
      createPainter:
          (
            Matrix4 canvasTransform,
            Size viewportSize,
            double widthUnitInPixels,
            double heightUnitInPixels,
            angle,
          ) {
            return AnglePainter(
              widthUnitInPixels,
              heightUnitInPixels,
              [angle],
              [ShowProperty.interception, ShowProperty.line],
              canvasTransform: canvasTransform,
              viewportSize: viewportSize,
              angleColor: color,
              widthLine: widthLine,
              lineColor: lineColor,
              arcRadius: arcRadius,
            );
          },
    );
  }

  bool changeProperties(Line newChord) {
    mutualChord = newChord;

    mutableAngles.clear();
    mutableAngles.add(Angle(
        leadingLine: Line(
            a: DragPoint(point: Offset(0.0, originHigherY)),
            b: DragPoint(point: Offset(mutualChord.a.dx, mutualChord.a.dy))),
        followingLine: Line(
            a: DragPoint(point: Offset(0.0, originHigherY)),
            b: DragPoint(point: Offset(mutualChord.b.dx, mutualChord.b.dy)))
    ));
    mutableAngles.add(Angle(
      leadingLine: Line(
          a: DragPoint(point: Offset(0.0, originLowerY)),
          b: DragPoint(point: Offset(mutualChord.a.dx, mutualChord.a.dy))),
      followingLine: Line(
        a: DragPoint(point: Offset(0.0, originLowerY)),
        b: DragPoint(point: Offset(mutualChord.b.dx, mutualChord.b.dy)),
      ),
    ));
    angleValue = mutableAngles.first.getAngle(angleType: AngleType.degrees);
    doubleAngleValue = mutableAngles.last.getAngle(angleType: AngleType.degrees);
    return true;
  }

  Widget drawableView(DockSide dock) {
    return InfiniteDrawer(
      actionsDockSide: dock,
      enableCrossAxes: true,
      enablePinchAngle: false,
      enablePanning: true,
      drawableShapes: _drawablesShapes,
      onDragShape: (oldShapes, originPoint, targetPoint) {
        setState(() {
          // Drag target point is stick to teh axes line
          if ((targetPoint.dx - originPoint.dx).abs() > 0.2
              || (targetPoint.dy > circle.center.dy)
              || (targetPoint.dy < circle.center.dy - circle.radius)
          ) {
            return;
          }

          for (final oldShape in oldShapes) {
            final index = _drawablesShapes.indexOf(
                oldShape as DrawableShape<LinePainter>);
            if (index != -1) {
              final double newDy = (circle.center.dy - circle.radius - targetPoint.dy).abs();
              final newChord = circle.buildChord(height: newDy, draggable: true);
              if (changeProperties(newChord)) {
                changeDrawableShapes();
              }
            }
          }
        });
      }
    );
  }
}
