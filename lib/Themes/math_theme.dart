import 'dart:ui';

import 'package:flutter/material.dart';

class MathTheme extends ThemeExtension<MathTheme> {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? expressionScale;
  final TextStyle? shrinkableTitleTextStyle;
  final BoxDecoration? listItemDecoration;
  final TextStyle? headerTextStyle;

  // Optional: Add a static method to easily access the extension from context
  static MathTheme of(BuildContext context) {
    return Theme.of(context).extension<MathTheme>()!;
  }

  const MathTheme({
    this.horizontalPadding,
    this.verticalPadding,
    this.expressionScale,
    this.shrinkableTitleTextStyle,
    this.listItemDecoration,
    this.headerTextStyle,});

  @override
  MathTheme copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? expressionScale,
    TextStyle? shrinkableTitleTextStyle,
    BoxDecoration? listItemDecoration,
    TextStyle? headerTextStyle}) {
    return MathTheme(horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        expressionScale: expressionScale,
        shrinkableTitleTextStyle: shrinkableTitleTextStyle,
        listItemDecoration: listItemDecoration,
        headerTextStyle: headerTextStyle,
    );
  }

  @override
  ThemeExtension<MathTheme> lerp(ThemeExtension<MathTheme>? other, double t) {
    if (other is! MathTheme) {
      return this;
    }
    return MathTheme(
      horizontalPadding: lerpDouble(horizontalPadding, other.horizontalPadding, t),
      shrinkableTitleTextStyle: TextStyle.lerp(shrinkableTitleTextStyle, other.shrinkableTitleTextStyle, t),
      headerTextStyle: TextStyle.lerp(headerTextStyle, other.headerTextStyle, t),
    );
  }

}