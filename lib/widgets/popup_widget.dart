import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupWidget extends StatefulWidget {
  final Widget content;
  final Widget? popupDialog;
  final double horizontalPadding;
  final double verticalPadding;

  const PopupWidget(
      {super.key, 
       required this.content,
       this.popupDialog,
       this.horizontalPadding = 0,
       this.verticalPadding = 0});
  
  @override
  State<StatefulWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  @override
  Widget build(BuildContext context) {
    /// Use a GlobalKey to get the position of the item
    final GlobalKey itemKey = GlobalKey();

    return Container(
      key: itemKey,
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding, vertical: widget.verticalPadding),
      child: GestureDetector(
        onLongPress: () {
          if (widget.popupDialog != null) {
            final RenderBox itemBox = itemKey.currentContext!.findRenderObject() as RenderBox;
            final Offset itemPosition = itemBox.localToGlobal(Offset.zero);
            final Size size = itemBox.size;

            showMenu(
                context: context,
                menuPadding: EdgeInsets.zero,
                elevation: 0,
                color: Colors.transparent,
                position: RelativeRect.fromLTRB(
                  itemPosition.dx + size.width / 2,
                  itemPosition.dy + size.height / 2,
                  itemPosition.dx + size.width / 2,
                  itemPosition.dy + size.height / 2,
                ),
                items: [
                  PopupMenuItem(
                    value: 0,
                    padding: EdgeInsets.zero,
                    child: widget.popupDialog,
                  ),
                ]
            );
          }
        },
        child: widget.content,
      )
    );
  }
}