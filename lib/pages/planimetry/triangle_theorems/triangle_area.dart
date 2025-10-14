import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';
import 'package:flutter_maths_expressions/widgets/infinite_drawer.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/factor_slider.dart';

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
            widget.title, style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Column(
          children: [
            Expanded(flex: 2,
              child: InfiniteDrawer(
                drawableShapes: [
                  DrawableShape<TrianglePainter>(
                    shape: triangle,
                    labelsSpans: [
                    TextSpan(text: "α, ", style: TextStyle(color: Colors.red, fontSize: 28)),
                    TextSpan(text: "β, ", style: TextStyle(color: Colors.blue, fontSize: 28)),
                    TextSpan(text: "γ", style: TextStyle(color: Colors.green, fontSize: 28))
                  ],
                  createPainter: (Matrix4 canvasTransform, Size viewportSize, double unitInPixels, BaseShape triangle) {
                    return TrianglePainter(
                      unitInPixels,
                      triangle,
                      canvasTransform: canvasTransform,
                      viewportSize: viewportSize,
                      originUnitInPixels: unitInPixels);
                  })
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(flex: 1,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                children: [
                  FactorSlider(label: "a", initialValue: 6, minValue: 3, maxValue: 30,
                    onChanged: (double value) {

                    },
                  ),
                  FactorSlider(label: "b", initialValue: 6, minValue: 3, maxValue: 30,
                    onChanged: (double value) {

                    },
                  ),
                  FactorSlider(label: "c", initialValue: 6, minValue: 3, maxValue: 30,
                    onChanged: (double value) {

                    },
                  ),
                ],
              )
            ),
            Expanded(flex: 1,
              child: Column(
                children: [
                  DisplayExpression(context: context,
                    expression: r"A = \frac{1}{2}a \cdot h", scale: 2.0),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}