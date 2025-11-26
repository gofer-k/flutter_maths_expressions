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

class ApolloniusTheorem extends StatefulWidget {
  final String title;
  const ApolloniusTheorem({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _ApolloniusTheoremState();
}

class _ApolloniusTheoremState extends State<ApolloniusTheorem> {
  final triangle = Triangle(a: Offset(-4, -2), b: Offset(1, 3), c: Offset(4, -2));
  DockSide dock = DockSide.leftTop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final a = (triangle.b - triangle.c).distance;
    final b = (triangle.a - triangle.c).distance;
    final c = (triangle.a - triangle.b).distance;
    final m = (triangle.getMedianPoint(triangle.a, triangle.c) - triangle.b).distance;
    final a2 = a * a;
    final b2 = b * b;
    final c2 = c * c;
    final m2 = m * m;

    String szProperties = r"a = |BC|, b = |AC|, c = |AB|, m = |BM|";
    String szApolloniusTheorem = r"a^2 + c^2 = 2 \cdot m^2 + \frac{b^2}{2}";
    String szApolloniusTheoremResult = a2.toStringAsFixed(1) + r"+" + c2.toStringAsFixed(1) +
        r"= 2 \cdot " + m2.toStringAsFixed(1) + r"+" + (b2 / 2.0).toStringAsFixed(1);

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
            title: FittedBox(fit: BoxFit.fitWidth,
              child: Text(widget.title,
                style: Theme.of(context).textTheme.headlineMedium,
                ),
            ),
          ),
          body: Column(
            children: [
              Expanded(flex: 2, child: drawableView(DockSide.leftTop)),
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
                    expression: szApolloniusTheorem,
                    scale: 1.5,
                  ),
                  DisplayExpression(
                    context: context,
                    expression: szApolloniusTheoremResult,
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

  Widget drawableView(DockSide dock) {
    final drawableTriangle = DrawableShape<TrianglePainter>(
      shape: triangle,
      labelsSpans: [],
      createPainter:
          (
          Matrix4 canvasTransform,
          Size viewportSize,
          double widthUnitInPixels,
          double heightUnitInPixels,
          triangle,
          ) {
        return TrianglePainter(
          widthUnitInPixels,
          heightUnitInPixels,
          triangle,
          [ ShowTriangleProperty.medianPont],
          canvasTransform: canvasTransform,
          viewportSize: viewportSize
        );
      },
    );

    return InfiniteDrawer(
      actionsDockSide: dock,
      drawableShapes: [ drawableTriangle ],
    );
  }

  inputValuesForm(AppLocalizations l10n, Triangle triangle) {
    final medianPoint = triangle.getMedianPoint(triangle.a, triangle.c);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Shrinkable(
        title: l10n.vertexInputTitle,
        titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
        expanded: true,
        body: InputValuesForm<double>(
          contents: [
            [
              CellData(label: "M", readOnly: true),
              CellData(label: medianPoint.dx.toStringAsFixed(2), readOnly: true,
              ),
              CellData(label: medianPoint.dy.toStringAsFixed(2), readOnly: true,
              ),
            ],
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