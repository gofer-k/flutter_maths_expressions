import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/pages/derived_page.dart';
import 'package:flutter_maths_expressions/pages/planimetry/planimetry_page.dart';
import 'package:flutter_maths_expressions/pages/trigonometry_page.dart';

import '../l10n/app_localizations.dart';
import '../widgets/background_container.dart';
import 'block_shapes_page.dart';
import 'limits_page.dart';
import 'logarithms_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
        BackgroundContainer(
          beginColor: Colors.grey.shade200,
          endColor: Colors.grey.shade700,
          child: _pageContent()),
    );
  }

  Widget _pageContent() {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.mainPageTitle),
      ),
      body: Center(
        child:
          GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0),
            children: [
              navigatingCard(
                context, Image.asset("assets/images/logarithms.png"), 'Logarithms',
                LogarithmsPage(title: l10n.logarithmsPageTitle),
              ),
              navigatingCard(
                context, Image.asset("assets/images/planimetry.png"), 'Planimetry',
                PlanimetryPage(title: l10n.planimetryPageTitle),
              ),
              navigatingCard(
                context, Image.asset("assets/images/trigonometry.png"), 'Trigonometry',
                TrigonometryPage(title: l10n.trigonometryPageTitle),
              ),
              navigatingCard(
                context, Image.asset("assets/images/block_shapes.png"), 'Block shapes',
                BlockShapesPage(title: l10n.blockShapesPageTitle),
              ),
              navigatingCard(
                context, Image.asset("assets/images/limits.png"), 'Limits',
                LimitsPage(title: l10n.limitsPageTitle),
              ),
              navigatingCard(
                context, Image.asset("assets/images/derivatives.png"), 'Derivative theorems',
                DerivativePage(title: l10n.derivativePageTitle),
              ),
            ],
          ),
      ),
    );
  }

  Card navigatingCard<T extends StatefulWidget>(
      BuildContext context, Image image, String label, T widget) {
    const double edgeMargin = 8;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child:
      Padding(
        padding: const EdgeInsets.fromLTRB(edgeMargin, edgeMargin, edgeMargin, edgeMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return widget;
                    }),
                  ),
                );
              },
              icon: image,
            ),
          ],
        ),
      ),
    );
  }
}