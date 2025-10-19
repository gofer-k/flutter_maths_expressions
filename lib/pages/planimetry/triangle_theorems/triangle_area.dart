import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';
import 'package:flutter_maths_expressions/widgets/infinite_drawer.dart';
import 'package:flutter_maths_expressions/widgets/shrinkable.dart';
import 'package:flutter_maths_expressions/widgets/input_values_form.dart';
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
              flex: 2,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Shrinkable(
                  title: l10n.vertexInputTitle,
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
                    onSubmit: (Map<String, double> output) {
                      // TODO:
                    },
                  ),
                ),
              ),
              // _buildForm(l10n.vertexInputTitle, l10n),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  DisplayExpression(
                    context: context,
                    expression: r"A = \frac{1}{2}a \cdot h",
                    scale: 2.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildForm(String title, AppLocalizations l10n) {
  //   const spaceWidth = 16.0;
  //
  //   return SingleChildScrollView(padding: EdgeInsets.all(8),
  //     child: Form(key: _formKey,
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(title, style: Theme.of(context).textTheme.titleMedium),
  //           const SizedBox(height: spaceWidth, child: Divider(thickness: 2.0,)),
  //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(child: Text('A', style: Theme.of(context).textTheme.titleMedium,)),
  //               const VerticalDivider(color: Colors.black, thickness: 2.0,),
  //               Expanded(child: _buildVertexField('x', _axController, l10n)),
  //               const VerticalDivider(color: Colors.black, thickness: 2.0,),
  //               Expanded(child: _buildVertexField('y', _ayController, l10n)),
  //             ]
  //           ),
  //           // const SizedBox(height: spaceWidth, child: Divider(thickness: 2.0,)),
  //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(child: Text('B', style: Theme.of(context).textTheme.titleMedium,)),
  //               const VerticalDivider(color: Colors.black, thickness: 2.0,),
  //               Expanded(child: _buildVertexField('x', _bxController, l10n)),
  //               const VerticalDivider(color: Colors.black, thickness: 2.0,),
  //               Expanded(child: _buildVertexField('y', _byController, l10n)),
  //             ]
  //           ),
  //           // const SizedBox(height: spaceWidth, child: Divider(thickness: 2.0,)),
  //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(child: Text("C", style: Theme.of(context).textTheme.titleMedium,)),
  //               const VerticalDivider(color: Colors.black, thickness: 2.0,),
  //               Expanded(child: _buildVertexField('x', _cxController, l10n)),
  //               const VerticalDivider(color: Colors.black, thickness: 2.0,),
  //               Expanded(child: _buildVertexField('y', _cyController, l10n)),
  //             ]
  //           ),
  //           const SizedBox(height: spaceWidth),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (_formKey.currentState!.validate()) {
  //                 final ax = double.parse(_axController.text);
  //                 final ay = double.parse(_ayController.text);
  //                 final bx = double.parse(_bxController.text);
  //                 final by = double.parse(_byController.text);
  //                 final cx = double.parse(_cxController.text);
  //                 final cy = double.parse(_cyController.text);
  //                 triangle.update(Offset(ax, ay), Offset(bx, by), Offset(cx, cy));
  //               }
  //             },
  //             child: Text(l10n?.submit ?? 'Submit'),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
