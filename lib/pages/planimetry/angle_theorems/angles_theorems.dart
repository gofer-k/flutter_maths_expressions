import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/pages/planimetry/angle_theorems/angle_types.dart';
import 'package:flutter_maths_expressions/pages/planimetry/angle_theorems/polygon_angles_page.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/background_container.dart';

class AnglesTheoremsPage extends StatefulWidget {
  final String title;

  const AnglesTheoremsPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _AnglesTheoremsPageState();
}

class _AnglesTheoremsPageState extends State<AnglesTheoremsPage> {

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
            navigatingTheoremPage(context, l10n.anglesTheorems, AngleTypesPage(title: l10n.anglesTheorems)),
            navigatingTheoremPage(context, l10n.anglesPolygon, PolygonAnglesPage(title: l10n.anglesPolygon)),
          ],
        )
      ),
    );
  }

  Widget navigatingTheoremPage<T extends StatefulWidget>(
    BuildContext context, String label, T widget) {
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
