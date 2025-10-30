import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/base_shape.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';
import '../../../widgets/input_values_form.dart';
import '../../../widgets/shrinkable.dart';

class TriangleAnglesPage extends StatefulWidget {
  final String title;

  const TriangleAnglesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TriangleAnglesPageState();
}

class _TriangleAnglesPageState extends State<TriangleAnglesPage> {
  final triangle = Triangle(a: Offset(-2, -3), b: Offset(1, 3), c: Offset(4, -3));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final angleA = triangle.getAngleA(angleType: AngleType.degrees);
    final angleB = triangle.getAngleB(angleType: AngleType.degrees);
    final angleC = triangle.getAngleC(angleType: AngleType.degrees);
    final sumAngles = angleA + angleB + angleC;

    String triangleAngles =
      r"\begin{array}{c}\alpha = " + angleA.toStringAsFixed(1) +  r"^o" +
      r"& \beta = " + angleB.toStringAsFixed(1)  +  r"^o" +
      r"& \gamma = " + angleC.toStringAsFixed(1)  +  r"^o \end{array}";
    String strSumAngles = r"\alpha + \beta + \gamma = " + sumAngles.toStringAsFixed(1)  +  r"^o";

    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
      child: SafeArea(
        child: Scaffold(
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
              Expanded(flex: 2, child: drawableView(DockSide.leftTop)),
              const SizedBox(height: 4),
              DisplayExpression(
                context: context,
                expression: triangleAngles,
                scale: 1.5,
              ),
              DisplayExpression(
                context: context,
                expression: strSumAngles,
                scale: 1.5,
              ),
              const SizedBox(height: 4),
              Expanded(flex: 2, child: inputValuesForm(l10n)),
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
              double unitInPixels,
              BaseShape triangle,
              ) {
            return TrianglePainter(
              unitInPixels,
              triangle,
              [
                ShowTriangleProperty.angleA,
                ShowTriangleProperty.angleB,
                ShowTriangleProperty.angleC,
              ],
              canvasTransform: canvasTransform,
              viewportSize: viewportSize,
              originUnitInPixels: unitInPixels,
            );
          },
        ),
      ],
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

  Widget inputValuesForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Shrinkable(
        title: l10n.vertexInputTitle,
        titleStyle: TextStyle(fontWeight: FontWeight.normal),
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
}