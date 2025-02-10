import 'package:flutter/material.dart';
import 'package:reportflow/core/widgets/form_input_field.dart';
import 'package:reportflow/core/widgets/info_field.dart';

class PurveyorInfoCard extends StatefulWidget {
  final String waterPurveyor;

  final Function(String) onPurveyorUpdate;

  const PurveyorInfoCard({
    super.key,
    required this.waterPurveyor,
    required this.onPurveyorUpdate,
  });

  @override
  State<PurveyorInfoCard> createState() => _PurveyorInfoCardState();
}

class _PurveyorInfoCardState extends State<PurveyorInfoCard> {
  bool _isEditingPurveyor = false;
  late String _editedPurveyorInfo;

  final _purveyorFormKey = GlobalKey<FormState>();
  final _purveyorFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _editedPurveyorInfo = widget.waterPurveyor;
  }

  @override
  void didUpdateWidget(PurveyorInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.waterPurveyor != widget.waterPurveyor) {
      _editedPurveyorInfo = widget.waterPurveyor;
    }
  }

  @override
  void dispose() {
    _purveyorFocus.dispose();
    super.dispose();
  }

  void _togglePurveyorEdit() {
    setState(() {
      _isEditingPurveyor = !_isEditingPurveyor;
      if (!_isEditingPurveyor) {
        _editedPurveyorInfo = widget.waterPurveyor;
      }
    });
  }

  void _savePurveyorInfo() {
    if (_purveyorFormKey.currentState?.validate() ?? false) {
      _purveyorFormKey.currentState?.save();
      final updatedInfo = _editedPurveyorInfo;
      widget.onPurveyorUpdate(updatedInfo);
      _togglePurveyorEdit();
    } else {
      _purveyorFocus.requestFocus();
    }
  }

  Widget _buildPurveyorTile(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Water Purveyor',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            if (!expanded && _isEditingPurveyor) {
              _isEditingPurveyor = false;
              _editedPurveyorInfo = widget.waterPurveyor;
            }
          });
        },
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _isEditingPurveyor
                ? _buildPurveyorForm()
                : _buildPurveyorInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPurveyorForm() {
    return Form(
      key: _purveyorFormKey,
      child: Column(
        children: [
          FormInputField(
            label: 'Name',
            initialValue: _editedPurveyorInfo,
            validateValue: true,
            focusNode: _purveyorFocus,
            onSaved: (value) => _editedPurveyorInfo = value ?? '',
            onSubmitted: () => _savePurveyorInfo(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _togglePurveyorEdit,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _savePurveyorInfo,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurveyorInfo(BuildContext context) {
    final info = widget.waterPurveyor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoField(label: 'Water Purveyor', value: info),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _togglePurveyorEdit,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPurveyorTile(context),
      ],
    );
  }
}
