import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'infinite_drawer.dart';

class HierarchicalFABMenu extends StatefulWidget {
  final DockSide actionsDockSide;
  final double insetsFab;

  const HierarchicalFABMenu({super.key, this.actionsDockSide = DockSide.rightBottom, this.insetsFab = 4.0});

  @override
  State<StatefulWidget> createState() => _HierarchicalFABMenuState();
}

class _HierarchicalFABMenuState extends State<HierarchicalFABMenu> {
  bool isMainExpanded = false;
  bool isZoomExpanded = false;
  bool isPanExpanded = false;

  late double? insetRight;
  late double? insetBottom;
  late double? insetLeft;
  late double? insetTop;

  late final MainAxisAlignment mainAxisAlignment;
  late final CrossAxisAlignment crossAxisAlignment;
  @override
  void initState() {
    super.initState();
    insetRight = ((widget.actionsDockSide == DockSide.rightBottom ||
        widget.actionsDockSide == DockSide.rightTop) ? widget.insetsFab : null);
    insetBottom = ((widget.actionsDockSide == DockSide.rightBottom ||
        widget.actionsDockSide == DockSide.leftBottom) ? widget.insetsFab : null);
    insetLeft = ((widget.actionsDockSide == DockSide.leftBottom ||
        widget.actionsDockSide == DockSide.leftTop) ? widget.insetsFab : null);
    insetTop = ((widget.actionsDockSide == DockSide.rightTop ||
        widget.actionsDockSide == DockSide.leftTop) ? widget.insetsFab : null);

    mainAxisAlignment = (widget.actionsDockSide == DockSide.leftBottom ||
        widget.actionsDockSide == DockSide.leftTop) ? MainAxisAlignment.start : MainAxisAlignment.end;
    crossAxisAlignment = (widget.actionsDockSide == DockSide.leftBottom ||
        widget.actionsDockSide == DockSide.leftTop) ? CrossAxisAlignment.start : CrossAxisAlignment.end;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Zoom In/Out
        if (isZoomExpanded) ...[
          _buildActionButton(Icons.zoom_in, () => print('Zoom In'), offset: const Offset(0, -230)),
          _buildActionButton(Icons.zoom_out, () => print('Zoom Out'), offset: const Offset(0, -180)),
          _buildActionButton(Icons.center_focus_strong, () => print('Reset Zoom'), offset: const Offset(0, -130)),
          _buildActionButton(Icons.fit_screen, () => print('Fit to Screen'), offset: const Offset(0, -80)),
        ],

        // Pan Left/Right
        if (isPanExpanded) ...[
          _buildActionButton(Icons.arrow_upward, () => print('Pan Up'), offset: Offset(-60, -230)),
          _buildActionButton(Icons.arrow_back, () => print('Pan Left'), offset: Offset(-60, -180)),
          _buildActionButton(Icons.arrow_forward, () => print('Pan Right'), offset: Offset(-60, -130)),
          _buildActionButton(Icons.arrow_downward, () => print('Pan Down'), offset: Offset(-60, -80)),
        ],

        // Zoom & Pan Level
        if (isMainExpanded) ...[
          _buildActionButton(Icons.zoom_out_map, () {
            setState(() {
              isZoomExpanded = !isZoomExpanded;
              if (kDebugMode) {
                print('isZoomExpanded: $isZoomExpanded');
              }
            });
          }, offset: Offset(0, -20)),
          _buildActionButton(Icons.open_with, () {
            setState(() => isPanExpanded = !isPanExpanded);
          }, offset: Offset(-60, -80)),
        ],

        // Main FAB
      Positioned(
        left: insetLeft,
        right: insetRight,
        bottom: insetBottom,
        top: insetTop,
        child: FloatingActionButton(
            mini: true,
            child: Icon(isMainExpanded ? Icons.close : Icons.menu),
            onPressed: () {
              setState(() {
                isMainExpanded = !isMainExpanded;
                if (!isMainExpanded) {
                  isZoomExpanded = false;
                  isPanExpanded = false;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  // Widget _expandTop() {
  //
  // }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed, {required Offset offset}) {
    return Positioned(
      left: insetLeft,
      right: insetRight,
      bottom: insetBottom,
      top: insetTop,
      child: FloatingActionButton(
        mini: true,
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}