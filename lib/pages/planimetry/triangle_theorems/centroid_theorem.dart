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

class CentroidTheorem extends StatefulWidget {
  final String title;
  const CentroidTheorem({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _CentroidTheoremState();
}

class _CentroidTheoremState extends State<CentroidTheorem> {
  final triangle = Triangle(a: Offset(-3, -2), b: Offset(1, 3), c: Offset(5, -2));
  DockSide dock = DockSide.leftTop;

  @override
  Widget build(BuildContext context) {
    final centroidPoint = triangle.getCentroidPoint();
    final medianA = triangle.getMedianPoint(triangle.b, triangle.c);
    final medianB = triangle.getMedianPoint(triangle.a, triangle.c);
    final relCa = (triangle.a - centroidPoint).distance / (medianA - centroidPoint).distance;
    final relCb = (triangle.b - centroidPoint).distance / (medianB - centroidPoint).distance;
    // final medianPoint = triangle.getMedianPoint(begin, end);
    // final centroidLength = triangle.getMedianPoint(begin, end);
    //
    final l10n = AppLocalizations.of(context)!;
    String centroid = r"C_p = \frac{A + B + C}{3} = (" +
        centroidPoint.dx.toStringAsFixed(2) + ", " +
        centroidPoint.dy.toStringAsFixed(2) + ")";
    String sRelCa = r"\frac{|A C_p|}{|C_p M_A|} = " + relCa.toStringAsFixed(2);
    String sRelCb = r"\frac{|B C_p|}{|C_p M_B|} = " + relCb.toStringAsFixed(2);
    String sRelCc = r"\frac{|C C_p|}{|C_p M_B|} = " + relCb.toStringAsFixed(2);

    return BackgroundContainer(
      beginColor: Colors.grey.shade50,
      endColor: Colors.grey.shade300,
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
                expression: centroid,
                scale: 1.5,
              ),
              const SizedBox(height: 4),
              DisplayExpression(
                context: context,
                expression: sRelCa,
                scale: 1.5,
              ),
              const SizedBox(height: 4),
              DisplayExpression(
                context: context,
                expression: sRelCb,
                scale: 1.5,
              ),
              const SizedBox(height: 4),
              DisplayExpression(
                context: context,
                expression: sRelCc,
                scale: 1.5,
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
          double unitInPixels,
          triangle,
          ) {
        return TrianglePainter(
          unitInPixels,
          triangle,
          [ ShowTriangleProperty.centroidPoint ],
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

  Widget inputValuesForm(l10n, triangle) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
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