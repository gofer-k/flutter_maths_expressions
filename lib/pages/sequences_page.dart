import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/popup_widget.dart';
import 'package:flutter_maths_expressions/widgets/shrinkable_list_Item.dart';

import '../Themes/math_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/background_container.dart';
import '../widgets/display_expression.dart';

class SequencesPage extends StatefulWidget {
  final String title;

  const SequencesPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _SequencesPageState();
}

class _SequencesPageState extends State<SequencesPage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> sequenceTypes = [
      PopupWidget(
        horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
        verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
        content: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"\text{Arithmetic seq.: }a_n = a_1+(n-1)\dot r",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: MathTheme.of(context).listItemDecoration,
            expression:
            r"n \in N \vee a,r \in R",
            scale: MathTheme.of(context).expressionScale?? 1.0,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
        verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
        content: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"\text{Geometric seq: }a_n = a_1 \dot q^{n-1}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: MathTheme.of(context).listItemDecoration,
            expression:
            r"n \in N \vee a, q \in R",
            scale: MathTheme.of(context).expressionScale?? 1.0,
          ),
        ),
      ),
    ];

    final List<Widget> basicExamples = [
      PopupWidget(
        horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
        verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
        content: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"1+2+ \dots + n = \frac{n(n+1)}{2}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: MathTheme.of(context).listItemDecoration,
            expression:
            r"n > 0",
            scale: MathTheme.of(context).expressionScale?? 1.0,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
        verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
        content: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"\frac{1}{a \dot n} + \dots + \frac{1}{a\dot n} = 2",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: MathTheme.of(context).listItemDecoration,
            expression:
            r"n \in N, k \in R, a = 1",
            scale: MathTheme.of(context).expressionScale?? 1.0,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
        verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
        content: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"a_n = \binom{n}{2} = \frac{n(n-1)}{2}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: MathTheme.of(context).listItemDecoration,
            expression:
            r"n > 0",
            scale: MathTheme.of(context).expressionScale?? 1.0,
          ),
        ),
      ),
      PopupWidget(
        horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
        verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
        content: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"\binom{n}{k} = \frac{n(n-1)\dots(n-k+1)}{k!}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: MathTheme.of(context).listItemDecoration,
            expression:
            r"n > 0",
            scale: MathTheme.of(context).expressionScale?? 1.0,
          ),
        ),
      ),
    ];

    final l10n = AppLocalizations.of(context)!;

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
            horizontal: MathTheme.of(context).horizontalPadding?? 0.0,
            vertical: MathTheme.of(context).verticalPadding?? 0.0,
          ),
          children: [
            ShrinkableListItem(
              title:  l10n.sequenceTypes,
              details: sequenceTypes,
              titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
            ),
            ShrinkableListItem(
              title:  l10n.sequenceExamples,
              details: basicExamples,
              titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
