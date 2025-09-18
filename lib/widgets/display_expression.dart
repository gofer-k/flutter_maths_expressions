import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// LaTeX format https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols
/// Equation editor https://www.codecogs.com/eqneditor/editor.php
/// https://editor.codecogs.com/docs/2-API.php
class DisplayExpression extends StatefulWidget {
  const DisplayExpression({super.key,
    required this.context,
    required this.expression,
    required this.scale,
    this.decoration,
    this.textStyle,
  });

  final BuildContext context;
  final String expression;
  final double scale;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;

  @override
  State<DisplayExpression> createState() => DisplayExpressionState();
}

class DisplayExpressionState extends State<DisplayExpression> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0), // Padding inside the container, around the text
      margin: const EdgeInsets.all(2.0),   // Margin outside the container
      decoration: widget.decoration,
      child: Math.tex(
        widget.expression,
        textStyle: (widget.textStyle != null) ? widget.textStyle : Theme.of(context).textTheme.bodyMedium,
        mathStyle: MathStyle.display, // Or .text, .script, .scriptScript
        textScaleFactor: widget.scale, // Adjust this factor as needed
        onErrorFallback: (FlutterMathException e) { // Good practice to have an error fallback
          return Flexible(child: Text(
            'Error rendering formula: ${e.message}',
              style: const TextStyle(color: Colors.red),
            )
          );
        },
      ),
    );
  }
}