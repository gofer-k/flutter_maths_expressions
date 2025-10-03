import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/Themes/math_theme.dart';

import '../l10n/app_localizations.dart';
import '../widgets/background_container.dart';
import '../widgets/display_expression.dart';
import '../widgets/popup_widget.dart';
import '../widgets/shrinkable_list_Item.dart';

class DerivativePage extends StatefulWidget {
  final String title;
  const DerivativePage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _DerivativePageState();
}

class _DerivativePageState extends State<DerivativePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> genericRulesExpressions = [
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = C \to f'(x) = \frac{C - C}{x - x_0} = \lim_{x \to x_0} 0 = 0",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      DisplayExpression(
        context: context,
        decoration: MathTheme.of(context).listItemDecoration,
        expression: r"[C \cdot f(x)] = C \cdot f'(x)",
        scale: MathTheme.of(context).expressionScale?? 1.0,
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"[f(x) \pm g(x)]' = f'(x) \pm g'(x)",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"[f(x) \cdot g(x)]' = f(x) \cdot g'(x) + g(x) \cdot f'(x)",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"\left[\frac{f(x)}{g(x)}\right]' = \frac{f'(x) \cdot g(x) - g'(x) \cdot f(x)}{g(x)^2}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"F(x) = f[g(x)] \to F'[x) = f'(u) \cdot g'(x), u = g(x)",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"y = f(x), x = g(y) \to f'(x) = \frac{1}{g'(y)}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
    ];
    final List<Widget> basicDerivativeExpressions = [
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \sin(x) \to f'(x) = \cos(x)",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \cos(x) \to f'(x) = -\sin(x)",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \tan(x) \to f'(x) = \frac{1}{\cos^2(x)}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \ctg(x) \to f'(x) = -\frac{1}{\sin^2(x)}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \arcsin(x) \to f'(x) = \frac{1}{\sqrt{1 - x^2}}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \arccos(x) \to f'(x) = -\frac{1}{\sqrt{1 - x^2}}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \arctan(x) \to f'(x) = \frac{1}{1 + x^2}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \arctg(x) \to f'(x) = -\frac{1}{1 + x^2}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      DisplayExpression(
        context: context,
        decoration: MathTheme.of(context).listItemDecoration,
        expression: r"f(x) = e^x \to f'(x) = e^x",
        scale: MathTheme.of(context).expressionScale?? 1.0,
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = a^x \to f'(x) = a^x \cdot \log a",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      DisplayExpression(
        context: context,
        decoration: MathTheme.of(context).listItemDecoration,
        expression: r"f(x) =   \log x \to f'(x) = \frac{1}{x}",
        scale: MathTheme.of(context).expressionScale?? 1.0,
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = \log_a x \to f'(x) = \frac{1}{x \cdot \log a}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: DisplayExpression(
          context: context,
          decoration: MathTheme.of(context).listItemDecoration,
          expression: r"f(x) = x^a \to f'(x) = a \cdot x^{a - 1}",
          scale: MathTheme.of(context).expressionScale?? 1.0,
        ),
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
        title: Text(widget.title,
          style: Theme.of(context).textTheme.headlineMedium,),
        ),
        body: ListView(
          children: [
            ShrinkableListItem(
              title: l10n.deriveTheoremDefinition,
              expanded: true,
              details: [
                PopupWidget(
                  horizontalPadding: MathTheme.of(context).horizontalPadding?? 0.0,
                  verticalPadding: MathTheme.of(context).verticalPadding?? 0.0,
                  content: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                      context: context,
                      decoration: MathTheme.of(context).listItemDecoration,
                      expression: r"\lim_{x \to x_0} \frac{f(x) - f(x_0)}{x - x_0} = f'(x_0) = \left(\frac{dy}{dx}\right)_{x \to x_0}",
                      scale: MathTheme.of(context).expressionScale?? 1.0,
                    ),
                  ),
                  popupDialog: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: DisplayExpression(
                      context: context,
                      decoration: MathTheme.of(context).listItemDecoration,
                      expression:
                      r"x_0 \\not\\equiv 0",
                      scale: MathTheme.of(context).expressionScale?? 1.0,
                    ),
                  ),
                ),
              ],
              titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
            ),
            // TODO: Derivative continuity geometry
            // TODO: Derivative continuity of functions
            ShrinkableListItem(
              title: l10n.derivativesComputationRules,
              details: genericRulesExpressions,
              titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
              ),
            ShrinkableListItem(
              title: l10n.basicDerivativesExpressions,
              details: basicDerivativeExpressions,
              titleStyle: MathTheme.of(context).shrinkableTitleTextStyle,
            ),
          ]
        )
      )
    );
  }
}