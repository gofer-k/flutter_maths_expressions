import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/Themes/math_theme.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';
import 'package:flutter_maths_expressions/widgets/infinite_drawer.dart';
import 'package:flutter_maths_expressions/widgets/input_values_form.dart';
import 'package:flutter_maths_expressions/widgets/shrinkable.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/shrinkable_list_Item.dart';

class TrianglePropertiesPage extends StatefulWidget {
  final String title;

  const TrianglePropertiesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TrianglePropertiesPageState();
}

class _TrianglePropertiesPageState extends State<TrianglePropertiesPage> {
  final triangle = Triangle(a: Offset(-1, -1), b: Offset(3, 3), c: Offset(4, -1));
  DockSide dock = DockSide.leftTop;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final perimeter = triangle.getPerimeter();
    final area = triangle.getArea();
    final heronFormulaResult = triangle.getHeronFormula();

    String triangleArea = triangle.b.dx == triangle.a.dx
        ? r"A = \frac{1}{2} \cdot \text{|AC|} \cdot \text{|AB|} = " + area.toStringAsFixed(2)
        : triangle.b.dx == triangle.c.dx
        ? r"A = \frac{1}{2} | AC | \cdot | BC | = " + area.toStringAsFixed(2)
        : r"A = \frac{1}{2} | AC | \cdot | BD | = " + area.toStringAsFixed(2);

    String triangleArea2 = r"A = \frac{1}{2} \text{|AB|} \cdot \text{|BB|} \sin(\beta) = " + area.toStringAsFixed(2);

    String trianglePerimeter = r"P = \text{|AB| + |AC| + |BC|} = " + perimeter.toStringAsFixed(2);

    String szHeronProperties = r"P_h = \frac{P}{2}, a = |BC|, b = |AC|, c = |AB|";
    String szHeronFormula = r"A = \sqrt{P_h (P_h - a)(P_h - b)(P_h - c}) = "+
      heronFormulaResult.toStringAsFixed(2);

    final List<Widget> areaExpressions = [
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          expression: triangleArea,
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      const SizedBox(height: 2),
      FittedBox(
        fit: BoxFit.fitWidth,
        child:  DisplayExpression(
          context: context,
          expression: triangleArea2,
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
    ];
    final List<Widget> heronFormula = [
      FittedBox(
        fit: BoxFit.fitWidth,
          child: DisplayExpression(
          context: context,
          expression: trianglePerimeter,
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          expression: szHeronProperties,
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      const SizedBox(height: 4),
      FittedBox(fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          expression: szHeronFormula,
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
    ];

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
              Expanded(flex: 3, child: drawableView(DockSide.leftTop)),
              const SizedBox(height: 4),
              ShrinkableListItem(
                title:  l10n.parameters,
                details: areaExpressions,
                titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
              ),
              ShrinkableListItem(
                title:  l10n.triangleHeronsFormula,
                details: heronFormula,
                titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
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
                ShowTriangleProperty.height,
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
