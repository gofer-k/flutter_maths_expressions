
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShrinkableListItem extends StatefulWidget {
  final String title;
  final List<Widget> details;
  final TextStyle? titleStyle;

  ShrinkableListItem({
    Key? key,
    required this.title,
    required this.details,
    this.titleStyle,
  }) : super(key: key);

  @override
  _ShrinkableListItemState createState() => _ShrinkableListItemState();
}

class _ShrinkableListItemState extends State<ShrinkableListItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300), // Adjust duration
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Adjust curve
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward(); // Play animation to expand
      } else {
        _controller.reverse(); // Play animation to collapse
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _toggleExpand,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.title,
                      style: widget.titleStyle ?? Theme.of(context).textTheme.titleMedium,)
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          SizeTransition(
            axisAlignment: -1.0, // Aligns to the top during transition
            sizeFactor: _animation,
            child: Container(
              // padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.details,
              ),
            ),
          ),
        ],
    );
  }
}