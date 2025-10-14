import 'package:flutter/cupertino.dart';
import 'package:flutter_maths_expressions/models/planimetry/base_shape.dart';

abstract class FigurePainter<T> extends CustomPainter {
  late final Matrix4 canvasTransform;
  late final Size viewportSize;
  late final double? unitInPixels;
  late final BaseShape? shape;

  FigurePainter(this.unitInPixels, this.shape, {required this.canvasTransform, required this.viewportSize});
}