import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShrinkableTable extends StatefulWidget {
  final String title;
  final List<List<Widget>> contents;

  const ShrinkableTable({
    Key? key,
    required this.title,
    required this.contents,
  }) : super(key: key);

  @override
  _ShrinkableTableState createState() => _ShrinkableTableState();
}

class _ShrinkableTableState extends State<ShrinkableTable>
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
      children: [
        InkWell(
            onTap: _toggleExpand,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title, style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
        SizeTransition(
          axisAlignment: -1.0, // Aligns to the top during transition
          sizeFactor: _animation,
          child: Table(
            border: TableBorder.all(color: Colors.grey, width: 1.0),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: widget.contents.map((rowContent) {
              return TableRow(
                children: rowContent.map((cellContent) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: cellContent,
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ]
    );
  }
}
