import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/bisector_theorem.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/pythagoras_theorem.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangle_angles.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangle_propertes.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangles_congruence.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangles_similarity.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/background_container.dart';
import 'CircumcenterTheorem.dart';
import 'centroid_theorem.dart';
import 'median_theorem.dart';
import 'midsegment_theorem.dart';

class TriangleTheoremsPage extends StatefulWidget {
  final String title;

  const TriangleTheoremsPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TriangleTheoremsPageState();
}

class _TriangleTheoremsPageState extends State<TriangleTheoremsPage> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BackgroundContainer(
      beginColor: Colors.grey.shade300,
      // endColor: Colors.grey.shade800,
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
          children: [
            navigatingTheoremPage(context, l10n.triangleArea, TrianglePropertiesPage(title: l10n.triangleArea)),
            navigatingTheoremPage(context, l10n.triangleAngles, TriangleAnglesPage(title: l10n.triangleAngles)),
            navigatingTheoremPage(context, l10n.trianglesCongruence, TrianglesCongruence(title: l10n.trianglesCongruence)),
            navigatingTheoremPage(context, l10n.trianglesSimilarity, TrianglesSimilarity(title: l10n.trianglesSimilarity)),
            navigatingTheoremPage(context, l10n.trianglePythagorasTheorem, PythagorasTheorem(title: l10n.trianglePythagorasTheorem)),
            navigatingTheoremPage(context, l10n.triangleMedianTheorem, MedianTheoremPage(title: l10n.triangleMedianTheorem)),
            navigatingTheoremPage(context, l10n.triangleCentroidPoint, CentroidTheorem(title: l10n.triangleCentroidPoint)),
            navigatingTheoremPage(context, l10n.triangleBisectorTheorem, BisectorTheorem(title: l10n.triangleBisectorTheorem,)),
            navigatingTheoremPage(context, l10n.triangleMidsegmentTheorem, MidsegmentTheorem(title: l10n.triangleMidsegmentTheorem)),
            navigatingTheoremPage(context, l10n.triangleCircumCenterTheorem, CircumcenterTheorem(title: l10n.triangleCircumCenterTheorem)),
          ],
        )
      ),
    );
  }

  Widget navigatingTheoremPage<T extends StatefulWidget>(
    BuildContext context, String label, T widget) {
    final edgeMargin = 2.0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: edgeMargin),
      child: TextButton(
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
        child: Text(label),
      )
    );
  }
}
