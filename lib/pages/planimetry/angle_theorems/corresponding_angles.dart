import 'package:flutter/material.dart';

import '../../../models/dock_side.dart';
import '../../../models/planimetry/angle.dart';
import '../../../models/planimetry/drag_point.dart';
import '../../../models/planimetry/line.dart';
import '../../../painters/angle_painter.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/line_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';

enum CorrespondingAngleName { alpha, beta }

class CorrespondingAngle {
  final double angleVal;
  final List<Angle> correspondingAngles;

  CorrespondingAngle({required this.angleVal, required this.correspondingAngles});
}

class CorrespondingAngleTheorem extends StatefulWidget {
  final String title;

  const CorrespondingAngleTheorem({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _CorrespondingAngleTheoremState();
}

typedef DrawableLine = DrawableShape<LinePainter>;
typedef DrawableAngle = DrawableShape<AnglePainter>;

class _CorrespondingAngleTheoremState extends State<CorrespondingAngleTheorem> {
  DockSide dock = DockSide.leftTop;
  final List<Line> parallelLines = [
    Line(
      a: DragPoint(point: Offset(-5.0, -1.0)),
      b: DragPoint(point: Offset(5.0, -1.0)),
    ),
    Line(
      a: DragPoint(point: Offset(-5.0, 2.0)),
      b: DragPoint(point: Offset(5.0, 2.0)),
    ),
  ];

  final originLine = Line(
    a: DragPoint(point: Offset(-2.0, -4.0)),
    b: DragPoint(point: Offset(2.0, 4.0)),
    enableDragging: true,
  );
  late Line mutableLine;
  final List<DrawableShape> _drawablesShapes = List.empty(growable: true);

  late Map<CorrespondingAngleName, CorrespondingAngle> correspondingAngles = Map.identity();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    changeProperties(originLine);
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
                      r"\alpha = "
                      "${correspondingAngles[CorrespondingAngleName.alpha]?.angleVal.toStringAsFixed(1)}"
                      r"^\circ",
                      scale: 1.5,
                    ),
                    DisplayExpression(
                      context: context,
                      expression:
                      r"\alpha = "
                      "${correspondingAngles[CorrespondingAngleName.beta]?.angleVal.toStringAsFixed(1)}"
                      r"^\circ",
                      scale: 1.5,
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

  void changeProperties(Line newLine) {
    mutableLine = newLine.copyWith() as Line;
    changeAlternateAngles(mutableLine);
  }

  void changeAlternateAngles(Line newLine) {
    final anglesBetweenLines = parallelLines.first.getAngleBetweenLines(
      otherLine: mutableLine,
      angleType: AngleType.degrees,
    );
    final interception1 = parallelLines.first.getIntersection(mutableLine);
    final interception2 = parallelLines.last.getIntersection(mutableLine);

    correspondingAngles.clear();
    correspondingAngles[CorrespondingAngleName.alpha] = CorrespondingAngle(angleVal:
    anglesBetweenLines[AngleProps.theta] ?? 0.0,
        correspondingAngles: [
          Angle(
            leadingLine: Line(
              // not draggable line
              a: DragPoint(point: interception1),
              b: parallelLines.first.a,
            ),
            followingLine: Line(
              // not draggable line
              a: DragPoint(point: interception1),
              b: mutableLine.b,
            ),
          ),
          Angle(
            leadingLine: Line(
              // not draggable line
              a: DragPoint(point: interception2),
              b: mutableLine.b,
            ),
            followingLine: Line(
              // not draggable line
              a: DragPoint(point: interception2),
              b: parallelLines.last.a,
            ),
          ),
        ]);

    correspondingAngles[CorrespondingAngleName.beta] = CorrespondingAngle(
        angleVal: anglesBetweenLines[AngleProps.thetaSupp] ?? 0.0,
        correspondingAngles: [
          Angle(
            leadingLine: Line(
              // not draggable line
              a: DragPoint(point: interception1),
              b: parallelLines.first.b,
            ),
            followingLine: Line(
              // not draggable line
              a: DragPoint(point: interception1),
              b: mutableLine.b,
            ),
          ),
          Angle(
            leadingLine: Line(
              // not draggable line
              a: DragPoint(point: interception2),
              b: parallelLines.last.b,
            ),
            followingLine: Line(
              // not draggable line
              a: DragPoint(point: interception2),
              b: mutableLine.b,
            ),
          ),
        ]);
  }

  Widget drawableView(DockSide dock) {
    return InfiniteDrawer(
      actionsDockSide: dock,
      enableCrossAxes: true,
      enablePinchAngle: true,
      enablePanning: false,
      drawableShapes: _drawablesShapes,
      onRotateShape: (oldShapes, rotationAngle, rotationOffset, angleType) {
        if (oldShapes.isEmpty && _drawablesShapes.isEmpty) return;
        setState(() {
          for (final oldShape in oldShapes) {
            final index = _drawablesShapes.indexOf(oldShape as DrawableLine);
            if (index != -1) {
              final newShape = oldShape.rotate(
                rotationAngle: rotationAngle - rotationOffset,
                angleType: angleType,
              );

              _drawablesShapes[index] = newShape;
              changeProperties(newShape.shape as Line);
              changeDrawableShapes();
            }
          }
        });
      },
    );
  }

  DrawableLine changeDrawableLine({required Line line,
    bool legend = true,
    Color lineColor = Colors.grey,
    double widthLine = 3.0}) {
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
          [ShowLineProperty.solid],
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
          [ShowProperty.interception],
          canvasTransform: canvasTransform,
          viewportSize: viewportSize,
          angleColor: color,
          widthLine: widthLine,
          arcRadius: arcRadius,
        );
      },
    );
  }

  void changeDrawableShapes() {
    _drawablesShapes.clear();
    _drawablesShapes.add(
      changeDrawableLine(line: mutableLine, legend: false, lineColor: Colors.brown.shade400, widthLine: 4.0),
    );
    _drawablesShapes.add(
      changeDrawableLine(line: parallelLines.first),
    );
    _drawablesShapes.add(
      changeDrawableLine(line: parallelLines.last, legend: false),
    );
    _drawablesShapes.add(
      changeDrawableAngle(
        angle: correspondingAngles[CorrespondingAngleName.alpha]!
            .correspondingAngles
            .first,
        color: Colors.green,
        widthLine: 3.0,
        arcRadius: 35.0,
      ),
    );
    _drawablesShapes.add(
      changeDrawableAngle(
        angle: correspondingAngles[CorrespondingAngleName.alpha]!
            .correspondingAngles
            .last,
        color: Colors.green,
        widthLine: 3.0,
        arcRadius: 35.0,
      ),
    );
    _drawablesShapes.add(
      changeDrawableAngle(
        angle: correspondingAngles[CorrespondingAngleName.beta]!
            .correspondingAngles
            .first,
        color: Colors.red,
        widthLine: 3.0,
        arcRadius: 45.0,
      ),
    );
    _drawablesShapes.add(
      changeDrawableAngle(
        angle:
        correspondingAngles[CorrespondingAngleName.beta]!.correspondingAngles.last,
        color: Colors.red,
        widthLine: 3.0,
        arcRadius: 45.0,
      ),
    );
  }
}
