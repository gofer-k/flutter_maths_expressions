import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/background_container.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';

import '../widgets/popup_widget.dart';
import '../widgets/shrinkable_list_Item.dart';

class LimitsPage extends StatefulWidget{
  final String title;
  const LimitsPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _LimitsPagePageState();
}

class _LimitsPagePageState extends State<LimitsPage> {
  @override
  Widget build(BuildContext context) {
    final leftColScale = 2.0;
    final horizontalPaddingItem = 2.0;
    final verticalPaddingItem = 2.0;
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
    final List<Widget> factors = [
      DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: "\lim_{x \to x_0} f(x)} = f, \lim_{x \to x_0} g(x) = g",
          scale: leftColScale),
    ];
    final List<Widget> theorems = [
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content:  FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to x_0} [f(x) + g(x)] = \lim_{x \to x_0} f(x) + \lim_{x \to x_0} g(x) = f + g",
            scale: leftColScale),
        )
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} [f(x) - g(x)] = \lim_{x \to x_0} f(x) - \lim_{x \to x_0} g(x) = f - g",
          scale: leftColScale),
        )
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to x_0} [f(x) \cdot g(x)] = \lim_{x \to x_0} f(x) \cdot \lim_{x \to x_0} g(x) = f \cdot g",
            scale: leftColScale),
        )
      ),
      PopupWidget(
          horizontalPadding: horizontalPaddingItem,
          verticalPadding: verticalPaddingItem,
          content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to x_0} \frac{f(x)}{g(x)} = \frac{f}{g}",
            scale: leftColScale),
          )
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
              widget.title, style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          children: [
            ShrinkableListItem(title: "Theorems on the limits of functions", details: theorems,),
          ],
        )
      ),
    );
  }
}