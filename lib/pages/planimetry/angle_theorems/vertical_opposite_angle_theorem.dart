import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/angle.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import '../../../models/dock_side.dart';
import '../../../models/planimetry/drag_point.dart';
import '../../../painters/angle_painter.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/line_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';

class VerticalOppositeAngle extends StatefulWidget{
  final String title;
  const VerticalOppositeAngle({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _VerticalOppositeAngleState();
}

typedef DrawableLine = DrawableShape<LinePainter>;
typedef DrawableAngle = DrawableShape<AnglePainter>;

class _VerticalOppositeAngleState extends State<VerticalOppositeAngle> {
  DockSide dock = DockSide.leftTop;
  final List<Line> originLines = [
    Line(
      a: DragPoint(point: Offset(-4.0, -4.0), enableDragging: true),
      b: DragPoint(point: Offset(4.0, 4.0), enableDragging: true),
        enableRotate: true),
    Line(
      a: DragPoint(point: Offset(-4.0, 4.0), enableDragging: true),
      b: DragPoint(point: Offset(4.0, -4.0), enableDragging: true),
      enableDragging: true)];
  final List<DrawableShape> _drawablesShapes = List.empty(growable: true);
  final List<Line> lines = List.empty(growable: true);
  late double alphaAngle = 90.0;
  late double betaAngle = 90.0;
  final List<Angle> alphaAngles = List.empty(growable: true);
  final List<Angle> betaAngles = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    changeProperties(originLines);
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
              Expanded(flex: 1, child: Column(children: [
                // TODO: check alpha and beta values after rotation
                DisplayExpression(context: context,
                  expression: r"\alpha = ""${alphaAngle.toStringAsFixed(1)}"r"^\circ",
                  // expression: r"\alpha = ""${alphaAngles.first.getAngle(angleType: AngleType.degrees).toStringAsFixed(1)}"r"^\circ",
                  scale: 1.5),
                DisplayExpression(context: context,
                    expression: r"\alpha = ""${betaAngle.toStringAsFixed(1)}"r"^\circ",
                  // expression: r"\beta = ""${alphaAngles.first.getAngle(angleType: AngleType.degrees).toStringAsFixed(1)}"r"^\circ",
                  scale: 1.5),
                ]
              )),
            ],
          ),
        ),
      ),
    );
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
                  rotationAngle: rotationAngle,
                  angleType: angleType);

              _drawablesShapes[index] = newShape;
              for (final line in lines) {
                if (line == oldShape.shape as Line) {
                  lines[index] = newShape.shape as Line;
                }
              }
              alphaAngle = Angle.normalizeRad(angle: rotationAngle + rotationOffset / 2.0);
              betaAngle = Angle.normalizeRad(angle: rotationAngle - rotationOffset / 2.0);
              // Smallest positive sweep from na2 to na1.
              // Compute delta = (na1 - na2) mod 2π, choose the smaller arc (<= π).
              const twoPi = 2 * pi;
              double delta = alphaAngle - betaAngle;
              delta = (delta + twoPi) % twoPi;
              if (delta > pi) {
                // Swap to ensure delta is the smaller angle.
                delta = twoPi - delta;
              }
              alphaAngle = Angle.toDegrees(delta);
              betaAngle = Angle.toDegrees(twoPi - delta);
              changeAngles();
              changeDrawableShapes();
            }
          }
        });
      }
    );
  }

  DrawableLine changeDrawableLine(Line line, bool legend, Color lineColor) {
    return DrawableLine(
      shape: line,
      labelsSpans: [
        if(legend)
          TextSpan(
            text: "α, ",
            style: TextStyle(color: Colors.green, fontSize: 28),
          ),
        if(legend)
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
            widhtLine: 3.0,
            color: lineColor,
        );
      },
    );
  }

  DrawableAngle changeDrawableAngle(
      {required Angle angle, required Color color,
       double widthLine = 2.0, double arcRadius = 25.0}) {
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
            arcRadius: arcRadius);
      },
    );
  }

  void changeDrawableShapes() {
    _drawablesShapes.clear();
    _drawablesShapes.add(changeDrawableLine(lines.first, true, Colors.greenAccent));
    _drawablesShapes.add(changeDrawableLine(lines.last, false, Colors.redAccent));
    _drawablesShapes.add(changeDrawableAngle(angle: alphaAngles.first, color: Colors.green, widthLine: 3.0, arcRadius: 45.0));
    _drawablesShapes.add(changeDrawableAngle(angle: alphaAngles.last, color: Colors.green, widthLine: 3.0, arcRadius: 45.0));
    // TODO: correct draw beta angle after rotation
    _drawablesShapes.add(changeDrawableAngle(angle: betaAngles.first, color: Colors.red, widthLine: 4.0, arcRadius: 60.0));
    _drawablesShapes.add(changeDrawableAngle(angle: betaAngles.last, color: Colors.red, widthLine: 4.0, arcRadius: 60.0));
  }

  void changeProperties(List<Line> newLines) {
    for(final line in newLines) {
      lines.add(line.copyWith() as Line);
    }
    changeAngles();
  }

  void changeAngles() {

    final interception = lines.first.getIntersection(lines.last);
    alphaAngles.clear();
    alphaAngles.add(Angle(
      leadingLine: Line(  // not draggable line
        a: DragPoint(point: interception),
        b: lines.first.b),
      followingLine: Line(  // not draggable line
        a: DragPoint(point: interception),
        b: lines.last.a)));
    alphaAngles.add(Angle(
      leadingLine: Line(  // not draggable line
          a: DragPoint(point: interception),
          b: lines.first.a),
      followingLine: Line(  // not draggable line
          a: DragPoint(point: interception),
          b: lines.last.b)));
    betaAngles.add(Angle(
      leadingLine: Line(  // not draggable line
          a: DragPoint(point: interception),
          b: lines.last.a),
      followingLine: Line(  // not draggable line
          a: DragPoint(point: interception),
          b: lines.first.a)));
    betaAngles.add(Angle(
      leadingLine: Line(  // not draggable line
        a: DragPoint(point: interception),
        b: lines.last.b),
      followingLine: Line(  // not draggable line
        a: DragPoint(point: interception),
        b: lines.first.b)));
  }
}