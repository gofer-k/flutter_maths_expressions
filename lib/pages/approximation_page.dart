import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/background_container.dart';

import '../Themes/math_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/display_expression.dart';
import '../widgets/popup_widget.dart';
import '../widgets/shrinkable_list_Item.dart';

class ApproximationPage extends StatefulWidget {
  final String title;

  const ApproximationPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _ApproximationPageState();
}

class _ApproximationPageState extends State<ApproximationPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> approximations = [
      Column(
        children: [
          Text(
            style: MathTheme.of(context).headerTextStyle?? Theme.of(context).textTheme.headlineMedium,
            l10n.approx_lagrange_theorem),
          PopupWidget(
            horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
            verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
            content: DisplayExpression(
              context: context,
              decoration: MathTheme.of(context).listItemDecoration,
              expression: r"f'(\xi) = \frac{f(b) - (f(a)}{b - a}",
              scale: MathTheme.of(context).expressionScale?? 1.0,
            ),
            popupDialog: FittedBox(
              fit: BoxFit.fitWidth,
              child: DisplayExpression(
                context: context,
                decoration: MathTheme.of(context).listItemDecoration,
                expression:
                r"\xi \in (a, b), f'(\xi)=0 \implies f(b) = f(a)",
                scale: MathTheme.of(context).expressionScale?? 1.0,
              ),
            ),
          ),
        ]
      ),
      Column(
          children: [
            Text(
                style: MathTheme.of(context).headerTextStyle?? Theme.of(context).textTheme.headlineMedium,
                l10n.approx_maclaurin_series),
            PopupWidget(
              horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
              verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
              content: FittedBox(
                fit: BoxFit.fitWidth,
                child: Column(
                  children: [
                    DisplayExpression(
                      context: context,
                      decoration: MathTheme.of(context).listItemDecoration,
                      expression: r"f'(0) = f(0) + \frac{f'(0)}{1!}\dot x + \frac{f''(0)}{2!} \dot x^2 + \dots + \frac{f^{(n-1)}(0)}{(n-1)!} \dot x^(n-1) + R_n",
                      scale: MathTheme.of(context).expressionScale?? 1.0,
                    ),
                    DisplayExpression(
                      context: context,
                      decoration: MathTheme.of(context).listItemDecoration,
                      expression: r"R_n = \frac{x^n}{n!}\dot f^{n}(\xi), \xi = \theta \dot x, \theta in (0,1) ",
                      scale: MathTheme.of(context).expressionScale?? 1.0,
                    ),
                  ]
                )
              ),
              popupDialog: FittedBox(
                fit: BoxFit.fitWidth,
                child: DisplayExpression(
                  context: context,
                  decoration: MathTheme.of(context).listItemDecoration,
                  expression:
                  r"\forall f^{n}(0)\text{ is differentiable}, n \in N",
                  scale: MathTheme.of(context).expressionScale?? 1.0,
                ),
              ),
            ),
          ]
      ),
      Column(
          children: [
            Text(
                style: MathTheme.of(context).headerTextStyle?? Theme.of(context).textTheme.headlineMedium,
                l10n.approx_taylor_series),
            PopupWidget(
              horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
              verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
              content: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Column(
                      children: [
                        DisplayExpression(
                          context: context,
                          decoration: MathTheme.of(context).listItemDecoration,
                          expression: r"f'(a) = f(a) + \frac{f'(a)}{1!}\dot (x-a) + \frac{f''(a)}{2!} \dot (x-a)^2 + \dots + \frac{f^{(n-1)}(a)}{(n-1)!} \dot (x-a)^{(n-1)} + R_n",
                          scale: MathTheme.of(context).expressionScale?? 1.0,
                        ),
                        DisplayExpression(
                          context: context,
                          decoration: MathTheme.of(context).listItemDecoration,
                          expression: r"R_n = \frac{(x-a)^n}{n!}\dot f^{n}(\xi), \xi = a + \theta \dot (x-a), \theta in (0,1) ",
                          scale: MathTheme.of(context).expressionScale?? 1.0,
                        ),
                      ]
                  )
              ),
              popupDialog: FittedBox(
                fit: BoxFit.fitWidth,
                child: DisplayExpression(
                  context: context,
                  decoration: MathTheme.of(context).listItemDecoration,
                  expression:
                  r"\forall f^{n}(0)\text{ is differentiable}, n \in N",
                  scale: MathTheme.of(context).expressionScale?? 1.0,
                ),
              ),
            ),
          ]
      ),
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
            horizontal: MathTheme.of(context).horizontalPadding?? 0.0,
            vertical: MathTheme.of(context).verticalPadding?? 0.0,
          ),
          children: [
            ShrinkableListItem(
              title:  "Approximation expressions",
              expanded: true,
              details: approximations,
              titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}