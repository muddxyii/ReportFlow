import 'package:flutter/material.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/core/widgets/form_input_field.dart';
import 'package:reportflow/core/widgets/info_field.dart';

class LocationInfoCard extends StatefulWidget {
  final LocationInfo info;

  final Function(LocationInfo) onInfoUpdate;

  const LocationInfoCard({
    super.key,
    required this.info,
    required this.onInfoUpdate,
  });

  @override
  State<LocationInfoCard> createState() => _LocationInfoCardState();
}

class _LocationInfoCardState extends State<LocationInfoCard> {
  bool _isEditing = false;
  bool _isExpanded = false;

  final _formKey = GlobalKey<FormState>();

  final _assemblyAddressFocus = FocusNode();
  final _onSiteLocationFocus = FocusNode();
  final _primaryServiceFocus = FocusNode();

  late LocationInfo _editedInfo;

  @override
  void initState() {
    super.initState();
    _editedInfo = widget.info;
  }

  @override
  void didUpdateWidget(LocationInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      _editedInfo = widget.info;
    }
  }

  @override
  void dispose() {
    _assemblyAddressFocus.dispose();
    _onSiteLocationFocus.dispose();
    _primaryServiceFocus.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _editedInfo = widget.info;
      }
    });
  }

  void _saveInfo() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onInfoUpdate(_editedInfo);
      _toggleEdit();
    } else {
      if (_editedInfo.assemblyAddress.isEmpty) {
        _assemblyAddressFocus.requestFocus();
      } else if (_editedInfo.onSiteLocation.isEmpty) {
        _onSiteLocationFocus.requestFocus();
      } else {
        _primaryServiceFocus.requestFocus();
      }
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormInputField(
            label: 'Assembly Address',
            textInputType: TextInputType.streetAddress,
            initialValue: _editedInfo.assemblyAddress,
            validateValue: true,
            focusNode: _assemblyAddressFocus,
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              assemblyAddress: value ?? '',
            ),
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(_onSiteLocationFocus),
          ),
          FormInputField(
            label: 'On-site Location',
            initialValue: _editedInfo.onSiteLocation,
            validateValue: true,
            focusNode: _onSiteLocationFocus,
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              onSiteLocation: value ?? '',
            ),
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(_primaryServiceFocus),
          ),
          FormInputField(
            label: 'Primary Service',
            textInputAction: TextInputAction.done,
            initialValue: _editedInfo.primaryService,
            validateValue: true,
            focusNode: _primaryServiceFocus,
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              primaryService: value ?? '',
            ),
            onSubmitted: () => _saveInfo(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleEdit,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveInfo,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoField(
            label: 'Assembly Address', value: widget.info.assemblyAddress),
        InfoField(label: 'On-site Location', value: widget.info.onSiteLocation),
        InfoField(label: 'Primary Service', value: widget.info.primaryService),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleEdit,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Location',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
            if (!expanded && _isEditing) {
              _isEditing = false;
              _editedInfo = widget.info;
            }
          });
        },
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _isEditing ? _buildForm() : _buildInfo(),
          ),
        ],
      ),
    );
  }
}
