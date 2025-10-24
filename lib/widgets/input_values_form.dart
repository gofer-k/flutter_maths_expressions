import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class CellData<Value> {
  final String label;
  late Value? cellValue;
  final bool readOnly;

  CellData({required this.label, this.cellValue, this.readOnly = true});
}

typedef InputData<Value> = List<List<CellData<Value>>>;

class InputValuesForm<Value> extends StatefulWidget {
  final InputData<Value> contents;
  final Function(InputData<Value>) onSubmit;

  const InputValuesForm({
    super.key,
    required this.contents,
    required this.onSubmit,
  });

  @override
  State<InputValuesForm<Value>> createState() => _InputValuesFormState<Value>();
}

class _InputValuesFormState<Value> extends State<InputValuesForm<Value>> {
  final _formKey = GlobalKey<FormState>();

  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [];
    _passInputDataToController();
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const spaceWidth = 16.0;
    int controllerIndex = 0;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.contents.map((formRow) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final cellData in formRow) ...[
                  cellData.readOnly
                      ? Text(
                          cellData.label,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      : Expanded(
                          child: _buildVertexField(
                            cellData.label,
                            cellData.cellValue,
                            _controllers[controllerIndex++],
                            l10n,
                          ),
                        ),
                  const SizedBox(height: spaceWidth, width: spaceWidth),
                ],
              ],
            );
          }),

          const SizedBox(height: spaceWidth),
          //TODO: prevent covered in the main bottom navigation bar
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                _extractInputDataFromController();
                widget.onSubmit(widget.contents);
              }
            },
            child: Text(l10n.submit),
          ),
        ],
      ),
    );
  }

  Widget _buildVertexField(
    String label,
    Value? value,
    TextEditingController controller,
    AppLocalizations? l10n,
  ) {
    final maxNumberPosition = 6;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: maxNumberPosition,
      decoration: InputDecoration(labelText: label),
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return label;
        }
        if (Value == double) {
          if (double.tryParse(value) == null) {
            return l10n?.parseValueError;
          }
        } else if (Value == int) {
          if (int.tryParse(value) == null) {
            return l10n?.parseValueError;
          }
        } else if (Value == String) {
          if (value.length > maxNumberPosition) {
            return l10n?.tooLongValueError;
          }
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
          controller.text = value;
        }
      }
    );
  }
  
  void _passInputDataToController() {
    for (var row in widget.contents) {
      for (var cellData in row) {
        if (!cellData.readOnly) {
          final controller = TextEditingController(
            text: cellData.cellValue?.toString(),
          );
          _controllers.add(controller);
        }
      }
    }
  }

  void _extractInputDataFromController() {
    int controllerIndex = 0;
    for (var row in widget.contents) {
      for (var cellData in row) {
        if (!cellData.readOnly) {
          final controller = _controllers[controllerIndex++];
          final value = tryParse(controller.text);
          if(value != null) {
            cellData.cellValue = value;
          }
        }
      }
    }
  }
  
  Value? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (Value == double) {
      return double.tryParse(value) as Value;
    } else if (Value == int) {
      return int.tryParse(value) as Value;
    } else if (Value == String) {
      return value as Value;
    }
    // It's good practice to handle unsupported types.
    throw UnsupportedError('The type $Value is not supported for parsing.');
  }
}
