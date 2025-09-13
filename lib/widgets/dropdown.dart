import 'package:flutter/material.dart';

import '../models/3d_shapes/shape_type.dart';

class Dropdown extends StatefulWidget {
  // Add the callback function property
  final Function(ShapeType) onShapeSelected;
  final ShapeType shapeType;
  const Dropdown({super.key, required this.onShapeSelected, required this.shapeType});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  // This is the currently selected item.
  late ShapeType _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.shapeType;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle dropdownTextStyle = TextStyle(
      fontSize: 18.0, // Increased font size
      color: Colors.white70, // A whitish color (you can adjust opacity or use Colors.white)
    );

    return DropdownButton<ShapeType>(
      // The hint text is shown when no item is selected.
      hint: const Text('Select an shape', style: dropdownTextStyle,),
      value: _selectedItem,
      icon: const Icon(Icons.arrow_downward),
      elevation: 2,
      isExpanded: true,
      dropdownColor: Colors.grey.shade800,
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black),
      items: ShapeType.values.map<DropdownMenuItem<ShapeType>>((ShapeType value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value.value, style: dropdownTextStyle),
        );
      }).toList(),
      onChanged: (ShapeType? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedItem = newValue;
            widget.onShapeSelected(newValue);
          });
        }
      },
    );
  }
}