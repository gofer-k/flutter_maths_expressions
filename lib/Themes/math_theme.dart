import 'dart:ui';

import 'package:flutter/material.dart';

class MathTheme extends ThemeExtension<MathTheme> {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? expressionScale;
  final TextStyle? shrinkableTitleTextStyle;
  final BoxDecoration? listItemDecoration;

  // Optional: Add a static method to easily access the extension from context
  static MathTheme of(BuildContext context) {
    return Theme.of(context).extension<MathTheme>()!;
  }

  const MathTheme({
    this.horizontalPadding,
    this.verticalPadding,
    this.expressionScale,
    this.shrinkableTitleTextStyle,
    this.listItemDecoration,});

  @override
  MathTheme copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? expressionScale,
    TextStyle? shrinkableTitleTextStyle,
    BoxDecoration? listItemDecoration}) {
    return MathTheme(horizontalPadding: horizontalPadding, verticalPadding: verticalPadding, expressionScale: expressionScale, shrinkableTitleTextStyle: shrinkableTitleTextStyle, listItemDecoration: listItemDecoration);
  }

  @override
  ThemeExtension<MathTheme> lerp(ThemeExtension<MathTheme>? other, double t) {
    if (other is! MathTheme) {
      return this;
    }
    return MathTheme(
      horizontalPadding: lerpDouble(horizontalPadding, other.horizontalPadding, t),
      shrinkableTitleTextStyle: TextStyle.lerp(shrinkableTitleTextStyle, other.shrinkableTitleTextStyle, t),
    );
  }

}