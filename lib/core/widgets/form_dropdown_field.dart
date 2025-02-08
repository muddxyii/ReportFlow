import 'package:flutter/material.dart';

class FormDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry contentPadding;
  final bool isExpanded;
  final bool isEnabled;

  /// A reusable dropdown form field that provides:
  /// - Consistent styling with other form inputs
  /// - Built-in validation
  /// - Customizable padding
  /// - Optional expansion
  const FormDropdownField({
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.isExpanded = true,
    this.isEnabled = true,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return isEnabled ? _getEnabledDropdown() : _getDisabledDropdown();
  }

  Widget _getEnabledDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        isExpanded: isExpanded,
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: contentPadding,
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.normal,
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        validator: validator ??
            (value) =>
                value == null || value.isEmpty ? '$label is required' : null,
        onChanged: onChanged,
      ),
    );
  }

  Widget _getDisabledDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        isExpanded: isExpanded,
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: contentPadding,
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.normal,
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        disabledHint: Text(value!),
        onChanged: null,
      ),
    );
  }
}
