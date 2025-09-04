import 'package:flutter/material.dart';

import '../widgets/background_container.dart';

class TrigonometryPage extends StatefulWidget {
  final String title;
  const TrigonometryPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TrigonometryPageState();
}

class _TrigonometryPageState extends State<TrigonometryPage> {
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
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: ListView(
              children: [
                // listItem(
                //   horizontalPadding: horizontalPaddingItem,
                //   verticalPadding: verticalPaddingItem,
                //   content:
                //   DisplayExpression(
                //       context: context,
                //       decoration: listItemDecoration,
                //       expression: "x = log_{a} {b} \\Leftrightarrow a_x = b",
                //       scale: leftColScale),
                //   dialogContent:
                //   DisplayExpression(
                //       context: context,
                //       decoration: listItemDecoration,
                //       expression: "a \\not\\equiv 1",
                //       scale: rightColScale),
                // ),
              ],
            )
        ),
      ),
    );
  }
}