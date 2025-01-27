import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/core/widgets/form_dropdown_field.dart';
import 'package:report_flow/core/widgets/form_input_field.dart';
import 'package:report_flow/core/widgets/info_field.dart';

class DeviceInfoCard extends StatefulWidget {
  final DeviceInfo info;
  final Function(DeviceInfo) onInfoUpdate;

  const DeviceInfoCard({
    super.key,
    required this.info,
    required this.onInfoUpdate,
  });

  @override
  State<DeviceInfoCard> createState() => _DeviceInfoCardState();
}

class _DeviceInfoCardState extends State<DeviceInfoCard> {
  static const List<String> _typeOptions = [
    'DC',
    'RP',
    'PVB',
    'SVB',
    'SC',
    'TYPE 2',
  ];
  static const List<String> _manuOptions = [
    'WATTS',
    'WILKINS',
    'FEBCO',
    'AMES',
    'ARI',
    'APOLLO',
    'CONBRACO',
    'HERSEY',
    'FLOMATIC',
    'BACKFLOW DIRECT'
  ];
  static const List<String> _sovOptions = [
    'BOTH OK',
    'BOTH CLOSED',
    'BOTH VALVES',
    '#1 VALVE',
    '#2 VALVE'
  ];

  bool _isEditing = false;
  bool _isExpanded = false;

  final _formKey = GlobalKey<FormState>();

  final _permitFocus = FocusNode();
  final _meterFocus = FocusNode();
  final _serialFocus = FocusNode();
  final _sizeFocus = FocusNode();
  final _modelFocus = FocusNode();
  final _valveCommentFocus = FocusNode();

  late DeviceInfo _editedInfo;

  @override
  void initState() {
    super.initState();
    _editedInfo = widget.info;
  }

  @override
  void didUpdateWidget(DeviceInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      _editedInfo = widget.info;
    }
  }

  @override
  void dispose() {
    _permitFocus.dispose();
    _meterFocus.dispose();
    _serialFocus.dispose();
    _sizeFocus.dispose();
    _modelFocus.dispose();
    _valveCommentFocus.dispose();
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
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputField(
            label: 'Permit Number',
            initialValue: _editedInfo.permitNo,
            focusNode: _permitFocus,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(permitNo: value ?? ''),
            onSubmitted: () => FocusScope.of(context).requestFocus(_meterFocus),
          ),
          FormInputField(
            label: 'Meter Number',
            initialValue: _editedInfo.meterNo,
            validateValue: true,
            focusNode: _meterFocus,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(meterNo: value ?? ''),
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(_serialFocus),
          ),
          FormInputField(
            label: 'Serial Number',
            initialValue: _editedInfo.serialNo,
            validateValue: true,
            focusNode: _serialFocus,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(serialNo: value ?? ''),
          ),
          SizedBox(height: 36),
          FormDropdownField(
              label: 'Type',
              value: _editedInfo.type.isEmpty ? null : _editedInfo.type,
              items: _typeOptions,
              onChanged: (value) {
                setState(() {
                  _editedInfo = _editedInfo.copyWith(type: value ?? '');
                });
              }),
          FormDropdownField(
              label: 'Manufacturer',
              value: _editedInfo.manufacturer.isEmpty
                  ? null
                  : _editedInfo.manufacturer,
              items: _manuOptions,
              onChanged: (value) {
                setState(() {
                  _editedInfo = _editedInfo.copyWith(manufacturer: value ?? '');
                });
              }),
          FormInputField(
            label: 'Size',
            initialValue: _editedInfo.size,
            validateValue: true,
            focusNode: _sizeFocus,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(size: value ?? ''),
            onSubmitted: () => FocusScope.of(context).requestFocus(_modelFocus),
          ),
          FormInputField(
            label: 'Model Number',
            initialValue: _editedInfo.modelNo,
            validateValue: true,
            focusNode: _modelFocus,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(modelNo: value ?? ''),
          ),
          const SizedBox(height: 20),
          const Text('Shutoff Valves:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          FormDropdownField(
            label: 'Status',
            value: _editedInfo.shutoffValves.status.isEmpty
                ? null
                : _editedInfo.shutoffValves.status,
            items: _sovOptions,
            onChanged: (value) {
              setState(() {
                _editedInfo = _editedInfo.copyWith(
                    shutoffValves: _editedInfo.shutoffValves
                        .copyWith(status: value ?? ''));
              });
            },
          ),
          FormInputField(
            label: 'Comment',
            initialValue: _editedInfo.shutoffValves.comment,
            focusNode: _valveCommentFocus,
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              shutoffValves:
                  _editedInfo.shutoffValves.copyWith(comment: value ?? ''),
            ),
            onSubmitted: () => _saveInfo(),
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
        InfoField(
            label: 'Permit Number',
            value: widget.info.permitNo.isEmpty
                ? 'Unknown'
                : widget.info.permitNo),
        InfoField(label: 'Meter Number', value: widget.info.meterNo),
        InfoField(label: 'Serial Number', value: widget.info.serialNo),
        InfoField(label: 'Type', value: widget.info.type),
        InfoField(label: 'Manufacturer', value: widget.info.manufacturer),
        InfoField(label: 'Size', value: widget.info.size),
        InfoField(label: 'Model Number', value: widget.info.modelNo),
        const SizedBox(height: 16),
        const Text('Shutoff Valves:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        InfoField(label: 'Status', value: widget.info.shutoffValves.status),
        InfoField(
            label: 'Comment',
            value: widget.info.shutoffValves.comment.isEmpty
                ? '...'
                : widget.info.shutoffValves.comment),
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
          'Device',
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
