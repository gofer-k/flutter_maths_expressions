import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class CellData<Value> {
  final String label;
  final Value? cellValue;
  final bool readOnly;

  CellData({required this.label, this.cellValue, this.readOnly = true});
}

class InputValuesForm<Value> extends StatefulWidget {
  final List<List<CellData<Value>>> contents;
  final Function(Map<String, Value>) onSubmit;

  const InputValuesForm({
    super.key,
    required this.contents,
    required this.onSubmit,
  });

  @override
  State<InputValuesForm<Value>> createState() => _InputValuesFormState();
}

class _InputValuesFormState<T extends InputValuesForm<Value>, Value>
    extends State<T> {
  final _formKey = GlobalKey<FormState>();

  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [];
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
      onChanged: () {
        setState(() {
          Form.of(_formKey.currentContext!).save();
        });
      },
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                //   widget.onSubmit(_controllers.map((controller) => controller.text).cast<Value>());
              }
              // final ax = double.parse(_axController.text);
              // final ay = double.parse(_ayController.text);
              // final bx = double.parse(_bxController.text);
              // final by = double.parse(_byController.text);
              // final cx = double.parse(_cxController.text);
              // final cy = double.parse(_cyController.text);
              // triangle.update(Offset(ax, ay), Offset(bx, by), Offset(cx, cy));
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
}
