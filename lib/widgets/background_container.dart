import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackgroundContainer extends StatefulWidget {
  final Widget child;
  final Color beginColor;
  final Color? endColor;

  const BackgroundContainer({super.key, required this.child, required this.beginColor, this.endColor});

  @override
  State<StatefulWidget> createState() => _BackgroundContainerState();
}

class _BackgroundContainerState extends State<BackgroundContainer> {
  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
    if (widget.endColor != null) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.beginColor, widget.endColor!], // Use widget.beginColor and widget.endColor
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else {
      // Use a solid color if endColor is null
      decoration = BoxDecoration(
        color: widget.beginColor, // Use widget.beginColor
      );
    }

    return Container(
      decoration: decoration,
        child:  widget.child,
    );
  }
}