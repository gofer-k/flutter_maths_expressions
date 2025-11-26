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

class PythagorasTheorem extends StatefulWidget {
  final dynamic title;

  const PythagorasTheorem({super.key, this.title});

  @override
  State<StatefulWidget> createState() => _PythagorasTheoremState();
}

class _PythagorasTheoremState extends State<PythagorasTheorem>{
  final triangle = Triangle(a: Offset(-4, -2), b: Offset(-4, 3), c: Offset(3, -2));
  DockSide dock = DockSide.leftTop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bc = Triangle.getLength(triangle.b, triangle.c);
    final ac = Triangle.getLength(triangle.a, triangle.c);
    final ab = Triangle.getLength(triangle.a, triangle.b);
    final bc2 = bc * bc;
    final ac2 = ac * ac;
    final ab2 = ab * ab;

    String pithagorasTheorem = r"|BC|^2 = |AB|^2 + |AC|^2";
    String pithagorasTheoremResult = "${bc2.toStringAsFixed(2)} = ${ab2.toStringAsFixed(2)} + ${ac2.toStringAsFixed(2)}";

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
              DisplayExpression(
                context: context,
                expression: pithagorasTheorem,
                scale: 1.5,
              ),
              DisplayExpression(
                context: context,
                expression: pithagorasTheoremResult,
                scale: 1.5,
              ),
              const SizedBox(height: 6),
              Expanded(flex: 2, child: inputValuesForm(l10n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawableView(DockSide dock) {
    final drawableTriangle = DrawableShape<TrianglePainter>(
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
          triangle1,
          ) {
        return TrianglePainter(
          widthUnitInPixels,
          heightUnitInPixels,
          triangle1,
          [
            ShowTriangleProperty.angleA,
            ShowTriangleProperty.angleB,
            ShowTriangleProperty.angleC,
          ],
          canvasTransform: canvasTransform,
          viewportSize: viewportSize,
        );
      },
    );

    return InfiniteDrawer(
      actionsDockSide: dock,
      drawableShapes: [ drawableTriangle ],
    );
  }

  inputValuesForm(AppLocalizations l10n) {
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
              CellData(label: triangle.a.dx.toStringAsFixed(2), readOnly: true),
              CellData(label: triangle.a.dy.toStringAsFixed(2), readOnly: true),
            ],
            [
              CellData(label: "B", readOnly: true),
              CellData(label: triangle.b.dx.toStringAsFixed(2), readOnly: true),
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
              CellData(label: triangle.c.dy.toStringAsFixed(2), readOnly: true),
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
    final bPointData = input.firstWhere(
          (pointData) => pointData.any((cellData) => cellData.label == "B"),
    );
    final cPointData = input.firstWhere(
          (pointData) => pointData.any((cellData) => cellData.label == "C"),
    );

    final b = Offset(
      triangle.b.dx,
      bPointData.firstWhere((coord) => coord.label == "y").cellValue!);
    final c = Offset(
      cPointData.firstWhere((coord) => coord.label == "x").cellValue!,
      triangle.c.dy);

    setState(() {
      triangle.update(triangle.a, b, c);
    });
  }
}