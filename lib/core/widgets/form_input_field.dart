import 'package:flutter/material.dart';

class FormInputField extends StatefulWidget {
  final String label;
  final String initialValue;
  final bool autoFocusField;
  final bool validateValue;
  final bool formatDecimal;
  final void Function(String?)? onSaved;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;
  final void Function(String)? onChanged;

  const FormInputField({
    required this.label,
    this.initialValue = '',
    this.autoFocusField = false,
    this.validateValue = false,
    this.formatDecimal = false,
    this.onSaved,
    this.focusNode,
    this.textInputType,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    super.key,
  });

  @override
  State<FormInputField> createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _formatDecimalValue() {
    if (widget.formatDecimal && _controller.text.isNotEmpty) {
      final number = double.tryParse(_controller.text);
      if (number != null) {
        final formatted = number.toStringAsFixed(1);
        _controller.text = formatted;
        widget.onChanged?.call(formatted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      autofocus: widget.autoFocusField,
      textCapitalization: TextCapitalization.characters,
      keyboardType: widget.textInputType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(labelText: widget.label),
      validator: (value) {
        if (widget.validateValue && (value == null || value.isEmpty)) {
          return '${widget.label} is required';
        }
        return null;
      },
      onSaved: (value) {
        _formatDecimalValue();
        widget.onSaved?.call(value);
      },
      onChanged: widget.onChanged,
      onFieldSubmitted: (value) {
        _formatDecimalValue();
        widget.onSubmitted?.call();
      },
      onTapOutside: (event) {
        _formatDecimalValue();
      },
    );
  }
}
