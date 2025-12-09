import 'package:flutter/material.dart';
import '../../../Themes/math_theme.dart';
import '../../../l10n/app_localizations.dart';
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
import '../../../widgets/shrinkable_list_Item.dart';

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
      b: DragPoint(point: Offset(3.0, 0.0), enableDragging: true));
  late int selectPolygonLines;
  bool _isPolygonInitialized = false;
  late Polygon polygon;
  late List<int> numPolygonLines = List.generate(10, (idx) => idx + 3);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectPolygonLines = numPolygonLines.first;
    changePolygonProperties(selectPolygonLines, Colors.redAccent);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              DisplayExpression(context: context,
                expression: r"\text{Sum polygon angles: } S_a = (n - 2) \cdot 180^\circ",
                scale: 1.5,
              ),
              DisplayExpression(context: context,
                expression: r"S_a = ("
                  "${polygon.lines.length}"r" - 2) \cdot 180^\circ = "
                    "${polygon.getSumAngles(polygon.lines.length, AngleType.degrees).toStringAsFixed(0)}"r"^\circ",
                scale: 1.5,
              ),
              Builder(builder: (context) {
                final labels = polygon.getVertexLabels();
                return ShrinkableListItem(title: l10n.parameters,
                  details: [
                    for (int idx = 0; idx < polygon.lines.length; ++idx) ...[
                      DisplayExpression(context: context,
                        expression: r"\sphericalangle """
                        "${labels[idx]} = "
                        "${polygon.getInternalAngle(vertexIdx: idx, angleType: AngleType.degrees).toStringAsFixed(1)}",
                        scale: 1.5,
                      ),
                    ],
                  ],
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
                          changePolygonProperties(selectPolygonLines, Colors.redAccent);
                          changeDrawableShape(Colors.redAccent);
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
        onDragShape: (oldShapes, originPoint, targetPoint) {
          if (oldShapes.isEmpty && _drawablesShapes.isEmpty) return;
          setState(() {
            for (final oldShape in oldShapes) {
              final newShape = (oldShape as DrawableShape<PolygonPainter>).moveByPoint(point: originPoint, delta: targetPoint - originPoint,
                tolerance: 0.25);
              if (polygon == oldShape.shape as Polygon) {
                polygon = newShape.shape as Polygon;
                _drawablesShapes.clear();
                _drawablesShapes.add(newShape);
                changeDrawableShape(Colors.redAccent);
              }
            }
          });
        }
    );
  }

  DrawableShape<PolygonPainter> changeDrawableShape(Color color) {
    return DrawableShape<PolygonPainter>(
      shape: polygon,
      labelsSpans: [],
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
            [polygon],
            canvasTransform: canvasTransform,
            viewportSize: viewportSize,
            angleColor: color);
      },
    );
  }

  void changePolygonProperties(int numPolygonLines, Color angleColor) {
    if (!_isPolygonInitialized || polygon.lines.length != numPolygonLines) {
      polygon = Polygon.fromLines(selectPolygonLines, originLine);
      _drawablesShapes.clear();
      _drawablesShapes.add(changeDrawableShape(angleColor));
      _isPolygonInitialized = true;
    }
  }
}