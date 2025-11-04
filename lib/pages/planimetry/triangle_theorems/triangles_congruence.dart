import 'dart:math';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/congruence_type.dart';
import '../../../models/planimetry/triangle.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/triangle_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/infinite_drawer.dart';

class TrianglesCongruence extends StatefulWidget {
  final String title;

  const TrianglesCongruence({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TrianglesCongruenceState();
}

class _TrianglesCongruenceState extends State<TrianglesCongruence> {
  final originTriangle1 = Triangle(a: Offset(-3, 1), b: Offset(-1, 4), c: Offset(1, 1));
  final originTriangle2 = Triangle(a: Offset(-1, -5), b: Offset(1, -2), c: Offset(3, -5));
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

    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
      // endColor: Colors.grey.shade800,
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
              Expanded(flex: 1,
                child: DropdownMenu(
                  helperText: l10n.congruenceType,
                  initialSelection: type,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: CongruenceType.sideSideSide, label: l10n.congruenceSSS),
                    DropdownMenuEntry(value: CongruenceType.sideAngleSide, label: l10n.congruenceSAS),
                    DropdownMenuEntry(value: CongruenceType.angleSideAngle, label: l10n.congruenceASA),
                  ],
                  onSelected: (newType) {
                    setState(() {
                      if (newType != null && newType != type) {
                        type = newType;
                        changeTriangleProperties(type);
                      }
                    });
                  }),
              ),
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
        triangle2.scale(0.75);
        break;
      case CongruenceType.sideAngleSide:
        triangle1 = Triangle(a: originTriangle1.a, b: originTriangle1.b, c: originTriangle1.c);

        triangle2 = Triangle(a: originTriangle2.a,
            // Change target trangle equilateral to Isosceles type
            b: Offset(originTriangle2.b.dx, originTriangle2.b.dy - (originTriangle1.b.dy + originTriangle2.b.dy) / 2.0),
            c: originTriangle2.c);
        break;
      case CongruenceType.angleSideAngle: {
        triangle1 = Triangle(a: Offset(-4, 1), b: Offset(-3, 3), c: Offset(1, 1));
        triangle2 = Triangle(a: triangle1.c, b: triangle1.b, c: triangle1.a);
        triangle2.rotate(pi);
        triangle2.translate(1, -2);
        break;
      }
    }
  }
}

