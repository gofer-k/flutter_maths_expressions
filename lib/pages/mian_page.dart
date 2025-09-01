import 'package:flutter/material.dart';

import '../widgets/background_container.dart';
import 'logarithms_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
        BackgroundContainer(
          child: _pageContent(),
          beginColor: Colors.grey.shade800,
          endColor: Colors.grey.shade300),
    );
  }

  Widget _pageContent() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.title),
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
                LogarithmsPage(title: 'Logarithms'),
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