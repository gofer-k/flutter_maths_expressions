import 'dart:ui';

import 'package:flutter/material.dart';

class MathTheme extends ThemeExtension<MathTheme> {
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? expressionScale;
  final TextStyle? shrinkableTitleTextStyle;
  final BoxDecoration? listItemDecoration;
  final TextStyle? headerTextStyle;
  final TextStyle? dropDownLabelStyle;
  final TextStyle? dropDownEntryLabelStyle;
  final MenuStyle? dropDownMenuStyle;

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
    this.headerTextStyle,
    this.dropDownLabelStyle,
    this.dropDownEntryLabelStyle,
    this.dropDownMenuStyle});

  @override
  MathTheme copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? expressionScale,
    TextStyle? shrinkableTitleTextStyle,
    BoxDecoration? listItemDecoration,
    TextStyle? headerTextStyle,
    TextStyle? dropDownLabelStyle,
    TextStyle? dropDownEntryLabelStyle,
    MenuStyle? dropDownMenuStyle}) {
    return MathTheme(horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        expressionScale: expressionScale,
        shrinkableTitleTextStyle: shrinkableTitleTextStyle,
        listItemDecoration: listItemDecoration,
        headerTextStyle: headerTextStyle,
        dropDownMenuStyle: dropDownMenuStyle,
        dropDownEntryLabelStyle: dropDownEntryLabelStyle);
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
      dropDownMenuStyle: MenuStyle.lerp(dropDownMenuStyle, other.dropDownMenuStyle, t),
      dropDownLabelStyle: TextStyle.lerp(dropDownLabelStyle, other.dropDownLabelStyle, t),
      dropDownEntryLabelStyle: TextStyle.lerp(dropDownEntryLabelStyle, other.dropDownEntryLabelStyle, t),
    );
  }

}