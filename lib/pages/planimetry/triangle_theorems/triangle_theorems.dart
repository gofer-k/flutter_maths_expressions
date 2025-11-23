import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/bisector_theorem.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/pythagoras_theorem.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangle_angles.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangle_law_cosines.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangle_law_sines.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangle_propertes.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangles_congruence.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangles_similarity.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/background_container.dart';
import 'apollonius_theorem.dart';
import 'circumcenter_theorem.dart';
import 'centroid_theorem.dart';
import 'incenter_theorem.dart';
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
            navigatingTheoremPage(context, l10n.triangleInCenterTheorem, IncenterTheoremPage(title: l10n.triangleInCenterTheorem)),
            navigatingTheoremPage(context, l10n.triangleLawSines, TriangleLawSines(title: l10n.triangleLawSines)),
            navigatingTheoremPage(context, l10n.triangleLawCosines, TriangleLawCosines(title: l10n.triangleLawCosines)),
            navigatingTheoremPage(context, l10n.triangleApolloniusTheorem, ApolloniusTheorem(title: l10n.triangleApolloniusTheorem))
          ],
        )
      ),
    );
  }

  Widget navigatingTheoremPage<T extends StatefulWidget>(
    BuildContext context, String label, T widget) {
    final edgeMargin = 2.0;
    return Container(
      // padding: EdgeInsets.symmetric(vertical: edgeMargin),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade200, Colors.blue.shade400],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
      ),
    // child: TextButton(
    //     onPressed: () async {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: ((context) {
    //             return widget;
    //           }),
    //         ),
    //       );
    //     },
    //     child: Text(label),
    //   )
    );
  }
}
