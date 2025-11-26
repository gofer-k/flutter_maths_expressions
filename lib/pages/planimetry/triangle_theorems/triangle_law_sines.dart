import 'dart:math';

import 'package:flutter/material.dart';

import '../../../Themes/math_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/angle.dart';
import '../../../models/planimetry/base_shape.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';
import '../../../widgets/input_values_form.dart';
import '../../../widgets/shrinkable.dart';

class TriangleLawSines extends StatefulWidget {
  final String title;
  const TriangleLawSines({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TriangleLawSinesState();
}

class _TriangleLawSinesState extends State<TriangleLawSines> {
  final triangle = Triangle(a: Offset(-4, -2), b: Offset(1, 3), c: Offset(4, -2));
  DockSide dock = DockSide.leftTop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ab = (triangle.a - triangle.b).distance;
    final ac = (triangle.a - triangle.c).distance;
    final bc = (triangle.b - triangle.c).distance;
    final sinAlpha = sin(triangle.getAngleA(angleType: AngleType.radian));
    final sinBeta = sin(triangle.getAngleB(angleType: AngleType.radian));
    final sinGamma = sin(triangle.getAngleC(angleType: AngleType.radian));

    String szLawSines = r"\frac{|BC|}{\sin(\alpha)} = \frac{|AC|}{\sin(\beta)} = \frac{|AB|}{\sin(\gamma)} =";
    String szLawSinesCont = r"\frac{" + bc.toStringAsFixed(1) + r"}{" + sinAlpha.toStringAsFixed(1) +
        r"} = \frac{" + ac.toStringAsFixed(1) + r"}{" + sinBeta.toStringAsFixed(1) +
        r"} = \frac{" + ab.toStringAsFixed(1) + r"}{" + sinGamma.toStringAsFixed(1) + r"}";

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
              DisplayExpression(
                context: context,
                expression: szLawSines,
                scale: 1.5,
              ),
              const SizedBox(height: 4),
              DisplayExpression(
                context: context,
                expression: szLawSinesCont,
                scale: 1.5,
              ),
              const SizedBox(height: 4),
              Expanded(flex: 1, child: inputValuesForm(l10n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawableView(DockSide dock) {
    return InfiniteDrawer(
      actionsDockSide: dock,
      drawableShapes: [
        DrawableShape<TrianglePainter>(
          shape: triangle,
          labelsSpans: [
            TextSpan(
              text: "α, ",
              style: TextStyle(color: Colors.red, fontSize: 28),
            ),
            TextSpan(
              text: "β, ",
              style: TextStyle(color: Colors.blue, fontSize: 28),
            ),
            TextSpan(
              text: "γ",
              style: TextStyle(color: Colors.green, fontSize: 28),
            ),
          ],
          createPainter:
              (
              Matrix4 canvasTransform,
              Size viewportSize,
              double widthUnitInPixels,
              double heightUnitInPixels,
              BaseShape triangle,
              ) {
            return TrianglePainter(
              widthUnitInPixels,
              heightUnitInPixels,
              triangle,
              [
                ShowTriangleProperty.angleA,
                ShowTriangleProperty.angleB,
                ShowTriangleProperty.angleC,
              ],
              canvasTransform: canvasTransform,
              viewportSize: viewportSize,
            );
          },
        ),
      ],
    );
  }

  Widget inputValuesForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Shrinkable(
        title: l10n.vertexInputTitle,
        titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
        expanded: true,
        body: InputValuesForm<double>(
          contents: [
            [
              CellData(label: "A", readOnly: true),
              CellData(
                label: "x",
                cellValue: triangle.a.dx,
                readOnly: false,
              ),
              CellData(
                label: "y",
                cellValue: triangle.a.dy,
                readOnly: false,
              ),
            ],
            [
              CellData(label: "B", readOnly: true),
              CellData(
                label: "x",
                cellValue: triangle.b.dx,
                readOnly: false,
              ),
              CellData(
                label: "y",
                cellValue: triangle.b.dy,
                readOnly: false,
              ),
            ],
            [
              CellData(label: "C", readOnly: true),
              CellData(
                label: "x",
                cellValue: triangle.c.dx,
                readOnly: false,
              ),
              CellData(
                label: "y",
                cellValue: triangle.c.dy,
                readOnly: false,
              ),
            ],
            [
              CellData(label: "D", readOnly: true),
              CellData(
                label: triangle.getHeightPoint().dx.toStringAsFixed(
                  3,
                ),
                cellValue: triangle.getHeightPoint().dx,
                readOnly: true,
              ),
              CellData(
                label: triangle.getHeightPoint().dy.toStringAsFixed(
                  3,
                ),
                cellValue: triangle.getHeightPoint().dy,
                readOnly: true,
              ),
            ],
          ],
          onSubmit: (InputData<double> input) {
            convertUIDataToTriangle(input);
          },
        ),
      ),
    );
  }

  void convertUIDataToTriangle(InputData<double> input) {
    // Extract the coordinates for each point (A, B, C) from the input data.
    final aPointData = input.firstWhere(
          (pointData) => pointData.any((cellData) => cellData.label == "A"),
    );
    final bPointData = input.firstWhere(
          (pointData) => pointData.any((cellData) => cellData.label == "B"),
    );
    final cPointData = input.firstWhere(
          (pointData) => pointData.any((cellData) => cellData.label == "C"),
    );

    final a = Offset(
        aPointData.firstWhere((coord) => coord.label == "x").cellValue!,
        aPointData.firstWhere((coord) => coord.label == "y").cellValue!);
    final b = Offset(
        bPointData.firstWhere((coord) => coord.label == "x").cellValue!,
        bPointData.firstWhere((coord) => coord.label == "y").cellValue!);
    final c = Offset(
        cPointData.firstWhere((coord) => coord.label == "x").cellValue!,
        cPointData.firstWhere((coord) => coord.label == "y").cellValue!);

    setState(() {
      triangle.update(a, b, c);
    });
  }
}