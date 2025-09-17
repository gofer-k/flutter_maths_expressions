import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/popup_widget.dart';

import '../widgets/background_container.dart';
import '../widgets/display_expression.dart';

class TrigonometryPage extends StatefulWidget {
  final String title;
  const TrigonometryPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TrigonometryPageState();
}

class _TrigonometryPageState extends State<TrigonometryPage> {
  @override
  Widget build(BuildContext context) {
    final leftColScale = 2.0;
    final rightColScale = 2.0;
    final horizontalPaddingItem = 4.0;
    final verticalPaddingItem = 4.0;
    final listItemDecoration = BoxDecoration(
      color: Colors.grey.shade300, // Background color of the "card"
      border: Border.all(
        color: Colors.grey.shade400, // Color of the outline
        width: 1.0,                // Thickness of the outline
      ),
      borderRadius: BorderRadius.circular(8.0), // Rounded corners for the card-like look
      boxShadow: [ // Optional: Add shadow similar to a Card
        BoxShadow(
          color: Colors.grey.withAlpha(128),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );

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
                  content: DisplayExpression(
                    context: context,
                    decoration: listItemDecoration,
                    expression: r"y = \sin(x)",
                    scale: leftColScale),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression:
                      r"y \in [ -1, 1 ], x \in [ -k*\pi, k*\pi ], k \in N",
                      scale: rightColScale),
                    ),
                ),
                PopupWidget(
                  horizontalPadding: horizontalPaddingItem,
                  verticalPadding: verticalPaddingItem,
                  content: DisplayExpression(
                    context: context,
                    decoration: listItemDecoration,
                    expression: r"y = \cos(x)",
                    scale: leftColScale),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression: r"y \in [ -1, 1 ], x \in [ -k*\pi, k*\pi ], k \in N",
                      scale: rightColScale),
                  ),
                ),
                PopupWidget(
                  horizontalPadding: horizontalPaddingItem,
                  verticalPadding: verticalPaddingItem,
                  content: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression: r"y = \tan(x) = \frac{\sin(x)}{\cos(x)}",
                      scale: leftColScale),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                        context: context,
                        decoration: listItemDecoration,
                        expression: r"y \in [ -\infty, \infty ], x \in ( -0.5*k*\pi, 0.5*k*\pi ), k \in N",
                        scale: rightColScale),
                  ),
                ),
                PopupWidget(
                  horizontalPadding: horizontalPaddingItem,
                  verticalPadding: verticalPaddingItem,
                  content: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression: r"y = \ctg(x) = \frac{\cos(x)}{\sin(x)}",
                      scale: leftColScale),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                        context: context,
                        decoration: listItemDecoration,
                        expression: r"y \in [ \infty, -\infty ], x \in ( -0.5k*\pi, 0.5*k*\pi ), k \in N",
                        scale: rightColScale),
                  ),
                ),
                PopupWidget(
                  horizontalPadding: horizontalPaddingItem,
                  verticalPadding: verticalPaddingItem,
                  content: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression: r"y = \arcsin(x) \leftrightarrow x = \sin(y)",
                      scale: leftColScale),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                        context: context,
                        decoration: listItemDecoration,
                        expression: r"x \in ( -0.5*\pi, 0.5*\pi ), y \in [ \infty, -\infty ]",
                        scale: rightColScale),
                  ),
                ),
                PopupWidget(
                  horizontalPadding: horizontalPaddingItem,
                  verticalPadding: verticalPaddingItem,
                  content: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression: r"y = \arccos(x) \leftrightarrow x = \cos(y)",
                      scale: leftColScale),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                        context: context,
                        decoration: listItemDecoration,
                        expression: r"x \in ( -0.5*\pi, 0.5*\pi ), y \in [ \infty, -\infty ]",
                        scale: rightColScale),
                  ),
                ),
                PopupWidget(
                  horizontalPadding: horizontalPaddingItem,
                  verticalPadding: verticalPaddingItem,
                  content: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression: r"y = \arctan(x) \leftrightarrow x = \tan(y)",
                      scale: leftColScale),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                        context: context,
                        decoration: listItemDecoration,
                        expression: r"x \in [ \infty, -\infty ], y \in ( -0.5*\pi, 0.5*\pi )",
                        scale: rightColScale),
                  ),
                ),
                PopupWidget(
                  horizontalPadding: horizontalPaddingItem,
                  verticalPadding: verticalPaddingItem,
                  content: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression: r"y = \arcctg(x) \leftrightarrow x = \ctg(y)",
                      scale: leftColScale),
                  ),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                        context: context,
                        decoration: listItemDecoration,
                        expression: r"x \in [ \infty, -\infty ], y \in ( \pi, 0 )",
                        scale: rightColScale),
                  ),
                ),
                // TODO: Add more functions
                Divider(),
                // Expressions
                DisplayExpression(
                  context: context,
                  decoration: listItemDecoration,
                  expression: r"\sin^2 x + \cos^2 x = 1",
                  scale: leftColScale),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: DisplayExpression(
                    context: context,
                    decoration: listItemDecoration,
                      expression: r"\sin^2 x = 1 - \cos^2 x =\frac{\tan^2 x}{1 + \tan^2 x} = \frac{1}{1 + \ctg^2 x}",
                    scale: rightColScale),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: DisplayExpression(
                      context: context,
                      decoration: listItemDecoration,
                      expression: r"\cos^2 x = 1 - \sin^2 x = \frac{1}{1 + \tg^2 x} = \frac{\ctg^2 x}{1 + \ctg^2 x}",
                      scale: rightColScale),
                ),
                DisplayExpression(
                    context: context,
                    decoration: listItemDecoration,
                    expression: r"\sin^2 \frac{1}{2}x = \frac{1 - \cos x}{2}",
                    scale: rightColScale),
                DisplayExpression(
                    context: context,
                    decoration: listItemDecoration,
                    expression: r"\cos^2 \frac{1}{2}x = \frac{1 + \cos x}{2}",
                    scale: rightColScale),
                DisplayExpression(
                    context: context,
                    decoration: listItemDecoration,
                    expression: r"\tan^2 \frac{1}{2}x = \frac{1 - \cos x}{1 + \cos x}",
                    scale: rightColScale),
                DisplayExpression(
                    context: context,
                    decoration: listItemDecoration,
                    expression: r"\ctg^2 \frac{1}{2}x = \frac{1 + \cos x}{1 - \cos x}",
                    scale: rightColScale),
                // TODO: Add more expressions
              ],
            )
        ),
      ),
    );
  }
}