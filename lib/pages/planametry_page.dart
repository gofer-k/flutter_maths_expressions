import 'package:flutter/material.dart';
import 'package:infinite_canvas/infinite_canvas.dart';

import '../painters/cross_axes_painter.dart';
import '../widgets/background_container.dart';

class PlanametryPage extends StatefulWidget {
  final String title;
  const PlanametryPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _PlanametryPageState();
}

class _PlanametryPageState extends State<PlanametryPage> {
  late InfiniteCanvasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteCanvasController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
              return Stack(
                children: [
                  InfiniteCanvas(
                    controller: _controller,
                    gridSize: const Size.square(20),
                    menuVisible: false,
                    canAddEdges: true,
                    edgesUseStraightLines: true,
                  ),
                  CustomPaint(
                    size: viewportSize,
                    painter: CrossAxesPainter(
                      canvasTransform: _controller.transform.value,
                      viewportSize: viewportSize,
                    ),
                  ),
                ]
              );
            }
          )
        ),
      ),
    );
  }
}
