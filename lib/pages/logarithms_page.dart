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
        body: Column(
          children: [
            DisplayExpression(context: context, expression: "x = log_a b \\Leftrightarrow a_x = b:  a \\neg 1", scale: 2.0),
            DisplayExpression(context: context, expression: "x = log_a a^x: x \\in R", scale: 2.0),
            DisplayExpression(context: context, expression: "b = a^{log_a b}: b > 0", scale: 2.0),
            DisplayExpression(context: context, expression: "0 = log_a a^0 = log_a 1", scale: 2.0),
            DisplayExpression(context: context, expression: "1 = log_a a^1 = log_a a", scale: 2.0),
            DisplayExpression(context: context, expression: "-1 = log_a a^{-1} = log_a \frac{1}{a}: a \\neq 0", scale: 2.0),
          ],
        ),
        ),
    );
  }
}