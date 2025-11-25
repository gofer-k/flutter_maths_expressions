import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/angle.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import '../../../models/dock_side.dart';
import '../../../painters/angle_painter.dart';
import '../../../painters/drawable_shape.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/infinite_drawer.dart';

class AngleTypesPage extends StatefulWidget {
  final String title;

  const AngleTypesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _AngleTypesPageState();
}

class _AngleTypesPageState extends State<AngleTypesPage> {
  DockSide dock = DockSide.leftTop;
  final angle = Angle(
      leadingLine: Line(a: Offset(0.0, 0.0), b: Offset(4.0, 0.0)),
      followingLine: Line(a: Offset(0.0, 0.0), b: Offset(0.0, 4.0)));

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
              // ShrinkableListItem(
              //   title:  l10n.parameters,
              //   details: [
              //     FittedBox(fit: BoxFit.fitWidth,
              //       child: DisplayExpression(
              //         context: context,
              //         expression: centroid,
              //         scale: MathTheme.of(context).expressionScale?? 1.0,
              //       ),
              //     ),
              //     DisplayExpression(
              //       context: context,
              //       expression: sRelCa,
              //       scale: 1.5,
              //     ),
              //   ],
              //   titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
              // ),
              // const SizedBox(height: 4),
              // Expanded(flex: 1, child: inputValuesForm(l10n, triangle)),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawableView(DockSide dock) {
    final drawableAngle = DrawableShape<AnglePainter>(
      shape: angle,
      labelsSpans: [],
      createPainter:
          (
          Matrix4 canvasTransform,
          Size viewportSize,
          double unitInPixels,
          angle,
          ) {
        return AnglePainter(
          unitInPixels,
          angle,
          [ ShowAngleType.complementary ],
          canvasTransform: canvasTransform,
          viewportSize: viewportSize,
          originUnitInPixels: unitInPixels,
        );
      },
    );

    return InfiniteDrawer(
      actionsDockSide: dock,
      enableCrossAxes: true,
      drawableShapes: [ drawableAngle ],
    );
  }
}