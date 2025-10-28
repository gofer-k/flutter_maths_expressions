import 'package:flutter/material.dart';

import '../models/dock_side.dart';

class FABAction {
  final IconData actionIcon;
  final VoidCallback? onPressed;

  FABAction({required this.actionIcon, this.onPressed});
}

class FABMenu {
  late bool _isExpand = false;
  bool get isExpand => _isExpand;
  set expand(bool newValue) => _isExpand = newValue;
  final bool isExpandable;
  final FABAction action;
  final List<FABAction> actions;
  FABMenu(this.isExpandable, this.actions, {required this.action});
}

/*
  Hierarchical FloatingActionButton widgets. Support 2-dimension fabs.
 */
class HierarchicalFABMenu extends StatefulWidget {
  final DockSide actionsDockSide;
  final double insetsFab;
  final List<FABMenu> mainMenu;

  const HierarchicalFABMenu({super.key,
    this.actionsDockSide = DockSide.rightBottom,
    this.insetsFab = 4.0,
    required this.mainMenu});

  @override
  State<StatefulWidget> createState() => _HierarchicalFABMenuState();
}

class _HierarchicalFABMenuState extends State<HierarchicalFABMenu> {
  bool isMainExpanded = false;

  late final double insetRight;
  late final double insetBottom;
  late final double insetLeft;
  late final double insetTop;

  late final MainAxisAlignment mainAxisAlignment;
  late final CrossAxisAlignment crossAxisAlignment;


  bool get expandUp => widget.actionsDockSide == DockSide.leftBottom || widget.actionsDockSide == DockSide.rightBottom;
  bool get expandRight => widget.actionsDockSide == DockSide.leftTop || widget.actionsDockSide == DockSide.leftBottom;

  @override
  void initState() {
    super.initState();
    insetLeft = widget.insetsFab;
    insetRight = widget.insetsFab;
    insetBottom = widget.insetsFab;
    insetTop = widget.insetsFab;

    mainAxisAlignment = (widget.actionsDockSide == DockSide.leftBottom ||
        widget.actionsDockSide == DockSide.leftTop) ? MainAxisAlignment.start : MainAxisAlignment.end;
    crossAxisAlignment = (widget.actionsDockSide == DockSide.leftBottom ||
        widget.actionsDockSide == DockSide.leftTop) ? CrossAxisAlignment.start : CrossAxisAlignment.end;
  }

  @override
  Widget build(BuildContext context) {
    final spacing = 2.0;
    final fabSize = 44.0; // FloatingActionButton.small has 2.0 dp padding around content

    return SizedBox.expand(
      child: Stack(
      alignment: getAlignment(widget.actionsDockSide),
      children: [
        Positioned(
          child: Padding(
            padding: EdgeInsetsGeometry.all(widget.insetsFab),
            child: FloatingActionButton.small(
              heroTag: 'level_main',
              onPressed: () {
                setState(() {
                  isMainExpanded = !isMainExpanded;
                  if (!isMainExpanded) {
                    for (var action in widget.mainMenu) {
                      action.expand = false;
                    }
                  }
                });
              },
              child: Icon(isMainExpanded ? Icons.close : Icons.menu),
            ),
          ),
        ),
        if (isMainExpanded)
          _expandMainMenu(fabSize, spacing),

        for(final (index, menu) in widget.mainMenu.indexed)
          if (menu.isExpandable && menu.isExpand)
            _expandNestMenu(menu, (index + 1) * fabSize, fabSize, spacing),
        ],
      )
    );
  }

  Widget _expandMainMenu(double fabSize, double spacing) {
    final positionedTop = positionedOffset(
        start: DockSide.leftTop,
        end: DockSide.rightTop,
        offset: fabSize + widget.insetsFab);

    final positionedBottom = positionedOffset(
        start: DockSide.leftBottom,
        end: DockSide.rightBottom,
        offset: fabSize + widget.insetsFab);

    final paddingLeft = paddingOffset(
        start: DockSide.leftTop,
        end: DockSide.leftBottom,
        offset: widget.insetsFab);

    final paddingRight = paddingOffset(
      start: DockSide.rightTop,
      end: DockSide.rightBottom,
      offset: widget.insetsFab);

    final paddingTop = paddingOffset(
        start: DockSide.leftTop,
        end: DockSide.rightTop,
        offset: spacing);

    final paddingBottom = paddingOffset(
        start: DockSide.leftBottom,
        end: DockSide.rightBottom,
        offset: spacing);

    final bool reserved = widget.actionsDockSide == DockSide.leftBottom ||
        widget.actionsDockSide == DockSide.rightBottom;

    return Positioned(
      top: positionedTop,
      bottom: positionedBottom,
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: paddingLeft, right: paddingRight, top: paddingTop, bottom: paddingBottom),
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: List.generate(widget.mainMenu.length, (i) {
            final index = reserved ? widget.mainMenu.length - 1 - i : i;
            return Column(
              children: [
                FloatingActionButton.small(
                    heroTag: 'level_2_$index',
                    onPressed: () {
                      setState(() {
                        final value = !widget.mainMenu[index].isExpand;
                        widget.mainMenu[index].expand = value;
                      });
                    },
                    child: Icon(widget.mainMenu[index].action.actionIcon),
                ),
              ]
            );
          }),
        ),
      ),
    );
  }

  Widget _expandNestMenu(FABMenu menu, double vertLeading, double horizLeading, double spacing) {
    final positionedTop = positionedOffset(
        start: DockSide.leftTop,
        end: DockSide.rightTop,
        offset: widget.insetsFab);

    final positionedBottom = positionedOffset(
        start: DockSide.leftBottom,
        end: DockSide.rightBottom,
        offset: widget.insetsFab);

    final positionedLeft = positionedOffset(
        start: DockSide.leftTop,
        end: DockSide.leftBottom,
        offset: horizLeading + widget.insetsFab);

    final positionedRight = positionedOffset(
        start: DockSide.rightTop,
        end: DockSide.rightBottom,
        offset: horizLeading + widget.insetsFab);

    final paddingTop = paddingOffset(
        start: DockSide.leftTop,
        end: DockSide.rightTop,
        offset: vertLeading + widget.insetsFab);

    final paddingBottom = paddingOffset(
        start: DockSide.leftBottom,
        end: DockSide.rightBottom,
        offset: vertLeading + widget.insetsFab);

    final paddingLeft = paddingOffset(
        start: DockSide.leftTop,
        end: DockSide.leftBottom,
        offset: spacing);

    final paddingRight = paddingOffset(
        start: DockSide.rightTop,
        end: DockSide.rightBottom,
        offset: spacing);

    return Positioned(
      top: positionedTop,
      bottom: positionedBottom,
      left: positionedLeft,
      right: positionedRight,

      child: Padding(
        padding: EdgeInsetsGeometry.only(top: paddingTop, bottom: paddingBottom, left: paddingLeft, right: paddingRight),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(menu.actions.length, (i){
            return Row(
              children: [
                FloatingActionButton.small(
                  heroTag: 'level_3_$i',
                  onPressed: () {
                    menu.actions[i].onPressed?.call();
                  },
                  child: Icon(menu.actions[i].actionIcon)
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  double? positionedOffset({required DockSide start, required DockSide end, required double offset}) {
    return widget.actionsDockSide == start || widget.actionsDockSide == end ? offset: null;
  }

  double paddingOffset({required DockSide start, required DockSide end, required double offset}) {
    return widget.actionsDockSide == start || widget.actionsDockSide == end ? offset: 0.0;
  }

  getAlignment(DockSide dockSide) {
    switch (dockSide) {
      case DockSide.leftBottom:
        return Alignment.bottomLeft;
      case DockSide.leftTop:
        return Alignment.topLeft;
      case DockSide.rightBottom:
        return Alignment.bottomRight;
      case DockSide.rightTop:
        return Alignment.topRight;
      }
  }
}