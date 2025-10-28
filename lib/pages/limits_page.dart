import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/background_container.dart';
import 'package:flutter_maths_expressions/widgets/display_expression.dart';

import '../l10n/app_localizations.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final expressionScale = 2.0;
    final constraintsScale = 1.5;
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
    final constraintItemDecoration = BoxDecoration(
      color: Colors.grey.shade300, // Background color of the "card"
      border: Border.all(
        color: Colors.grey.shade400, // Color of the outline
        width: 1.0,                // Thickness of the outline
      ),
      borderRadius: BorderRadius.circular(2.0), // Rounded corners for the card-like look
      boxShadow: [ // Optional: Add shadow similar to a Card
        BoxShadow(
          color: Colors.grey.withAlpha(128),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );

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
            scale: expressionScale),
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
          scale: expressionScale),
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
            scale: expressionScale),
        )
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} \frac{f(x)}{g(x)} = \frac{f}{g}",
          scale: expressionScale),
        ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} [f(x) + g(x)] = \infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = a, \lim_{x \to x_0} g(x) = \infty",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to x_0} \frac{f(x)}{g(x)} = \frac{f}{g}",
            scale: expressionScale),
        popupDialog: FittedBox(
            fit: BoxFit.fitWidth,
            child: DisplayExpression(
                context: context,
                decoration: listItemDecoration,
                expression:
                r" g(x) \neq 0",
                scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to x_0} f(x)^n = [\lim_{x \to x_0} f(x)]^{x_0}",
            scale: expressionScale
        ),
        popupDialog: FittedBox(
            fit: BoxFit.fitWidth,
            child: DisplayExpression(
                context: context,
                decoration: listItemDecoration,
                expression:
                r"\lim_{x \to x_0} f(x) = a, \lim_{x \to x_0} g(x) = -\infty",
                scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} [f(x) + g(x)] = \infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = \infty, \lim_{x \to x_0} g(x) = \infty",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} [f(x) + g(x)] = -\infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = -\infty, \lim_{x \to x_0} g(x) = -\infty",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} [f(x) \cdot g(x)] = \infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = a > 0, \lim_{x \to x_0} g(x) = \infty",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} [f(x) \cdot g(x)] = \infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = a < 0, \lim_{x \to x_0} g(x) = -\infty",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} [f(x) \cdot g(x)] = \infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = \infty, \lim_{x \to x_0} g(x) = \infty",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} [f(x) \cdot g(x)] = -\infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = \infty, \lim_{x \to x_0} g(x) = -\infty",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} \frac{f(x)}{g(x)} = 0",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = a, \lim_{x \to x_0} g(x) = \pm \infty",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} \frac{f(x)}{g(x)} = \infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = \infty, \lim_{x \to x_0} g(x) = a > 0",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} \frac{f(x)}{g(x)} = -\infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = -\infty, \lim_{x \to x_0} g(x) = a > 0",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} \frac{f(x)}{g(x)} = -\infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = \infty, \lim_{x \to x_0} g(x) = a < 0",
            scale: expressionScale)
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to x_0} \frac{f(x)}{g(x)} = \infty",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression:
            r"\lim_{x \to x_0} f(x) = -\infty, \lim_{x \to x_0} g(x) = a < 0",
            scale: expressionScale)
        ),
      ),
    ];
    final List<Widget> deLHospitalRules = [
      // Case 1: 0 / 0
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r" \lim_{x \to a} \frac{f(x)}{g(x)} = \frac{f'(a)}{g'(a)}",
          scale: expressionScale
        ),
        popupDialog: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
              context: context,
              decoration: listItemDecoration,
              expression:
              r"\lim_{x \to a} f(x) = 0, \lim_{x \to a} g(x) = 0, g'(x) \neq 0",
              scale: constraintsScale)
        ),
      ),
      // Case 2: 0 / 0
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to a} \frac{f(x)}{g(x)} = \frac{f^{(n)}(a)}{g^{(n)}(a)}",
            scale: expressionScale
        ),
        popupDialog: Column(
          children: [
            DisplayExpression(
              context: context,
              decoration: constraintItemDecoration,
              expression:
              r"\lim_{x \to a} f(x) = 0, \lim_{x \to a} g(x) = 0, f'(x) \neq 0",
              scale: constraintsScale,
              outlineMargin: 0.0,
              alignment: Alignment.centerLeft,
            ),
            DisplayExpression(
              context: context,
              decoration: constraintItemDecoration,
              expression:
              r"f'(a) = f''(a) = \dots = f^{(n-1)}(a) = 0",
              scale: constraintsScale,
              outlineMargin: 0.0,
              alignment: Alignment.centerLeft,
            ),
            DisplayExpression(
              context: context,
              decoration: constraintItemDecoration,
              expression:
              r"g'(a) = g''(a) = \dots = g^{(n-1)}(a) = 0",
              scale: constraintsScale,
              outlineMargin: 0.0,
              alignment: Alignment.centerLeft,
            ),
            DisplayExpression(
              context: context,
              decoration: constraintItemDecoration,
              expression:
              r"g^{(n)}(a) \neq 0",
              scale: constraintsScale,
              outlineMargin: 0.0,
              alignment: Alignment.centerLeft,
            ),
          ]
        ),
      ),
      // Case 3: 0 /0
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to \infty} \frac{f(x)}{g(x)} = K",
            scale: expressionScale
        ),
        popupDialog: Column(
            children: [
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"\lim_{x \to 'infty} f(x) = 0, \lim_{x \to \infty} g(x) = 0",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"g'(x) \neq 0 (a, \infty), \lim_{x \to \infty} \frac{f'(x)}{g'(x)} = K",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
            ]
        ),
      ),
      // Case 5: (-/+)inf / (-/+)inf
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to -\infty} \frac{f(x)}{g(x)} = K",
            scale: expressionScale
        ),
        popupDialog: Column(
            children: [
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"\lim_{x \to -'infty} f(x) = 0, \lim_{x \to -\infty} g(x) = 0",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"g'(x) \neq 0 (-\infty, a), \lim_{x \to -\infty} \frac{f'(x)}{g'(x)} = K",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
            ]
        ),
      ),
      // Case 5: (-/+)inf / (-/+)inf
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to a} \frac{f(x)}{g(x)} = K",
            scale: expressionScale
        ),
        popupDialog: Column(
            children: [
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"\lim_{x \to a} f(x) = \infty, \lim_{x \to a} g(x) = \infty",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"g'(x) \neq 0 (-\epsilon - a, a + \epsilon), \lim_{x \to a} \frac{f'(x)}{g'(x)} = K",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
            ]
        ),
      ),
      // Case 8: 0 / 0: f(x)*g(x) = 0*inf -> 0/0: f(x) / (1/g(x))
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x} f(x) \cdot g(x) = \frac{f(x)}{1 \div g(x)}",
            scale: expressionScale
        ),
        popupDialog: Column(
            children: [
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"f(x) = 0, g(x) = \infty, \lim_{x} f(x) = 0, \lim_{x} g(x) = \infty",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
            ]
        ),
      ),
      // Case 9: 0 / 0: f(x)*g(x) = inf*0 -> 0/0: f(x) / (1/g(x))
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x} f(x) \cdot g(x) = \frac{g(x)}{1 \div f(x)}",
            scale: expressionScale
        ),
        popupDialog: Column(
            children: [
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"f(x) = \infty, g(x) = \infty, \lim_{x} f(x) = 0, \lim_{x} g(x) = 0",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
            ]
        ),
      ),
      // Case 10: 0 / 0: f(x) - g(x) = inf - inf
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: FittedBox(
          fit: BoxFit.fitWidth,
          child: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"f(x) - g(x) = \frac{1 \div g(x) - 1 \div f(x)}{1 \div (f(x) \cdot g(x))}",
            scale: expressionScale
          )
        ),
        popupDialog: Column(
            children: [
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"f(x) = \infty, g(x) = \infty",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"\lim_{x} f(x) = 0, \lim_{x} g(x) = 0",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
            ]
        ),
      ),
      // Case 11: 0^0, 1^inf, inf^0
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: Column(
          children: [
            DisplayExpression(
              context: context,
              decoration: listItemDecoration,
              expression: r"F(x) = [f(x)]^{g(x)}",
              scale: expressionScale,
              outlineMargin: 0.0,
            ),
            DisplayExpression(
              context: context,
              decoration: listItemDecoration,
              expression: r"B = \log {\lim_{x \to a} F(x)}",
              scale: expressionScale,
              outlineMargin: 0.0,
            ),
            DisplayExpression(
              context: context,
              decoration: listItemDecoration,
              expression: r"A = \lim_{x \to a} F(x) = e^B",
              scale: expressionScale,
              outlineMargin: 0.0,
            ),
          ],
        ),
        popupDialog: Column(
            children: [
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"\lim_{x \to a} F(x) = 0 \cap \lim B  = -\infty",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
              DisplayExpression(
                context: context,
                decoration: constraintItemDecoration,
                expression:
                r"B = \infty \cap \lim_{x \to a} F(x)= \infty",
                scale: constraintsScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
            ]
        ),
      ),
    ];
    final List<Widget> baseCases = [
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: Column(
          children: [
            FittedBox(fit: BoxFit.fitWidth,
              child: DisplayExpression(
                context: context,
                decoration: listItemDecoration,
                expression: r"\lim_{x \to \infty} (a_nx^n + a_{n-1}x^{n-1} + \dots + a_1x + a_0) =",
                scale: expressionScale,
                outlineMargin: 0.0,
                alignment: Alignment.centerLeft,
              ),
            ),
            DisplayExpression(
                context: context,
                decoration: listItemDecoration,
                expression: r" = \lim_{x \to \infty} a_n \cdot x^n",
                scale: expressionScale,
                outlineMargin: 0.0,
            ),
          ],
        )
      ),
      PopupWidget(
          horizontalPadding: horizontalPaddingItem,
          verticalPadding: verticalPaddingItem,
          content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to \infty} \sin(x) = \infty",
          scale: expressionScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to \infty} \cos(x) = \infty",
          scale: expressionScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to \infty} \tan(x) = \infty",
          scale: expressionScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to \infty} \ctg(x) = \infty",
          scale: expressionScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to \infty} \sec(x) = \infty",
          scale: expressionScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to \infty} \csc(x) = \infty",
          scale: expressionScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to +\infty} ln(x) = +\infty",
            scale: expressionScale
        )
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to +\infty} \log_{a}(x) = +\infty",
          scale: expressionScale
        ),
        popupDialog: DisplayExpression(
          context: context,
          decoration: constraintItemDecoration,
          expression:
          r"a > 1",
          scale: constraintsScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
          context: context,
          decoration: listItemDecoration,
          expression: r"\lim_{x \to +\infty} \log_{a}(x) = -\infty",
          scale: expressionScale
        ),
        popupDialog: DisplayExpression(
          context: context,
          decoration: constraintItemDecoration,
          expression:
          r"0 < a < 1",
          scale: constraintsScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to +\infty} e^(x) = +\infty",
            scale: expressionScale
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to -\infty} e^(x) = 0",
            scale: expressionScale
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to +\infty} a^x = \infty",
            scale: expressionScale
        ),
        popupDialog: DisplayExpression(
          context: context,
          decoration: constraintItemDecoration,
          expression:
          r"a > 1",
          scale: constraintsScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to +\infty} a^x = 0",
            scale: expressionScale
        ),
        popupDialog: DisplayExpression(
          context: context,
          decoration: constraintItemDecoration,
          expression:
          r"a > 1",
          scale: constraintsScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to +\infty} a^x = 0",
            scale: expressionScale
        ),
        popupDialog: DisplayExpression(
          context: context,
          decoration: constraintItemDecoration,
          expression:
          r"0 < a < 1",
          scale: constraintsScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to -\infty} a^x = +\infty",
            scale: expressionScale
        ),
        popupDialog: DisplayExpression(
          context: context,
          decoration: constraintItemDecoration,
          expression:
          r"0 < a < 1",
          scale: constraintsScale,
        ),
      ),
      PopupWidget(
        horizontalPadding: horizontalPaddingItem,
        verticalPadding: verticalPaddingItem,
        content: DisplayExpression(
            context: context,
            decoration: listItemDecoration,
            expression: r"\lim_{x \to 0} \frac{sin(a \cdot x)}{b \cdot x} = \frac{a}{b}",
            scale: expressionScale
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
          title: Text(
              widget.title, style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          children: [
            ShrinkableListItem(title: l10n.limitsTheorems, details: theorems,),
            ShrinkableListItem(title: l10n.similitudeHospitalRules, details: deLHospitalRules,),
            ShrinkableListItem(title: l10n.limitsBaseCases, details: baseCases),
            const SizedBox(height: 48),
          ],
        )
      ),
    );
  }
}