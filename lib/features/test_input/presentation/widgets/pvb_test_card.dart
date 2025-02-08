import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/core/widgets/form_checkbox_field.dart';
import 'package:report_flow/core/widgets/form_input_field.dart';

class PvbTestCard extends StatefulWidget {
  final Test test;
  final Function(Test) onTestUpdated;
  final Function(String, FocusNode) addFocusNode;

  const PvbTestCard({
    super.key,
    required this.test,
    required this.onTestUpdated,
    required this.addFocusNode,
  });

  @override
  State<PvbTestCard> createState() => _PvbTestCardState();
}

class _PvbTestCardState extends State<PvbTestCard> {
  final Map<String, FocusNode> _focusNodes = {};
  final List<String> _focusOrder = ['airInletValue', 'ckValue'];

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

  Widget _buildAirInletSection(
    BuildContext context,
    String title,
    AirInlet airInlet,
    String focusKey,
    Function(AirInlet) onAirInletUpdated,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        FormInputField(
          label: 'Opened at',
          focusNode: _focusNodes[focusKey],
          textInputType: TextInputType.number,
          validateValue: true,
          formatDecimal: true,
          onChanged: (value) {
            onAirInletUpdated(airInlet.copyWith(value: value ?? ''));
          },
          onSubmitted: () => _handleFieldSubmitted(focusKey),
        ),
        const SizedBox(height: 8),
        FormCheckboxField(
          label: 'Did Not Open',
          value: !airInlet.opened,
          onChanged: (value) {
            onAirInletUpdated(
              airInlet.copyWith(opened: !(value ?? false)),
            );
          },
        ),
        const SizedBox(height: 8),
        FormCheckboxField(
          label: 'Leaking',
          value: airInlet.leaked,
          onChanged: (value) {
            onAirInletUpdated(airInlet.copyWith(leaked: value ?? false));
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCheckSection(
    BuildContext context,
    String title,
    Check check,
    String focusKey,
    Function(Check) onCheckUpdated,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        FormInputField(
          label: 'Held at',
          focusNode: _focusNodes[focusKey],
          textInputType: TextInputType.number,
          validateValue: true,
          formatDecimal: true,
          onChanged: (value) {
            onCheckUpdated(check.copyWith(value: value ?? ''));
          },
          onSubmitted: () => _handleFieldSubmitted(focusKey),
        ),
        const SizedBox(height: 8),
        FormCheckboxField(
          label: 'Leaking',
          value: check.leaked,
          onChanged: (value) {
            onCheckUpdated(check.copyWith(leaked: value ?? false));
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
        FormCheckboxField(
          label: 'Back Pressure',
          value: widget.test.vacuumBreaker.backPressure,
          onChanged: (value) => widget.onTestUpdated(widget.test.copyWith(
              vacuumBreaker:
                  widget.test.vacuumBreaker.copyWith(backPressure: value))),
        ),
        const SizedBox(height: 16),
        _buildAirInletSection(
          context,
          'Air Inlet',
          widget.test.vacuumBreaker.airInlet,
          'airInletValue',
          (value) => widget.onTestUpdated(widget.test.copyWith(
              vacuumBreaker:
                  widget.test.vacuumBreaker.copyWith(airInlet: value))),
        ),
        _buildCheckSection(
          context,
          'Check',
          widget.test.vacuumBreaker.check,
          'ckValue',
          (value) => widget.onTestUpdated(widget.test.copyWith(
              vacuumBreaker: widget.test.vacuumBreaker.copyWith(check: value))),
        ),
      ],
    );
  }
}
