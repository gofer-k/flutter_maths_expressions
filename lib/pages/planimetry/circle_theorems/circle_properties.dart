import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/angle.dart';
import 'package:flutter_maths_expressions/models/planimetry/circle.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/drag_point.dart';
import '../../../models/planimetry/line.dart';
import '../../../painters/circle_painter.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/line_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';
import '../angle_theorems/alternate_angles.dart';

class CirclePropertiesPage extends StatefulWidget {
  final String title;

  const CirclePropertiesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _CirclePropertiesPageState();
}

class _CirclePropertiesPageState extends State<CirclePropertiesPage> {
  final originCircle = Circle(center: Offset.zero, radius: 3.0);
  DockSide dock = DockSide.leftTop;
  late Circle mutableCircle;
  late Line mutableRadiusLine;
  late Line mutableDiameterLine;
  late Line mutableChordLine;
  late double mutableChordHeight = originCircle.radius / 2.0;

  final List<DrawableShape> _drawablesShapes = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mutableCircle = originCircle;
    mutableRadiusLine = Line(
      a: DragPoint(point: mutableCircle.center, enableDragging: true),
      b: DragPoint(
        point: Offset(
          mutableCircle.center.dx + mutableCircle.radius,
          mutableCircle.center.dy,
        ),
        enableDragging: true,
      ),
    );
    mutableDiameterLine = Line(
      a: DragPoint(
        point: DragPoint.rotatePoint(
          Offset(
            mutableCircle.center.dx - mutableCircle.radius,
            mutableCircle.center.dy,
          ),
          mutableCircle.center,
          pi / 3.0,
          angleType: AngleType.radian,
        ),
        enableDragging: true,
      ),
      b: DragPoint(
        point: DragPoint.rotatePoint(
          Offset(
            mutableCircle.center.dx + originCircle.radius,
            mutableCircle.center.dy,
          ),
          originCircle.center,
          pi / 3.0,
          angleType: AngleType.radian,
        ),
      ),
    );

    mutableChordLine = mutableCircle.buildChord(height: mutableChordHeight);
    changeDrawableShapes(AppLocalizations.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String szCircleArea =
        r"A = \pi \cdot r^2 ="" ${pi.toStringAsFixed(2)}"r"\cdot r^2 = ""${mutableCircle.getArea().toStringAsFixed(2)}";
    String szCircleCircumference =
        r"C = 2 \cdot \pi \cdot r = ""${mutableCircle
        .getCircumference()
        .toStringAsFixed(2)}";
    String szCircleChordLength =
        r"c_l = 2 \cdot \sqrt{2 c_h \cdot r - c^2_h} = ""${mutableCircle.getChordDistanceByHeight(mutableChordHeight).toStringAsFixed(1)}";
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
              Expanded(flex: 2, child: drawableView(dock, l10n)),
              const SizedBox(height: 4),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    DisplayExpression(
                      context: context,
                      expression: r"r = ""${mutableCircle.radius.toStringAsFixed(1)}",
                      scale: 2.0,
                    ),
                    SizedBox(height: 4),
                    DisplayExpression(
                      context: context,
                      expression: r"d = 2 \cdot r = ""${(mutableCircle.radius*2.0).toStringAsFixed(1)}",
                      scale: 2.0,
                    ),
                    SizedBox(height: 4),
                    DisplayExpression(
                      context: context,
                      expression: szCircleArea,
                      scale: 2.0,
                    ),
                    SizedBox(height: 4),
                    DisplayExpression(
                      context: context,
                      expression: szCircleCircumference,
                      scale: 2.0,
                    ),
                    SizedBox(height: 4),
                    DisplayExpression(
                      context: context,
                      expression: szCircleChordLength,
                      scale: 2.0,
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

  Widget drawableView(DockSide dock, AppLocalizations l10n) {
    return InfiniteDrawer(
      actionsDockSide: dock,
      drawableShapes: _drawablesShapes,
      enableCrossAxes: true,
      enablePinchAngle: false,
      enablePanning: false,
    );
  }

  void changeDrawableShapes(AppLocalizations l10n) {
    _drawablesShapes.clear();
    _drawablesShapes.add(
      DrawableShape<CirclePainter>(
        shape: mutableCircle,
        labelsSpans: [
          TextSpan(
            style: const TextStyle(fontSize: 20),
            children: [
              TextSpan(text: "${l10n.radius}\n",
                  style: TextStyle(color: Colors.redAccent)),
              TextSpan(text: "${l10n.diameter}\n",
                style: TextStyle(color: Colors.green),
              ),
              TextSpan(text: l10n.chord, style: TextStyle(color: Colors.deepPurple),
              ),
            ]
          ),
        ],
        createPainter:
            (
              Matrix4 canvasTransform,
              Size viewportSize,
              double widthUnitInPixels,
              double heightUnitInPixels,
              circle,
            ) {
              return CirclePainter(
                widthUnitInPixels,
                heightUnitInPixels,
                [circle],
                [ShowCircleProperty.circularSegment],
                canvasTransform: canvasTransform,
                viewportSize: viewportSize,
              );
            },
      ),
    );
    _drawablesShapes.add(
      changeDrawableLine(
        line: mutableRadiusLine,
        lineColor: Colors.redAccent,
        widthLine: 5.0,
      ),
    );
    _drawablesShapes.add(
      changeDrawableLine(
        line: mutableDiameterLine,
        lineColor: Colors.green,
        widthLine: 4.0,
      ),
    );
    _drawablesShapes.add(
      changeDrawableLine(
        line: mutableChordLine,
        lineColor: Colors.deepPurple,
        widthLine: 3.0,
        lineType: ShowLineProperty.dashed,
      ),
    );
  }

  DrawableLine changeDrawableLine({
    required Line line,
    Color lineColor = Colors.grey,
    double widthLine = 3.0,
    ShowLineProperty lineType = ShowLineProperty.solid,
  }) {
    return DrawableLine(
      shape: line,
      labelsSpans: [],
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
              showEnds: true
            );
          },
    );
  }
}
