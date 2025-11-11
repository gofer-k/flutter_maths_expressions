import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/Themes/math_theme.dart';
import 'package:flutter_maths_expressions/widgets/shrinkable_table.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/similarity_type.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';

class TrianglesSimilarity extends StatefulWidget {
  final String title;

  const TrianglesSimilarity({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TrianglesSimilarityState();
}

class _TrianglesSimilarityState extends State<TrianglesSimilarity> {
  final originTriangle1 = Triangle(a: Offset(-4, 2), b: Offset(-2, 5), c: Offset(0, 2));
  late Triangle triangle1;
  late Triangle triangle2;
  late SimilarityType type = SimilarityType.sideSideSide;
  DockSide dock = DockSide.leftTop;

  @override
  void initState() {
    super.initState();
    changeTriangleProperties(type);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // final TextStyle? dropDownLabelStyle = Theme.of(context).textTheme.headlineSmall?.apply(color: Colors.blue.shade700);
    // final TextStyle? dropDownEntryLabelStyle = Theme.of(context).textTheme.headlineSmall?.apply(color: Colors.blue.shade900, fontSizeFactor: 0.75);
    // final MenuStyle dropDownMenuStyle = MenuStyle(
    //     shadowColor: WidgetStateProperty.all(Colors.transparent),
    //     backgroundColor: WidgetStateProperty.all(Colors.blueGrey.shade200),
    //     elevation: WidgetStateProperty.all(2),
    //     shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
    // );

    final dropdownLabel = [l10n.similaritySSS, l10n.similarityAAA, l10n.similaritySAS];

    return BackgroundContainer(
      beginColor: Colors.grey.shade50,
      endColor: Colors.grey.shade700,
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
              const SizedBox(height: 6),
              Expanded(flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: LayoutBuilder(builder: (context, constraints){
                    final double dropdownWidth = constraints.maxWidth;
                    return DropdownMenu(
                      width: dropdownWidth,
                      menuStyle: MathTheme.of(context).dropDownMenuStyle,
                      textStyle: MathTheme.of(context).dropDownLabelStyle,
                      initialSelection: type,
                      dropdownMenuEntries: List<DropdownMenuEntry<SimilarityType>>.generate(
                        SimilarityType.values.length, (index) => DropdownMenuEntry(
                          value: SimilarityType.values[index],
                          label: dropdownLabel[index],
                          labelWidget: SizedBox(
                              width: dropdownWidth,
                              child: Text(dropdownLabel[index], style: MathTheme.of(context).dropDownEntryLabelStyle))
                          ),
                      ),
                      onSelected: (newType) {
                        setState(() {
                          if (newType != null && newType != type) {
                            type = newType;
                            changeTriangleProperties(type);
                          }
                        });
                     });
                  }),
                ),
              ),
              Expanded(flex: 2, child: displayParameters(context, type)),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawableView(DockSide dock) {
    final drawableTriangle1 = DrawableShape<TrianglePainter>(
      shape: triangle1,
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
          triangle1,
          ) {
        return TrianglePainter(
          unitInPixels,
          triangle1,
          [
            ShowTriangleProperty.angleA,
            ShowTriangleProperty.angleB,
            ShowTriangleProperty.angleC,
          ],
          canvasTransform: canvasTransform,
          viewportSize: viewportSize,
          originUnitInPixels: unitInPixels,
        );
      },
    );
    final drawableTriangle2 = DrawableShape<TrianglePainter>(
      shape: triangle2,
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
          triangle1,
          ) {
        return TrianglePainter(
          unitInPixels,
          triangle1,
          [
            ShowTriangleProperty.angleA,
            ShowTriangleProperty.angleB,
            ShowTriangleProperty.angleC,
          ],
          canvasTransform: canvasTransform,
          viewportSize: viewportSize,
          originUnitInPixels: unitInPixels,
        );
      },
    );

    return InfiniteDrawer(
      actionsDockSide: dock,
      drawableShapes: [
        drawableTriangle1,
        drawableTriangle2
      ],
    );
  }

  void changeTriangleProperties(SimilarityType type) {
    switch(type) {
      case SimilarityType.sideSideSide:
        triangle1 = Triangle(a: originTriangle1.a, b: originTriangle1.b, c: originTriangle1.c);
        triangle2 = Triangle(a: originTriangle1.a, b: originTriangle1.b, c: originTriangle1.c);
        triangle2.translate(1, -6);
        break;
      case SimilarityType.angleAngleAngle:
        triangle1 = Triangle(a: originTriangle1.a, b: originTriangle1.b, c: originTriangle1.c);
        triangle2 = Triangle(a: originTriangle1.a, b: originTriangle1.b, c: originTriangle1.c);
        triangle2.scale(1.25);
        triangle2.translate(2, -6);
        break;
      case SimilarityType.sideAngleSide: {
        triangle1 = Triangle(a: originTriangle1.a, b: originTriangle1.b, c: originTriangle1.c);
        triangle2 = Triangle(a: originTriangle1.a,
          // Change target trangle equilateral to Isosceles type
          b: Offset(originTriangle1.b.dx, originTriangle1.b.dy + 1.5),
          c: originTriangle1.c);
        triangle2.translate(1, -7);
        break;
      }
    }
  }
  
  Widget displayParameters(BuildContext context, SimilarityType type) {
    // TODO improve table and text style
    final tableCellScale = 1.5;
    final tableItemDecoration = BoxDecoration(color: Colors.transparent);
    final tableHeaderTextStyle = TextStyle(
      color: Colors.lightBlueAccent,
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
    );
    final shrinkableTitleTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: Theme.of(context).textTheme.titleMedium?.fontWeight,
      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
    );

    switch(type) {
      case SimilarityType.sideSideSide:
        return displayParametersSimilaritySSS(
          context: context,
          scale: tableCellScale,
          decoration: tableItemDecoration,
          headerTextStyle: tableHeaderTextStyle,
          titleTextStyle: shrinkableTitleTextStyle);
      case SimilarityType.angleAngleAngle:
        return displayParametersSimilarityAAA(
          context: context,
          scale: tableCellScale,
          decoration: tableItemDecoration,
          headerTextStyle: tableHeaderTextStyle,
          titleTextStyle: shrinkableTitleTextStyle);
      case SimilarityType.sideAngleSide:
        return displayParametersSimilaritySAS(
          context: context,
          scale: tableCellScale,
          decoration: tableItemDecoration,
          headerTextStyle: tableHeaderTextStyle,
          titleTextStyle: shrinkableTitleTextStyle
        );
    }
  }

  Widget displayParametersSimilaritySSS({required BuildContext context,
    required double scale,
    required BoxDecoration decoration,
    required TextStyle headerTextStyle,
    required TextStyle titleTextStyle}) {

    final l10n = AppLocalizations.of(context)!;
    final List<List<Widget>> parameters = [
      [
        Text("-"), Text("${l10n.triangle}1"), Text("${l10n.triangle}2"),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"|AB|",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle1.a, triangle1.b).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle2.a, triangle2.b).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"|AC|",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: "${Triangle.getLength(triangle1.a, triangle1.c)..toStringAsFixed(2)}",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: "${Triangle.getLength(triangle2.a, triangle2.c)..toStringAsFixed(2)}",
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"|BC|",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle1.b, triangle1.c).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle2.b, triangle2.c).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ]
    ];
    
    return ShrinkableTable(title: l10n.similarityParameters,
      contents: parameters, titleStyle: titleTextStyle);
  }

  Widget displayParametersSimilarityAAA(
      {required BuildContext context,
      required double scale,
      required BoxDecoration decoration,
      required TextStyle headerTextStyle,
      required TextStyle titleTextStyle}) {
    final l10n = AppLocalizations.of(context)!;
    final titleTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: Theme.of(context).textTheme.titleMedium?.fontWeight,
      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
    );
    final List<List<Widget>> parameters = [
      [
        Text("${l10n.triangle}-"), Text("${l10n.triangle}1"), Text(l10n.triangle),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"\sphericalangle ABC",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: triangle1.getAngleA().toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: triangle2.getAngleA().toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"\sphericalangle BCA",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: triangle1.getAngleB().toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: triangle2.getAngleC().toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"\sphericalangle CAB",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: triangle1.getAngleC().toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: triangle2.getAngleC().toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ]
    ];

    return ShrinkableTable(title: l10n.similarityParameters,
        contents: parameters, titleStyle: titleTextStyle);
  }

  Widget displayParametersSimilaritySAS({
      required BuildContext context,
      required double scale,
      required BoxDecoration decoration,
      required TextStyle headerTextStyle,
      required TextStyle titleTextStyle}) {
    final l10n = AppLocalizations.of(context)!;
    final List<List<Widget>> parameters = [
      [
        Text("${l10n.triangle}-"), Text("${l10n.triangle}1"), Text("${l10n.triangle}2"),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"|AB|",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle1.a, triangle1.b).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle2.a, triangle2.b).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"\sphericalangle BCA",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: triangle1.getAngleB().toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: triangle2.getAngleB().toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"|BC|",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle1.b, triangle1.c).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle2.b, triangle2.c).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ],
    ];

    return ShrinkableTable(title: l10n.similarityParameters,
        contents: parameters, titleStyle: titleTextStyle);
  }
}

