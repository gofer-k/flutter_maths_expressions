import 'package:flutter/material.dart';
import '../../../Themes/math_theme.dart';
import '../../../models/dock_side.dart';
import '../../../models/planimetry/angle.dart';
import '../../../models/planimetry/drag_point.dart';
import '../../../models/planimetry/line.dart';
import '../../../models/planimetry/polygon.dart';
import '../../../painters/drawable_shape.dart';
import '../../../painters/polygon_painter.dart';
import '../../../widgets/background_container.dart';
import '../../../widgets/display_expression.dart';
import '../../../widgets/infinite_drawer.dart';

class PolygonAnglesPage extends StatefulWidget {
  final String title;
  const PolygonAnglesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _PolygonAnglesPageState();
}

class _PolygonAnglesPageState extends State<PolygonAnglesPage> {
  DockSide dock = DockSide.leftTop;

  final List<DrawableShape<PolygonPainter>> _drawablesShapes = List.empty(growable: true);
  final originLine = Line(
      a: DragPoint(point: Offset(0.0, 0.0), enableDragging: true),
      b: DragPoint(point: Offset(4.0, 0.0), enableDragging: true));
  late int selectPolygonLines;
  bool _isPolygonInitialized = false;
  late Polygon polygon;
  late List<int> numPolygonLines = List.generate(10, (idx) => idx + 3);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectPolygonLines = numPolygonLines.first;
    changePolygonProperties(selectPolygonLines);
  }

  @override
  Widget build(BuildContext context) {
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
                // if (type == ShowAngleType.complementary) {
                //   final complementaryAngles = leadingAngle.getComplementaryAngles(angleType: AngleType.degrees);
                //   return DisplayExpression(
                //       context: context,
                //       expression: r"\alpha = " + complementaryAngles.first.toStringAsFixed(1) +
                //           r"^\circ, \beta = " + complementaryAngles.last.toStringAsFixed(1) + r"^\circ",
                //       scale: 1.5);
                // }
                // else if (type == ShowAngleType.supplementary) {
                //   final supplementaryAngles = leadingAngle.getSupplementaryAngle(angleType: AngleType.degrees);
                //   return DisplayExpression(
                //       context: context,
                //       expression: r"\alpha = " + supplementaryAngles.first.toStringAsFixed(1) +
                //           r"^\circ, \beta = " + supplementaryAngles.last.toStringAsFixed(1) + r"^\circ",
                //       scale: 1.5);
                // }
                return DisplayExpression(
                  context: context,
                  expression: r"\alpha = " + polygon.getSumAngles(selectPolygonLines, AngleType.degrees).toStringAsFixed(1) + r"^\circ",
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
                      initialSelection: numPolygonLines[0],
                      dropdownMenuEntries: List<DropdownMenuEntry<int>>.generate(
                        numPolygonLines.length, (index) => DropdownMenuEntry(
                          value: numPolygonLines[index],
                          label: numPolygonLines[index].toString(),
                          labelWidget: SizedBox(
                            width: dropdownWidth,
                            child: Text(numPolygonLines[index].toString(),
                              style: MathTheme.of(context).dropDownEntryLabelStyle))
                      ),
                    ),
                    onSelected: (newNumLines) {
                      setState(() {
                        if (newNumLines != null && newNumLines != selectPolygonLines) {
                          selectPolygonLines = newNumLines;
                          changePolygonProperties(selectPolygonLines);
                          changeDrawableShape(Colors.green);
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
                  oldShapes as DrawableShape<PolygonPainter>);
              if (index != -1) {
                final newShape = (oldShape as DrawableShape<PolygonPainter>).moveByPoint(point: originPoint, delta: targetPoint - originPoint,
                    tolerance: 0.25);
                _drawablesShapes[index] = newShape;
                if (polygon == oldShape.shape as Polygon) {
                  polygon = newShape.shape as Polygon;
                }
              }
            }
          });
        }
    );
  }

  DrawableShape<PolygonPainter> changeDrawableShape(Color color) {
    return DrawableShape<PolygonPainter>(
      shape: polygon,
      labelsSpans: [
        TextSpan(
          text: "α, ",
          style: TextStyle(color: Colors.green, fontSize: 28),
        ),
      ],
      createPainter:
          (
          Matrix4 canvasTransform,
          Size viewportSize,
          double widthUnitInPixels,
          double heightUnitInPixels,
          polygon,
          ) {
        return PolygonPainter(
            widthUnitInPixels,
            heightUnitInPixels,
            polygon,
            canvasTransform: canvasTransform,
            viewportSize: viewportSize,
            angleColor: color);
      },
    );
  }

  void changePolygonProperties(int numPolygonLines) {
    if (!_isPolygonInitialized || polygon.lines.length != numPolygonLines) {
      polygon = Polygon.fromLines(selectPolygonLines, originLine);
      _drawablesShapes.clear();
      _drawablesShapes.add(changeDrawableShape(Colors.green));
      _isPolygonInitialized = true;
    }
  }
}