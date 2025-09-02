import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/background_container.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';

class LogarithmsPage extends StatefulWidget{
  final String title;
  const LogarithmsPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _LogarithmsPageState();
}

class _LogarithmsPageState extends State<LogarithmsPage> {
  @override
  Widget build(BuildContext context) {
    final leftColScale = 1.6;
    final rightColScale = 1.3;

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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(0.7),
                1: FlexColumnWidth(0.3)
              },
              children: [
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "x = \log_{a} {b} \\Leftrightarrow a_x = b", scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: r'x = log_a a^x', scale: leftColScale),
                  DisplayExpression(context: context, expression: 'x \\in R, a \\not\\equiv 1', scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "b = a^{log_a b}", scale: leftColScale),
                  DisplayExpression(context: context, expression: "b > 0, a \\not\\equiv 1", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "0 = log_a a^0 = log_a 1", scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "1 = log_a a^1 = log_a a", scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  // This formula: r'.... \log_a 'frac{1}{a}...' do only work !!!
                  DisplayExpression(context: context, expression: r'-1 = log_a a^{-1} = log_a \frac{1}{a}', scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1, a \\not\\equiv 0", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "b^y = a^{y\log_a b}", scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "a = b^{log_b a} = a^{log_b a * log_a b}", scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1, b \\not\\equiv 1", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "1 = log_b a * log_a b", scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1, b \\not\\equiv 1", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "log_a uv = log_a u + log_a v", scale: leftColScale),
                  DisplayExpression(context: context, expression: "u > 0, v > 0", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "log_a uv = log_a u + log_a v", scale: leftColScale),
                  DisplayExpression(context: context, expression: "v >0, v > 0", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "log_a {u^z} = z\\log_a u", scale: leftColScale),
                  DisplayExpression(context: context, expression: "u > 0", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  // This formula: r'.... \log_a 'frac{1}{a}...' do only work !!!
                  DisplayExpression(context: context, expression: r'log_a \frac{u}{v} = log_a u - log_a v', scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1, v \\not\\equiv 0", scale: rightColScale),
                ]),
                tableRow(horizontalPadding: 2.0, verticalPadding: 1.0, cells: [
                  DisplayExpression(context: context, expression: "log_a u^{-1} = -log_a u", scale: leftColScale),
                  DisplayExpression(context: context, expression: "a \\not\\equiv 1", scale: rightColScale),
                ]),
              ]
            ),
          ),
        ),
      ),
    );
  }

  TableRow tableRow({required double horizontalPadding, required double verticalPadding, required List<Widget> cells}) {
    return TableRow(
      children: [
        for (var cell in cells)
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: cell,
            )
          )
      ]
    );
  }
}