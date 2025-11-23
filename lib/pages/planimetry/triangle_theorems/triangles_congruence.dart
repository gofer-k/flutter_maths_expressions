import 'dart:math';

import 'package:flutter/material.dart';

import '../../../Themes/math_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/congruence_type.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';
import '../../../widgets/shrinkable_table.dart';

class TrianglesCongruence extends StatefulWidget {
  final String title;

  const TrianglesCongruence({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TrianglesCongruenceState();
}

class _TrianglesCongruenceState extends State<TrianglesCongruence> {
  final originTriangle1 = Triangle(a: Offset(-3, 0.5), b: Offset(-1, 3.5), c: Offset(1, 0.5));
  final originTriangle2 = Triangle(a: Offset(-3, 0.5), b: Offset(-1, 3.5), c: Offset(1, 0.5));
  late Triangle triangle1;
  late Triangle triangle2;
  late CongruenceType type = CongruenceType.sideSideSide;
  DockSide dock = DockSide.leftTop;

  @override
  void initState() {
    super.initState();
    changeTriangleProperties(type);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dropdownLabel = [l10n.congruenceSSS, l10n.congruenceSAS, l10n.congruenceASA];

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
            title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
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
                        dropdownMenuEntries: List<DropdownMenuEntry<CongruenceType>>.generate(
                          CongruenceType.values.length, (index) => DropdownMenuEntry(
                            value: CongruenceType.values[index],
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

  void changeTriangleProperties(CongruenceType type) {
    switch(type) {
      case CongruenceType.sideSideSide:
        triangle1 = Triangle(a: originTriangle1.a, b: originTriangle1.b, c: originTriangle1.c);
        triangle2 = Triangle(a: originTriangle2.a, b: originTriangle2.b, c: originTriangle2.c);
        triangle2.translate(3, -3);
        break;
      case CongruenceType.sideAngleSide:
        triangle1 = Triangle(a: originTriangle1.a, b: originTriangle1.b, c: originTriangle1.c);
        final k = 2.0;
        final a = Offset(
            (triangle1.b.dx + k * triangle1.a.dx) / (1 + k),
            (triangle1.b.dy + k * triangle1.a.dy) / (1 + k));
        final c = Offset(
            (triangle1.b.dx + k * triangle1.c.dx) / (1 + k),
            (triangle1.b.dy + k * triangle1.c.dy) / (1 + k));
        triangle2 = Triangle(a: a, b: originTriangle1.b, c: c);
        triangle2.translate(2, -5);
        break;
      case CongruenceType.angleSideAngle: {
        triangle1 = Triangle(a: Offset(-4, 1), b: Offset(-3, 3), c: Offset(1, 1));
        triangle2 = Triangle(a: triangle1.a, b: triangle1.b, c: triangle1.c);
        triangle2.rotate(pi);
        triangle2.translate(1, -2);
        break;
      }
    }
  }

  Widget displayParameters(BuildContext context, CongruenceType type) {
    final tableCellScale = 1.5;
    final tableItemDecoration = BoxDecoration(color: Colors.transparent);
    final tableHeaderTextStyle = TextStyle(
      color: Colors.lightBlueAccent,
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
    );
    final shrinkableTitleTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: Theme.of(context).textTheme.titleMedium?.fontWeight,
      fontSize: 20.0,
    );

    switch(type) {
      case CongruenceType.sideSideSide:
        return displayParametersCongruenceTypeSSS(
            context: context,
            scale: tableCellScale,
            decoration: tableItemDecoration,
            headerTextStyle: tableHeaderTextStyle,
            titleTextStyle: shrinkableTitleTextStyle);
      case CongruenceType.sideAngleSide:
        return displayParametersCongruenceTypeSAS(
            context: context,
            scale: tableCellScale,
            decoration: tableItemDecoration,
            headerTextStyle: tableHeaderTextStyle,
            titleTextStyle: shrinkableTitleTextStyle);
      case CongruenceType.angleSideAngle:
        return displayParametersCongruenceTypeASA(
            context: context,
            scale: tableCellScale,
            decoration: tableItemDecoration,
            headerTextStyle: tableHeaderTextStyle,
            titleTextStyle: shrinkableTitleTextStyle
        );
    }
  }

  Widget displayParametersCongruenceTypeSSS({required BuildContext context,
    required double scale,
    required BoxDecoration decoration,
    required TextStyle headerTextStyle,
    required TextStyle titleTextStyle}) {

    final l10n = AppLocalizations.of(context)!;
    final List<List<Widget>> parameters = [
      [
        Text("-"),
        Text("${l10n.triangle}1", style: TextStyle(fontSize: 20.0),),
        Text("${l10n.triangle}2", style: TextStyle(fontSize: 20.0)),
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

  Widget displayParametersCongruenceTypeSAS(
      {required BuildContext context,
        required double scale,
        required BoxDecoration decoration,
        required TextStyle headerTextStyle,
        required TextStyle titleTextStyle}) {
    final l10n = AppLocalizations.of(context)!;
    final List<List<Widget>> parameters = [
      [
        Text("-", style: TextStyle(fontSize: 20.0),),
        Text("${l10n.triangle}1", style: TextStyle(fontSize: 20.0),),
        Text("${l10n.triangle}2", style: TextStyle(fontSize: 20.0)),
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
          expression: r"\sphericalangle ABC",
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
      ]
    ];

    return ShrinkableTable(title: l10n.similarityParameters,
        contents: parameters, titleStyle: titleTextStyle);
  }

  Widget displayParametersCongruenceTypeASA({
    required BuildContext context,
    required double scale,
    required BoxDecoration decoration,
    required TextStyle headerTextStyle,
    required TextStyle titleTextStyle}) {
    final l10n = AppLocalizations.of(context)!;
    final List<List<Widget>> parameters = [
      [
        Text("-"),
        Text("${l10n.triangle}1", style: TextStyle(fontSize: 20.0),),
        Text("${l10n.triangle}2", style: TextStyle(fontSize: 20.0),),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"\sphericalangle BAC",
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
          expression: r"AC|",
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle1.a, triangle1.c).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: Triangle.getLength(triangle2.a, triangle2.c).toStringAsFixed(2),
          scale: scale,
          textStyle: headerTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: decoration,
          expression: r"\sphericalangle ACB",
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
      ],
    ];

    return ShrinkableTable(title: l10n.similarityParameters,
        contents: parameters, titleStyle: titleTextStyle);
  }
}

