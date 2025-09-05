import 'package:flutter/cupertino.dart';

abstract class FigurePainter extends CustomPainter {
  final Matrix4 canvasTransform;
  final Size viewportSize;

  const FigurePainter(this.canvasTransform, this.viewportSize);
}