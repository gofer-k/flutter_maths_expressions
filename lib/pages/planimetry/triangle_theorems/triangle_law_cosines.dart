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
import '../../../widgets/shrinkable_list_Item.dart';

class TriangleLawCosines extends StatefulWidget {
  final String title;
  const TriangleLawCosines({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TriangleLawCosinesState();
}

class _TriangleLawCosinesState extends State<TriangleLawCosines> {
  final triangle = Triangle(a: Offset(-4, -2), b: Offset(1, 3), c: Offset(4, -2));
  DockSide dock = DockSide.leftTop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ab = (triangle.a - triangle.b).distance;
    final ac = (triangle.a - triangle.c).distance;
    final bc = (triangle.b - triangle.c).distance;
    final ab2 = ab * ab;
    final ac2 = ac * ac;
    final bc2 = bc * bc;
    final cosAlpha = cos(triangle.getAngleA(angleType: AngleType.radian));
    final cosBeta = cos(triangle.getAngleB(angleType: AngleType.radian));
    final cosGamma = cos(triangle.getAngleC(angleType: AngleType.radian));
    final cResult = ac2 + bc2 - 2 * ac * bc * cosGamma;
    final bResult = ab2 + bc2 - 2 * ab * bc * cosBeta;
    final aResult = ac2 + ab2 - 2 * ac * ab * cosAlpha;

    String szProperties = r"a = |BC|, b = |AC|, c = |AB|";
    String szLawCosines = r"a^2 = b^2 + c^2 - 2 \cdot b \cdot c \cos(\alpha) = " + aResult.toStringAsFixed(2);
    String szLawCosines2 = r"b^2 = c^2 + a^2 - 2 \cdot c \cdot a \cos(\beta) = " + bResult.toStringAsFixed(2);
    String szLawCosines3 = r"c^2 = b^2 + a^2 - 2 \cdot b \cdot a \cos(\gamma) = " + cResult.toStringAsFixed(2);

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
              ShrinkableListItem(
                title:  l10n.parameters,
                details: [
                  DisplayExpression(
                    context: context,
                    expression: szProperties,
                    scale: 1.5,
                  ),
                  DisplayExpression(
                    context: context,
                    expression: szLawCosines,
                    scale: 1.5,
                  ),
                  DisplayExpression(
                    context: context,
                    expression: szLawCosines2,
                    scale: 1.5,
                  ),
                  DisplayExpression(
                    context: context,
                    expression: szLawCosines3,
                    scale: 1.5,
                  ),
                ],
                titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
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