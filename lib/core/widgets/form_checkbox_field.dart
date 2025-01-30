import 'package:flutter/material.dart';

class FormCheckboxField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final double scale;

  const FormCheckboxField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.scale = 1.5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: scale,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ),
        GestureDetector(
          onTap: () => onChanged?.call(!value),
          child: Text(label),
        ),
      ],
    );
  }
}
