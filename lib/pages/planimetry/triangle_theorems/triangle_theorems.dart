import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/pages/planimetry/triangle_theorems/triangle_area.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/background_container.dart';

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
            navigatingTheoremPage(context, l10n.triangleArea, TriangleAreaPage(title: l10n.triangleArea)),
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