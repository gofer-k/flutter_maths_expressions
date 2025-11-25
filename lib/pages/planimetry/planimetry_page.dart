import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/pages/planimetry/angle_theorems/angle_types.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangle_theorems.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/background_container.dart';

class PlanimetryPage extends StatefulWidget {
  final String title;
  const PlanimetryPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _PlanimetryPageState();
}

class _PlanimetryPageState extends State<PlanimetryPage> {
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
        title: Text(l10n.planimetryPageTitle),
      ),
      body: Center(
        child:
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0),
          children: [
            // TODO miss image
            navigatingCard(
              context, null, l10n.triangleTheorems, TriangleTheoremsPage(title: l10n.triangleTheorems)),
            navigatingCard(
                context, null, l10n.anglesTheorems, AngleTypesPage(title: l10n.anglesTheorems)),
          ],
        ),
      ),
    );
  }

  Card navigatingCard<T extends StatefulWidget>(
    BuildContext context, Image? image, String label, T widget)  {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias, // Helps with InkWell ripple
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch content horizontally
          children: [
            if (image != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: image,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
