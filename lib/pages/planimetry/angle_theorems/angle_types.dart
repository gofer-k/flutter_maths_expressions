import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/models/planimetry/angle.dart';
import 'package:flutter_maths_expressions/models/planimetry/drag_point.dart';
import 'package:flutter_maths_expressions/models/planimetry/line.dart';

import '../../../Themes/math_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/dock_side.dart';
import '../../../painters/angle_painter.dart';
import '../../../painters/drawable_shape.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
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
      leadingLine: Line(  // not draggable line
          a: DragPoint(point: Offset(0.0, 0.0)),
          b: DragPoint(point: Offset(4.0, 0.0))),
      followingLine: Line(  // not draggable line
          a: DragPoint(point: Offset(0.0, 0.0)),
          b: DragPoint(point: Offset(0.0, 4.0))));

  // late Angle angle = originAngle;
  late Angle leadingAngle = originAngle;
  late Angle followingAngle;
  late ShowAngleType type = ShowAngleType.angle;

  final List<DrawableShape<AnglePainter>> _drawablesShapes = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    changeAngleProperties(type);
    changeDrawableShapes();
  }

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
              LayoutBuilder(builder: (context, constraints){
                if (type == ShowAngleType.complementary) {
                  final complementaryAngles = leadingAngle.getComplementaryAngles(angleType: AngleType.degrees);
                  return DisplayExpression(
                    context: context,
                    expression: r"\alpha = " + complementaryAngles.first.toStringAsFixed(1) +
                      r"^\circ, \beta = " + complementaryAngles.last.toStringAsFixed(1) + r"^\circ",
                    scale: 1.5);
                }
                else if (type == ShowAngleType.supplementary) {
                  final supplementaryAngles = leadingAngle.getSupplementaryAngle(angleType: AngleType.degrees);
                  return DisplayExpression(
                    context: context,
                    expression: r"\alpha = " + supplementaryAngles.first.toStringAsFixed(1) +
                        r"^\circ, \beta = " + supplementaryAngles.last.toStringAsFixed(1) + r"^\circ",
                    scale: 1.5);
                }
                return DisplayExpression(
                  context: context,
                  expression: r"\alpha = " + leadingAngle.getAngle(angleType: AngleType.degrees).toStringAsFixed(1) + r"^\circ",
                  scale: 1.5,
                );
              }),
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
                              changeDrawableShapes();
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
    return InfiniteDrawer(
      actionsDockSide: dock,
      enableCrossAxes: true,
      drawableShapes: _drawablesShapes,
      onShapeChanged: (oldShapes, originPoint, targetPoint) {
        setState(() {
          for (final oldShape in oldShapes) {
            final index = _drawablesShapes.indexOf(
                oldShape as DrawableShape<AnglePainter>);
            if (index != -1) {
              final newShape = oldShape.moveByPoint(
                  point: originPoint, delta: targetPoint - originPoint,
                  tolerance: 0.25);
              _drawablesShapes[index] = newShape;
              if (leadingAngle == oldShape.shape as Angle) {
                leadingAngle = newShape.shape as Angle;
              }
              if (followingAngle == oldShape.shape as Angle) {
                followingAngle = newShape.shape as Angle;
              }
            }
          }
        });
      }
    );
  }

  DrawableShape<AnglePainter> generateDrawableAngle(Angle angle, Color color) {
    return DrawableShape<AnglePainter>(
      shape: angle,
      labelsSpans: [
        TextSpan(
          text: "α, ",
          style: TextStyle(color: Colors.green, fontSize: 28),
        ),
        TextSpan(
          text: "β, ",
          style: TextStyle(color: Colors.red, fontSize: 28),
        ),
      ],
      createPainter:
        (
          Matrix4 canvasTransform,
          Size viewportSize,
          double widthUnitInPixels,
          double heightUnitInPixels,
          angle,
          ) {
        return AnglePainter(
            widthUnitInPixels,
            heightUnitInPixels,
            angle,
            canvasTransform: canvasTransform,
            viewportSize: viewportSize,
            angleColor: color);
      },
    );
  }

  void changeDrawableShapes() {
    _drawablesShapes.clear();
    switch(type) {
      case ShowAngleType.complementary:
      case ShowAngleType.supplementary:
        _drawablesShapes.add(generateDrawableAngle(leadingAngle, Colors.green));
        _drawablesShapes.add(generateDrawableAngle(followingAngle, Colors.red));
        break;
      case ShowAngleType.angle:
        _drawablesShapes.add(generateDrawableAngle(leadingAngle, Colors.green));
        break;
    }
  }

  void changeAngleProperties(ShowAngleType type) {
    final sourceLeading = originAngle.leadingLine;
    final sourceFollowing = originAngle.followingLine;

    switch(type) {
      case ShowAngleType.complementary:
        final line = Line(
          a: sourceLeading.a,
          b: DragPoint(point: Offset(  // draggable point
            sourceLeading.b.dx + sourceFollowing.b.dx,
            sourceLeading.b.dy + sourceFollowing.b.dy),
            enableDragging: true)
        );
        leadingAngle = Angle(leadingLine: sourceLeading, followingLine: line);
        followingAngle = Angle(leadingLine: line, followingLine: sourceFollowing);
      break;
      case ShowAngleType.supplementary:
        final line = Line(
            a: sourceLeading.a,
            b: DragPoint(point: Offset(  // draggable point
              sourceLeading.b.dx + sourceFollowing.b.dx,
              sourceLeading.b.dy + sourceFollowing.b.dy),
              enableDragging: true)
        );
        leadingAngle = Angle(leadingLine: sourceLeading, followingLine: line);
        followingAngle = Angle(
          leadingLine: line,
          followingLine: Line( // not draggable Line
              a: DragPoint(point: Offset(0.0, 0.0)),
              b: DragPoint(point: Offset(-4.0, 0.0))));
      break;
      case ShowAngleType.angle:
        leadingAngle = originAngle.copyWith() as Angle;
        followingAngle = originAngle.copyWith() as Angle;
        break;
    }
  }
}