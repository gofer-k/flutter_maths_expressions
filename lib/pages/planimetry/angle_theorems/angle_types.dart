import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/angle.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import '../../../Themes/math_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../painters/angle_painter.dart';
import '../../../painters/drawable_shape.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/infinite_drawer.dart';

class AngleTypesPage extends StatefulWidget {
  final String title;

  const AngleTypesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _AngleTypesPageState();
}

class _AngleTypesPageState extends State<AngleTypesPage> {
  DockSide dock = DockSide.leftTop;
  final originAngle = Angle(
      leadingLine: Line(a: Offset(0.0, 0.0), b: Offset(4.0, 0.0)),
      followingLine: Line(a: Offset(0.0, 0.0), b: Offset(0.0, 4.0)));

  late Angle angle = originAngle;
  late Line cuttingAngleLine;
  late ShowAngleType type = ShowAngleType.angle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> dropdownLabel = [
      l10n.angle,
      l10n.angleComplementary,
      l10n.angleSupplementary,
    ];
    
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
                        dropdownMenuEntries: List<DropdownMenuEntry<ShowAngleType>>.generate(
                          ShowAngleType.values.length, (index) => DropdownMenuEntry(
                            value: ShowAngleType.values[index],
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
                              changeAngleProperties(type);
                            }
                          });
                        });
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawableView(DockSide dock) {
    List<DrawableShape<AnglePainter>> drawableAngles= List.empty(growable: true);
    switch(type) {
      case ShowAngleType.complementary:
      case ShowAngleType.supplementary:
        drawableAngles.add(
           generateDrawableAngle(
             Angle(leadingLine: angle.leadingLine,
                 followingLine: cuttingAngleLine),
             Colors.green)
        );
        drawableAngles.add(
            generateDrawableAngle(
                Angle(leadingLine: cuttingAngleLine,
                    followingLine: angle.followingLine),
                Colors.red)
        );
        break;
      case ShowAngleType.angle:
        drawableAngles.add(generateDrawableAngle(originAngle, Colors.green));
        break;
    }

    return InfiniteDrawer(
      actionsDockSide: dock,
      enableCrossAxes: true,
      drawableShapes: drawableAngles,
    );
  }

  DrawableShape<AnglePainter> generateDrawableAngle(Angle angle, Color color) {
    return DrawableShape<AnglePainter>(
      shape: angle,
      labelsSpans: [],
      createPainter:
          (
          Matrix4 canvasTransform,
          Size viewportSize,
          double unitInPixels,
          angle,
          ) {
        return AnglePainter(
          unitInPixels,
          angle,
          angleColor: color,
          canvasTransform: canvasTransform,
          viewportSize: viewportSize,
          originUnitInPixels: unitInPixels,
        );
      },
    );
  }

  void changeAngleProperties(ShowAngleType type) {
    switch(type) {
      case ShowAngleType.complementary:
        angle = originAngle;
        cuttingAngleLine = Line(
          a: angle.leadingLine.a,
          b: Offset(  // Angle pi/4
            angle.leadingLine.b.dx + angle.followingLine.b.dx,
            angle.leadingLine.b.dy + angle.followingLine.b.dy)
        );
      break;
      case ShowAngleType.supplementary:
        angle = Angle(
          leadingLine: originAngle.leadingLine,
          followingLine: Line(a: Offset(0.0, 0.0), b: Offset(-4.0, 0.0)) // horizontal line
        );
        cuttingAngleLine = Line(
          a: originAngle.leadingLine.a,
          b: Offset(  // Angle pi/4
              originAngle.leadingLine.b.dx + originAngle.followingLine.b.dx,
              originAngle.leadingLine.b.dy + originAngle.followingLine.b.dy),
        );
      break;
      case ShowAngleType.angle:
        angle = originAngle;
        break;
    }
  }
}