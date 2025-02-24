import 'package:flutter/material.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/core/widgets/form_dropdown_field.dart';
import 'package:reportflow/core/widgets/info_field.dart';

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
  static const List<String> _protectionTypes = ['Secondary', 'Primary'];
  static const List<String> _serviceTypes = ['Domestic', 'Irrigation', 'Fire'];
  static const List<String> _statusTypes = [
    'Existing',
    'New',
    'Replacement',
    'Missing'
  ];

  bool _isEditing = false;
  bool _isExpanded = false;
  final _formKey = GlobalKey<FormState>();
  late InstallationInfo _editedInfo;

  @override
  void initState() {
    super.initState();
    _editedInfo = _validateInitialInfo(widget.info);
  }

  @override
  void didUpdateWidget(InstallationInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      _editedInfo = _validateInitialInfo(widget.info);
    }
  }

  InstallationInfo _validateInitialInfo(InstallationInfo info) {
    return InstallationInfo(
      status: _validateStatus(info.status),
      protectionType: _validateProtectionType(info.protectionType),
      serviceType: _validateServiceType(info.serviceType),
    );
  }

  String _validateStatus(String status) {
    return _statusTypes.firstWhere(
      (type) => type.toLowerCase() == status.toLowerCase(),
      orElse: () => '',
    );
  }

  String _validateProtectionType(String type) {
    final firstWord = type.split(' ')[0].toUpperCase();
    return _protectionTypes.firstWhere(
      (t) => t.toUpperCase() == firstWord,
      orElse: () => '',
    );
  }

  String _validateServiceType(String type) {
    return _serviceTypes.firstWhere(
      (t) => t.toLowerCase() == type.toLowerCase(),
      orElse: () => '',
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _editedInfo = _validateInitialInfo(widget.info);
      }
    });
  }

  void _saveInfo() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onInfoUpdate(_editedInfo);
      _toggleEdit();
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormDropdownField(
            label: 'Status',
            value: _editedInfo.status.isEmpty ? null : _editedInfo.status,
            items: _statusTypes,
            onChanged: (value) {
              setState(() {
                _editedInfo = _editedInfo.copyWith(status: value ?? '');
              });
            },
          ),
          FormDropdownField(
            label: 'Protection Type',
            value: _editedInfo.protectionType.isEmpty
                ? null
                : _editedInfo.protectionType,
            items: _protectionTypes,
            onChanged: (value) {
              setState(() {
                _editedInfo = _editedInfo.copyWith(protectionType: value ?? '');
              });
            },
          ),
          FormDropdownField(
            label: 'Service Type',
            value: _editedInfo.serviceType.isEmpty
                ? null
                : _editedInfo.serviceType,
            items: _serviceTypes,
            onChanged: (value) {
              setState(() {
                _editedInfo = _editedInfo.copyWith(serviceType: value ?? '');
              });
            },
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
        InfoField(label: 'Status', value: widget.info.status),
        InfoField(label: 'Protection Type', value: widget.info.protectionType),
        InfoField(label: 'Service Type', value: widget.info.serviceType),
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
          'Installation',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
            if (!expanded && _isEditing) {
              _isEditing = false;
              _editedInfo = _validateInitialInfo(widget.info);
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
