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

class MedianTheoremPage extends StatefulWidget {
  final String title;

  const MedianTheoremPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _MedianTheoremPageState();
}

class _MedianTheoremPageState extends State<MedianTheoremPage> {
  final triangle = Triangle(a: Offset(-4, -2), b: Offset(-4, 3), c: Offset(3, -2));
  DockSide dock = DockSide.leftTop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final m = triangle.getMedianPoint(triangle.a, triangle.c);
    final triangleABM = Triangle(a: triangle.a, b: triangle.b, c: m);
    final triangleMBC = Triangle(a: m, b: triangle.b, c: triangle.c);

    String areaABC = r"A_ABC = \frac{1}{2}|AC| \dot h = " + triangle.getArea().toStringAsFixed(2);
    String areaABD = r"A_ABM = \frac{1}{2}|AM| \dot h = " + triangleABM.getArea().toStringAsFixed(2);
    String areaMBC = r"A_MBC = \frac{1}{2}|MC| \dot h = " + triangleMBC.getArea().toStringAsFixed(2);

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
              Expanded(flex: 2, child: drawableView(DockSide.leftTop)),
              const SizedBox(height: 4),
              ShrinkableListItem(
                title:  l10n.parameters,
                details: [
                  DisplayExpression(
                    context: context,
                    expression: areaABC,
                    scale: 1.5,
                  ),
                  DisplayExpression(
                    context: context,
                    expression: areaABD,
                    scale: 1.5,
                  ),
                  DisplayExpression(
                    context: context,
                    expression: areaMBC,
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
        triangle1,
        ) {
        return TrianglePainter(
          widthUnitInPixels,
          heightUnitInPixels,
          triangle1,
          [ ShowTriangleProperty.medianPont, ShowTriangleProperty.height ],
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
              CellData(label: "h", readOnly: true),
              CellData(label: triangle.getHeight().toStringAsFixed(2), readOnly: true,
              ),
              CellData(label: "-", readOnly: true,
              ),
            ],
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