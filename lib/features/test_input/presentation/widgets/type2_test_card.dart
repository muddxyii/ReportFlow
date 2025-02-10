import 'package:flutter/material.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/core/widgets/form_checkbox_field.dart';
import 'package:reportflow/core/widgets/form_input_field.dart';

class Type2TestCard extends StatefulWidget {
  final Test test;
  final Function(Test) onTestUpdated;
  final Function(String, FocusNode) addFocusNode;

  const Type2TestCard({
    super.key,
    required this.test,
    required this.onTestUpdated,
    required this.addFocusNode,
  });

  @override
  State<Type2TestCard> createState() => _Type2TestCardState();
}

class _Type2TestCardState extends State<Type2TestCard> {
  final Map<String, FocusNode> _focusNodes = {};
  final List<String> _focusOrder = ['cv1Value'];

  @override
  void initState() {
    super.initState();
    for (var key in _focusOrder) {
      _focusNodes[key] = FocusNode();
      widget.addFocusNode(key, _focusNodes[key]!);
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleFieldSubmitted(String currentKey) {
    final currentIndex = _focusOrder.indexOf(currentKey);
    if (currentIndex < _focusOrder.length - 1) {
      _focusNodes[_focusOrder[currentIndex + 1]]?.requestFocus();
    }
  }

  Widget _buildCheckValveSection(
    BuildContext context,
    String title,
    CheckValve checkValve,
    String focusKey,
    Function(CheckValve) onValveUpdated,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        FormInputField(
          label: 'Pressure Reading',
          focusNode: _focusNodes[focusKey],
          textInputType: TextInputType.number,
          validateValue: true,
          formatDecimal: true,
          onChanged: (value) {
            onValveUpdated(checkValve.copyWith(value: value ?? ''));
          },
          onSubmitted: () => _handleFieldSubmitted(focusKey),
        ),
        const SizedBox(height: 8),
        FormCheckboxField(
          label: 'Closed Tight',
          value: checkValve.closedTight,
          onChanged: (value) {
            onValveUpdated(checkValve.copyWith(closedTight: value ?? false));
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckValveSection(
          context,
          'Check Valve #1',
          widget.test.checkValve1,
          'cv1Value',
          (valve) =>
              widget.onTestUpdated(widget.test.copyWith(checkValve1: valve)),
        ),
      ],
    );
  }
}
