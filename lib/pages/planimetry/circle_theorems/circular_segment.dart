import 'dart:math';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/angle.dart';
import '../../../models/planimetry/circle.dart';
import '../../../models/planimetry/line.dart';
import '../../../painters/circle_painter.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/line_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';
import '../angle_theorems/alternate_angles.dart';

class CircularSegment extends StatefulWidget {
  final String title;

  const CircularSegment({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _CircularSegmentState();
}

class _CircularSegmentState extends State<CircularSegment> {
  DockSide dock = DockSide.leftTop;
  final originCircle = Circle(center: Offset.zero, radius: 4.0);
  late double mutableChordHeight = originCircle.radius / 2.0;
  late Line mutableChord;

  final List<DrawableShape> _drawablesShapes = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mutableChord = originCircle.buildChord(
      height: mutableChordHeight,
      draggable: true,
    );
    changeDrawableShapes(AppLocalizations.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chordLength = originCircle.getChordDistanceByHeight(
      mutableChordHeight,
    );
    final theta = 2 * asin(chordLength / (2.0 * originCircle.radius));
    final thetaAgrees = Angle.toDegrees(theta);
    final sinTheta = sin(theta);
    final area =
        (originCircle.radius * originCircle.radius) / 2.0 * (theta - sinTheta);

    String szCircleChordLength =
        r"c_l = 2 \cdot \sqrt{2 c_h \cdot r - c^2_h} = "
        "${chordLength.toStringAsFixed(2)}";
    String szCenterAngle =
        r"\Theta = 2 \cdot \arcsin{\frac{c_l}{2r}} = "
        "${thetaAgrees.toStringAsFixed(2)}"
        r"^\circ";
    String szCircularSegmentArea =
        r"A = \frac{r^2}{2}(\Theta - \sin{\Theta}) = "
        "${area.toStringAsFixed(2)}";

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
                      expression:
                          r"r = "
                          "${originCircle.radius.toStringAsFixed(1)}",
                      scale: 2.0,
                    ),
                    SizedBox(height: 4),
                    DisplayExpression(
                      context: context,
                      expression: szCircleChordLength,
                      scale: 2.0,
                    ),
                    SizedBox(height: 4),
                    DisplayExpression(
                      context: context,
                      expression: szCenterAngle,
                      scale: 2.0,
                    ),
                    SizedBox(height: 4),
                    DisplayExpression(
                      context: context,
                      expression: szCircularSegmentArea,
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
      enablePanning: true,
    );
  }

  void changeDrawableShapes(AppLocalizations l10n) {
    _drawablesShapes.clear();
    _drawablesShapes.add(
      DrawableShape<CirclePainter>(
        shape: originCircle,
        labelsSpans: [
          TextSpan(
            style: const TextStyle(fontSize: 16),
            children: [
              TextSpan(
                text: "${l10n.radius}\n",
                style: TextStyle(color: Colors.deepPurple),
              ),
              TextSpan(
                text: l10n.circularSegmentArea,
                style: TextStyle(color: Colors.purpleAccent),
              ),
            ],
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
                chordHeight: mutableChordHeight,
                canvasTransform: canvasTransform,
                viewportSize: viewportSize,
              );
            },
      ),
    );
    _drawablesShapes.add(
      changeDrawableLine(
        line: mutableChord,
        lineColor: Colors.deepPurple,
        widthLine: 3.0,
        lineType: ShowLineProperty.solid,
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
              showEnds: true,
            );
          },
    );
  }
}
