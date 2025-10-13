import 'package:flutter/material.dart';
import 'package:flutter_maths_expressions/widgets/infinite_drawer.dart';
import '../../../widgets/background_container.dart';

class TriangleAreaPage extends StatefulWidget {
  final String title;

  const TriangleAreaPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _TriangleAreaPageState();
}

class _TriangleAreaPageState extends State<TriangleAreaPage> {
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
        body:
        InfiniteDrawer(),
        // Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        //     child: LayoutBuilder(
        //         builder: (context, constraints) {
        //           final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        //           return Stack(
        //               children: [
        //                 InfiniteCanvas(
        //                   controller: _controller,
        //                   gridSize: gridSize,
        //                   menuVisible: false,
        //                   canAddEdges: true,
        //                 ),
        //                 CustomPaint(
        //                   size: viewportSize,
        //                   painter: CrossAxesPainter(
        //                     canvasTransform: _controller.transform.value,
        //                     viewportSize: viewportSize,
        //                     originUnitInPixels: unitInPixels, // Adjust as needed
        //                   ),
        //                 ),
        //                 CustomPaint(
        //                     size: viewportSize,
        //                     painter: TrianglePainter(
        //                       triangle: Triangle(a: Offset(1, 1), b: Offset(3, 3), c: Offset(5, 1)),
        //                       canvasTransform: _controller.transform.value,
        //                       viewportSize: viewportSize, originUnitInPixels: unitInPixels,  // Adjust as needed
        //                     )
        //                 ),
        //                 CustomPaint(
        //                     size: viewportSize,
        //                     painter: TrianglePainter(
        //                       triangle: Triangle(a: Offset(1, 1), b: Offset(3, 3), c: Offset(5, 1)),
        //                       canvasTransform: _controller.transform.value,
        //                       viewportSize: viewportSize, originUnitInPixels: unitInPixels,  // Adjust as needed
        //                     )
        //                 ),
        //                 CustomPaint(
        //                     size: viewportSize,
        //                     painter: LegendPainter(canvasTransform: _controller.transform.value,
        //                       viewportSize: viewportSize,
        //                       labelsSpans: [
        //                         TextSpan(text: "α, ", style: TextStyle(color: Colors.red, fontSize: 28)),
        //                         TextSpan(text: "β, ", style: TextStyle(color: Colors.blue, fontSize: 28)),
        //                         TextSpan(text: "γ", style: TextStyle(color: Colors.green, fontSize: 28))
        //                       ],
        //                       startPosition: Offset(viewportSize.width - 100, 0.95),
        //                     )
        //                 ),
        //                 Positioned(
        //                   right: 16,
        //                   bottom: 16,
        //                   child: floatingActions(context),
        //                 ),
        //               ]
        //           );
        //         }
        //     )
        // ),
      ),
    );
  }
}