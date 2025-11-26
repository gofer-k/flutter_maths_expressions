import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/base_shape.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/line_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/infinite_drawer.dart';
import '../../../widgets/input_values_form.dart';
import '../../../widgets/shrinkable.dart';

// TODO: finish this
class LinePropertiesPage extends StatefulWidget {
  final String title;

  const LinePropertiesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _LinePropertiesPageState();
}

class _LinePropertiesPageState extends State<LinePropertiesPage> {
  Line line = Line(a: Offset(-2, -3), b: Offset(1, 3));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
      child: SafeArea(
        child: Scaffold(
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
              // DisplayExpression(
              //   context: context,
              //   expression: triangleAngles,
              //   scale: 1.5,
              // ),
              // DisplayExpression(
              //   context: context,
              //   expression: strSumAngles,
              //   scale: 1.5,
              // ),
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
        DrawableShape<LinePainter>(
          shape: line,
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
              BaseShape triangle,
              ) {
            return LinePainter(
              widthUnitInPixels,
              heightUnitInPixels,
              triangle,
              [
                // TODO: fill in properties to display
              ],
              canvasTransform: canvasTransform,
              viewportSize: viewportSize,
            );
          },
        ),
      ],
    );
  }

  Widget inputValuesForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Shrinkable(
        title: l10n.vertexInputTitle,
        titleStyle: TextStyle(fontWeight: FontWeight.normal),
        expanded: true,
        body: InputValuesForm<double>(
          contents: [
            // TODO: fill in properties to display
            // [
            //   CellData(label: r"\alpha", readOnly: true),
            //   CellData(
            //     label: "x",
            //     cellValue: line.a.dx,
            //     readOnly: false,
            //   ),
            //   CellData(
            //     label: "y",
            //     cellValue: line.a.dy,
            //     readOnly: false,
            //   ),
            // ],
            // [
            //   CellData(label: "B", readOnly: true),
            //   CellData(
            //     label: "x",
            //     cellValue: triangle.b.dx,
            //     readOnly: false,
            //   ),
            //   CellData(
            //     label: "y",
            //     cellValue: triangle.b.dy,
            //     readOnly: false,
            //   ),
            // ],
            // [
            //   CellData(label: "C", readOnly: true),
            //   CellData(
            //     label: "x",
            //     cellValue: triangle.c.dx,
            //     readOnly: false,
            //   ),
            //   CellData(
            //     label: "y",
            //     cellValue: triangle.c.dy,
            //     readOnly: false,
            //   ),
            // ],
          ],
          onSubmit: (InputData<double> input) {
            convertUIDataToTriangle(input);
          },
        ),
      ),
    );
  }

  void convertUIDataToTriangle(InputData<double> input) {
    // TODO: fill in properties to display
    // Extract the coordinates for each point (A, B, C) from the input data.
    // final aPointData = input.firstWhere(
    //       (pointData) => pointData.any((cellData) => cellData.label == "A"),
    // );
    // final bPointData = input.firstWhere(
    //       (pointData) => pointData.any((cellData) => cellData.label == "B"),
    // );
    // final cPointData = input.firstWhere(
    //       (pointData) => pointData.any((cellData) => cellData.label == "C"),
    // );
    //
    // final a = Offset(
    //     aPointData.firstWhere((coord) => coord.label == "x").cellValue!,
    //     aPointData.firstWhere((coord) => coord.label == "y").cellValue!);
    // final b = Offset(
    //     bPointData.firstWhere((coord) => coord.label == "x").cellValue!,
    //     bPointData.firstWhere((coord) => coord.label == "y").cellValue!);
    // final c = Offset(
    //     cPointData.firstWhere((coord) => coord.label == "x").cellValue!,
    //     cPointData.firstWhere((coord) => coord.label == "y").cellValue!);

    // setState(() {
    //   line.update(a, b);
    // });
  }
}