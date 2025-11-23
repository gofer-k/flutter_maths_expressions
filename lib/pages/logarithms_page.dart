import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/Themes/math_theme.dart';
import 'package:flutter_maths_expressions/widgets/background_container.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';

import '../widgets/popup_widget.dart';

class LogarithmsPage extends StatefulWidget{
  final String title;
  const LogarithmsPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _LogarithmsPageState();
}

class _LogarithmsPageState extends State<LogarithmsPage> {
  @override
  Widget build(BuildContext context) {
    final leftColScale = 2.0;
    final rightColScale = 2.0;
    final horizontalPaddingItem = 4.0;
    final verticalPaddingItem = 4.0;
    // final listItemDecoration = BoxDecoration(
    //   color: Colors.grey.shade300, // Background color of the "card"
    //   border: Border.all(
    //     color: Colors.grey.shade400, // Color of the outline
    //     width: 1.0,                // Thickness of the outline
    //     ),
    //   borderRadius: BorderRadius.circular(8.0), // Rounded corners for the card-like look
    //   boxShadow: [ // Optional: Add shadow similar to a Card
    //     BoxShadow(
    //       color: Colors.grey.withAlpha(128),
    //       spreadRadius: 2,
    //       blurRadius: 5,
    //       offset: Offset(0, 3), // changes position of shadow
    //     ),
    //   ],
    // );

    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
      endColor: Colors.grey.shade800,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
              widget.title, style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          child: ListView(
            children: [
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                  DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "x = log_{a} {b} \\Leftrightarrow a_x = b",
                    scale: leftColScale),
                popupDialog:
                  DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: r'x = log_a a^x',
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: 'x \\in R, a \\not\\equiv 1',
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "b = a^{log_a b}",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "b > 0, a \\not\\equiv 1",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "0 = log_a a^0 = log_a 1",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "1 = log_a a^1 = log_a a",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    // This formula: r'.... \log_a 'frac{1}{a}...' do only work !!!
                    expression: r'-1 = log_a a^{-1} = log_a \frac{1}{a}',
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1, a \\not\\equiv 0",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    // This formula: r'.... \log_a 'frac{1}{a}...' do only work !!!
                    expression: r"lob_a x = \frac{log_b x}{log_b a}",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    // This formula: r'.... \log_a 'frac{1}{a}...' do only work !!!
                    expression: "b^y = a^{y log_a b}",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a = b^{log_b a} = a^{log_b a * log_a b}",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1, b \\not\\equiv 1",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "1 = log_b a * log_a b",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1, b \\not\\equiv 1",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "log_a uv = log_a u + log_a v",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "u > 0, v > 0",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "log_a uv = log_a u + log_a v",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "v >0, v > 0",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "log_a {u^z} = z\\log_a u",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "u > 0",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    // This formula: r'.... \log_a 'frac{1}{a}...' do only work !!!
                    expression: r'log_a \frac{u}{v} = log_a u - log_a v',
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1, v \\not\\equiv 0",
                    scale: rightColScale),
              ),
              PopupWidget(
                horizontalPadding: horizontalPaddingItem,
                verticalPadding: verticalPaddingItem,
                content:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "log_a u^{-1} = -log_a u",
                    scale: leftColScale),
                popupDialog:
                DisplayExpression(
                    context: context,
                    decoration: MathTheme.of(context).listItemDecoration,
                    expression: "a \\not\\equiv 1",
                    scale: rightColScale),
              ),
            ],
          )
        ),
      ),
    );
  }
}