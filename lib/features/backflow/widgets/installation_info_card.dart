import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class InstallationInfoCard extends StatefulWidget {
  final InstallationInfo info;
  final Function(InstallationInfo) onInfoUpdate;

  const InstallationInfoCard({
    super.key,
    required this.info,
    required this.onInfoUpdate,
  });

  @override
  State<InstallationInfoCard> createState() => _InstallationInfoCardState();
}

class _InstallationInfoCardState extends State<InstallationInfoCard> {
  bool _isEditing = false;
  bool _isExpanded = false;

  final _formKey = GlobalKey<FormState>();

  final _statusFocus = FocusNode();
  final _protectionTypeFocus = FocusNode();
  final _serviceTypeFocus = FocusNode();

  late InstallationInfo _editedInfo;

  @override
  void initState() {
    super.initState();
    _editedInfo = widget.info;
  }

  @override
  void didUpdateWidget(InstallationInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      _editedInfo = widget.info;
    }
  }

  @override
  void dispose() {
    _statusFocus.dispose();
    _protectionTypeFocus.dispose();
    _serviceTypeFocus.dispose();
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
      if (_editedInfo.status.isEmpty) {
        _statusFocus.requestFocus();
      } else if (_editedInfo.protectionType.isEmpty) {
        _protectionTypeFocus.requestFocus();
      } else {
        _serviceTypeFocus.requestFocus();
      }
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: _statusFocus,
            initialValue: _editedInfo.status,
            decoration: const InputDecoration(labelText: 'Status'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Status is required' : null,
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              status: value ?? '',
            ),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_protectionTypeFocus),
          ),
          TextFormField(
            focusNode: _protectionTypeFocus,
            initialValue: _editedInfo.protectionType,
            decoration: const InputDecoration(labelText: 'Protection Type'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Protection type is required' : null,
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              protectionType: value ?? '',
            ),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_serviceTypeFocus),
          ),
          TextFormField(
            focusNode: _serviceTypeFocus,
            initialValue: _editedInfo.serviceType,
            decoration: const InputDecoration(labelText: 'Service Type'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Service type is required' : null,
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              serviceType: value ?? '',
            ),
            onFieldSubmitted: (_) => _saveInfo(),
          ),
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
        Text('Status: ${widget.info.status}'),
        Text('Protection Type: ${widget.info.protectionType}'),
        Text('Service Type: ${widget.info.serviceType}'),
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
          'Installation Information',
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
