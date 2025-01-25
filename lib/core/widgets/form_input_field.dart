import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool validateValue;
  final void Function(String?)? onSaved;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;

  /// A form input field that provides:
  /// - Optional validation for empty fields (disabled by default)
  /// - Character capitalization
  /// - Keyboard type and action customization
  /// - Focus node support
  /// - Form submission handling
  const FormInputField({
    required this.label,
    required this.initialValue,
    this.validateValue = false,
    this.onSaved,
    this.focusNode,
    this.textInputType,
    this.textInputAction,
    this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      initialValue: initialValue,
      textCapitalization: TextCapitalization.characters,
      keyboardType: textInputType ?? TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.next,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (validateValue && (value == null || value.isEmpty)) {
          return '$label is required';
        }
        return null;
      },
      onSaved: onSaved,
      onFieldSubmitted: (_) => onSubmitted?.call(),
    );
  }
}
