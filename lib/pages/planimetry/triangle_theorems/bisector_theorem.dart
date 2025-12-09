

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

class BisectorTheorem extends StatefulWidget {
  final String title;
  const BisectorTheorem({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _BisectorTheoremState();
}

class _BisectorTheoremState extends State<BisectorTheorem> {
  final triangle = Triangle(a: Offset(-4, -2), b: Offset(1, 3), c: Offset(4, -2));
  DockSide dock = DockSide.leftTop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final ab = (triangle.a-triangle.b).distance;
    final bc = (triangle.b-triangle.c).distance;
    String bisectorAngle = r"\sphericalangle \alpha = \sphericalangle \beta";
    String bisectorRel = r"\frac{|AB|}{|BC|} = \frac{|AP|}{|PC|} \Leftrightarrow \frac{"+
      ab.toStringAsFixed(2) + r"}{" + bc.toStringAsFixed(2) + r"}";

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
                expression: bisectorAngle,
                scale: 1.5,
              ),
              const SizedBox(height: 4),
              DisplayExpression(
                context: context,
                expression: bisectorRel,
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

  drawableView(DockSide dock) {
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
      ],
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
          [triangle],
          [ ShowTriangleProperty.bisector],
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
    final bisectorPoint = triangle.getBisectorPoint(triangle.b, triangle.a, triangle.c);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Shrinkable(
        title: l10n.vertexInputTitle,
        titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
        expanded: true,
        body: InputValuesForm<double>(
          contents: [
            [
              CellData(label: "P", readOnly: true),
              CellData(label: bisectorPoint.dx.toStringAsFixed(2),
                 readOnly: true,
              ),
              CellData(label: bisectorPoint.dy.toStringAsFixed(2),
                readOnly: true,
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
        aPointData.firstWhere((point) => point.label == "x").cellValue!,
        aPointData.firstWhere((point) => point.label == "y").cellValue!);
    final b = Offset(
        bPointData.firstWhere((point) => point.label == "x").cellValue!,
        bPointData.firstWhere((point) => point.label == "y").cellValue!);
    final c = Offset(
        cPointData.firstWhere((point) => point.label == "x").cellValue!,
        cPointData.firstWhere((point) => point.label == "y").cellValue!);

    setState(() {
      triangle.update(a, b, c);
    });
  }
}
