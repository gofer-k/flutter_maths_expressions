import 'package:flutter/material.dart';

import '../../../Themes/math_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';
import '../../../widgets/input_values_form.dart';
import '../../../widgets/shrinkable.dart';
import '../../../widgets/shrinkable_list_Item.dart';

class IncenterTheoremPage extends StatefulWidget {
  final String title;

  const IncenterTheoremPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _IncenterTheoremPageState();
}

class _IncenterTheoremPageState extends State<IncenterTheoremPage> {
  final triangle = Triangle(a: Offset(-4, -2), b: Offset(1, 3), c: Offset(4, -2));
  DockSide dock = DockSide.leftTop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final incenter = triangle.getIncenter();
    final bisectorPoint = triangle.getBisectorPoint(triangle.a, triangle.b, triangle.c);
    final ri = (incenter - bisectorPoint).distance;
    final halfPerimeter = triangle.getPerimeter() / 2.0;
    final heronFormulaResult = triangle.getHeronFormula();

    String szProperties = r"a = |BC|, b = |AC|, c = |AB|, m = |BM|";
    String szIncenter = r"Incenter (" + incenter.dx.toStringAsFixed(2) +
        r", " + incenter.dy.toStringAsFixed(2) + r")";

    String szHalfPerimeter = r"s = \frac{a+b+c}{2} = " + halfPerimeter.toStringAsFixed(2);
    String szArea = r"A = \sqrt{P_h \dot (P_h - a)(P_h - b)(P_h - c} = "+
        heronFormulaResult.toStringAsFixed(2);
    String szInradius = r" r = \frac{A}{s} = " + ri.toStringAsFixed(2);

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
                  FittedBox(fit: BoxFit.fitWidth,
                      child: DisplayExpression(
                      context: context,
                      expression: szProperties,
                      scale: 1.5,
                    ),
                  ),
                  DisplayExpression(
                    context: context,
                    expression: szIncenter,
                    scale: 1.5,
                  ),
                  DisplayExpression(
                    context: context,
                    expression: szHalfPerimeter,
                    scale: 1.5,
                  ),
                  FittedBox(fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                      context: context,
                      expression: szArea,
                      scale: 1.5,
                    ),
                  ),
                  DisplayExpression(
                    context: context,
                    expression: szInradius,
                    scale: 1.5,
                  ),
                ],
                titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
              ),
              const SizedBox(height: 4),
              Expanded(flex: 1, child: inputValuesForm(l10n, triangle)),
            ],
          ),
        ),
      ),
    );
  }

  drawableView(DockSide dock) {
    final drawableTriangle = DrawableShape<TrianglePainter>(
      shape: triangle,
      labelsSpans: [],
      createPainter:
          (
          Matrix4 canvasTransform,
          Size viewportSize,
          double unitInPixels,
          triangle,
          ) {
        return TrianglePainter(
          unitInPixels,
          triangle,
          [ ShowTriangleProperty.incenter],
          canvasTransform: canvasTransform,
          viewportSize: viewportSize,
          originUnitInPixels: unitInPixels,
        );
      },
    );

    return InfiniteDrawer(
      actionsDockSide: dock,
      drawableShapes: [ drawableTriangle ],
    );
  }

  inputValuesForm(AppLocalizations l10n, Triangle triangle) {
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