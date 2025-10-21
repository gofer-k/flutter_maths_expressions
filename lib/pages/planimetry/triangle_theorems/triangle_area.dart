import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';
import 'package:flutter_maths_expressions/widgets/infinite_drawer.dart';
import 'package:flutter_maths_expressions/widgets/input_values_form.dart';
import 'package:flutter_maths_expressions/widgets/shrinkable.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';

class TriangleAreaPage extends StatefulWidget {
  final String title;

  const TriangleAreaPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TriangleAreaPageState();
}

class _TriangleAreaPageState extends State<TriangleAreaPage> {
  final triangle = Triangle(a: Offset(1, 1), b: Offset(3, 3), c: Offset(5, 1));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String triangleArea = triangle.b.dx == triangle.a.dx
        ? r"A = \frac{1}{2}|AC| \cdot |AB| = " + triangle.getArea().toStringAsFixed(2)
        : triangle.b.dx == triangle.c.dx
        ? r"A = \frac{1}{2}|AC| \cdot |BC| = " + triangle.getArea().toStringAsFixed(2)
        : r"A = \frac{1}{2}|AC| \cdot |BD| = " + triangle.getArea().toStringAsFixed(2);

    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
      // endColor: Colors.grey.shade800,
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
            Expanded(
              flex: 2,
              child: InfiniteDrawer(
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
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                      context: context,
                      expression: triangleArea,
                      scale: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Shrinkable(
                  title: l10n.vertexInputTitle,
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
              ),
            ),
          ],
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
