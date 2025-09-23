import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/popup_widget.dart';
import 'package:flutter_maths_expressions/widgets/shrinkable_list_Item.dart';

import '../widgets/background_container.dart';
import '../widgets/display_expression.dart';
import '../widgets/shrinkable_table.dart';

class TrigonometryPage extends StatefulWidget {
  final String title;

  const TrigonometryPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TrigonometryPageState();
}

class _TrigonometryPageState extends State<TrigonometryPage> {
  @override
  Widget build(BuildContext context) {
    final expressionScale = 1.8;
    final tableCellScale = 1.5;
    final horizontalPaddingItem = 2.0;
    final verticalPaddingItem = 2.0;
    final listItemDecoration = BoxDecoration(
      color: Colors.grey.shade300,
      // Background color of the "card"
      border: Border.all(
        color: Colors.grey.shade400, // Color of the outline
        width: 1.0, // Thickness of the outline
      ),
      borderRadius: BorderRadius.circular(8.0),
      // Rounded corners for the card-like look
      boxShadow: [
        // Optional: Add shadow similar to a Card
        BoxShadow(
          color: Colors.grey.withAlpha(128),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
    final tableItemDecoration = BoxDecoration(color: Colors.transparent);
    final tableItemTextStyle = TextStyle(color: Colors.white70);
    final tableHeaderTextStyle = TextStyle(
      color: Colors.lightBlueAccent,
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
    );
    final shrinkableTitleTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: Theme.of(context).textTheme.titleMedium?.fontWeight,
      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
    );

    final List<Widget> basicExpressions = [
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"y = \sin(x)",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"y \in [ -1, 1 ], x \in [ -k \cdot \pi, k \cdot \pi ], k \in N",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"y = \cos(x)",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"y \in [ -1, 1 ], x \in [ -k \cdot \pi, k \cdot \pi ], k \in N",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"y = \tan(x) = \frac{\sin(x)}{\cos(x)}",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"y \in [ -\infty, \infty ], x \in ( -0.5 \cdot k \cdot \pi, 0.5 \cdot k \cdot \pi ), k \in N",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"y = \ctg(x) = \frac{\cos(x)}{\sin(x)}",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"y \in [ \infty, -\infty ], x \in ( -0.5 \cdot k \cdot \pi, 0.5 \cdot k \cdot \pi ), k \in N",
            scale: expressionScale,
          ),
        ),
      ),
    ];
    final List<Widget> arcExpressions = [
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"y = \arcsin(x) \leftrightarrow x = \sin(y)",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"x \in ( -0.5 \cdot \pi, 0.5 \cdot \pi ), y \in [ \infty, -\infty ]",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"y = \arccos(x) \leftrightarrow x = \cos(y)",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"x \in ( -0.5 \cdot \pi, 0.5 \cdot \pi ), y \in [ \infty, -\infty ]",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"y = \arctan(x) \leftrightarrow x = \tan(y)",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"x \in [ \infty, -\infty ], y \in ( -0.5 \cdot \pi, 0.5 \cdot \pi )",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"y = \arcctg(x) \leftrightarrow x = \ctg(y)",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"x \in [ \infty, -\infty ], y \in ( \pi, 0 )",
            scale: expressionScale,
          ),
        ),
      ),
    ];
    final List<Widget> parityFeatures = [
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\sin(-x) = -\sin x",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"y \in [ -1, 1 ], x \in [ -k \cdot \pi, k \cdot \pi ], k \in N",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\cos(-x) = \cos x",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"y \in [ -1, 1 ], x \in [ -k \cdot \pi, k \cdot \pi ], k \in N",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\tan(-x) = -\tan x",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"y \in [ -\infty, \infty ], x \in ( -0.5 \cdot k \cdot \pi, 0.5 \cdot k \cdot \pi ), k \in N",
            scale: expressionScale,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\ctg(-x) = -\ctg x",
          scale: expressionScale,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
                r"y \in [ \infty, -\infty ], x \in ( -0.5 \cdot k \cdot \pi, 0.5 \cdot k \cdot \pi ), k \in N",
            scale: expressionScale,
          ),
        ),
      ),
    ];
    final List<Widget> equations = [
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\sin^2 x + \cos^2 x = 1",
        scale: expressionScale,
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\sin(x + y) = \sin x \cdot \cos y + \cos x \cdot \sin y",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\sin(x - y) = \sin x \cdot \cos y - \cos x \cdot \sin y",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\cos(x \pm y) = \cos x \cdot \cos y \pm \sin x \cdot \sin y",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\tan(x \pm y) = \frac{\tan x \pm \tan y}{1 \mp \tan x \cdot \tan y}",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\ctg (x \pm y) = \frac{\ctg x \cdot \ctg y \mp 1}{\ctg y \pm \ctg x}",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\sin x \pm \sin y = 2 \sin \frac{x \pm y}{2} \cdot \cos \frac{x \mp y}{2}",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\cos x \pm \cos y = \pm 2 \cos \frac{x + y}{2} \cdot \cos \frac{x - y}{2}",
          scale: expressionScale,
        ),
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\sin 2x = 2 \sin x \cdot \cos x",
        scale: expressionScale,
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\cos 2x = \cos^2 x - \sin^2 x",
        scale: expressionScale,
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\cos 2x = 2\cos^2 x - 1 = 1 - 2\sin^2 x",
          scale: expressionScale,
        ),
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\sin 0.5x = \sqrt{\frac{1 - \cos x}{2}}",
        scale: expressionScale,
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\cos 0.5x = \sqrt{\frac{1 + \cos x}{2}}",
        scale: expressionScale,
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\sin x \cdot \sin y = \frac{\cos (x - y) - \cos (x + y)}{2}",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\cos x \cdot \cos y = \frac{\cos (x - y) + \cos (x + y)}{2}",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\sin x \cdot \cos y = \frac{\sin (x - y) + \sin (x + y)}{2}",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\sin^2 x = 1 - \cos^2 x =\frac{\tan^2 x}{1 + \tan^2 x} = \frac{1}{1 + \ctg^2 x}",
          scale: expressionScale,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression:
              r"\cos^2 x = 1 - \sin^2 x = \frac{1}{1 + \tg^2 x} = \frac{\ctg^2 x}{1 + \ctg^2 x}",
          scale: expressionScale,
        ),
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\tan^2 \frac{1}{2}x = \frac{1 - \cos x}{1 + \cos x}",
        scale: expressionScale,
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\ctg^2 \frac{1}{2}x = \frac{1 + \cos x}{1 - \cos x}",
        scale: expressionScale,
      ),
    ];
    final List<Widget> periodicity = [
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\sin(x + 2k\pi) = \sin x",
        scale: expressionScale,
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\cos(x + 2k\pi) = \cos x",
        scale: expressionScale,
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\tan(x + 2k\pi) = \tan x",
        scale: expressionScale,
      ),
      DisplayExpression(
        context: context,
        decoration: listItemDecoration,
        expression: r"\ctg(x + 2k\pi) = \ctg x",
        scale: expressionScale,
      ),
    ];
    final List<List<Widget>> tableTrigonometricValues = [
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"rad",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"0",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\pi}{6}",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\pi}{4}",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\pi}{3}",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\pi}{2}",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\pi",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\sin",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"0",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{1}{2}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\sqrt{2}}{2}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\sqrt{3}}{2}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"1",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"0",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\cos",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"1",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\sqrt{3}}{2}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\sqrt{2}}{2}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{1}{2}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"0",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-1",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\tan",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"0",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\sqrt{3}}{3}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"1",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\sqrt{3}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\infty",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"0",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\ctg",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\infty",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\sqrt{3}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"1",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\sqrt{3}}{3}",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"0",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\infty",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
    ];
    final List<List<Widget>> tableReducedExpressions = [
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\sin \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\cos \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\tan \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\ctg \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\pi}{2} - \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\cos",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\sin",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\ctg",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\tan",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{\pi}{2} + \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\cos",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\sin",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\ctg",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\tan",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\pi - \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\sin",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\cos",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\tan",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\ctg",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\pi + \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\sin",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\cos",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\tan",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\ctg",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{3\pi}{2} - \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\cos",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\sin",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\ctg",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\tan",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\frac{3\pi}{2} + \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\cos",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\sin",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\ctg",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\tan",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
      [
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"2\pi - \alpha",
          scale: tableCellScale,
          textStyle: tableHeaderTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\sin",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"\cos",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\tan",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
        DisplayExpression(
          context: context,
          decoration: tableItemDecoration,
          expression: r"-\ctg",
          scale: tableCellScale,
          textStyle: tableItemTextStyle,
        ),
      ],
    ];

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
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPaddingItem,
            vertical: verticalPaddingItem,
          ),
          children: [
            ShrinkableListItem(
              title: "Basic functions",
              details: basicExpressions,
              titleStyle: shrinkableTitleTextStyle,
            ),
            ShrinkableListItem(
              title: "Reverses of basic functions",
              details: arcExpressions,
              titleStyle: shrinkableTitleTextStyle,
            ),
            ShrinkableListItem(
              title: "Parity features",
              details: parityFeatures,
              titleStyle: shrinkableTitleTextStyle,
            ),
            ShrinkableListItem(
              title: "Periodic features",
              details: periodicity,
              titleStyle: shrinkableTitleTextStyle,
            ),
            ShrinkableListItem(
              title: "Functional equations",
              details: equations,
              titleStyle: shrinkableTitleTextStyle,
            ),
            ShrinkableTable(
              title: "Trigonometric values",
              contents: tableTrigonometricValues,
              titleStyle: shrinkableTitleTextStyle,
            ),
            ShrinkableTable(
              title: "Reduced expressions",
              contents: tableReducedExpressions,
              titleStyle: shrinkableTitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
