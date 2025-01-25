import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

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
  bool _isEditing = false;
  bool _isExpanded = false;

  final _formKey = GlobalKey<FormState>();

  final _permitFocus = FocusNode();
  final _meterFocus = FocusNode();
  final _serialFocus = FocusNode();
  final _typeFocus = FocusNode();
  final _manufacturerFocus = FocusNode();
  final _sizeFocus = FocusNode();
  final _modelFocus = FocusNode();
  final _valveStatusFocus = FocusNode();
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
    _typeFocus.dispose();
    _manufacturerFocus.dispose();
    _sizeFocus.dispose();
    _modelFocus.dispose();
    _valveStatusFocus.dispose();
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
          TextFormField(
            focusNode: _permitFocus,
            initialValue: _editedInfo.permitNo,
            decoration: const InputDecoration(labelText: 'Permit Number'),
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(permitNo: value ?? ''),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_meterFocus),
          ),
          TextFormField(
            focusNode: _meterFocus,
            initialValue: _editedInfo.meterNo,
            decoration: const InputDecoration(labelText: 'Meter Number'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(meterNo: value ?? ''),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_serialFocus),
          ),
          TextFormField(
            focusNode: _serialFocus,
            initialValue: _editedInfo.serialNo,
            decoration: const InputDecoration(labelText: 'Serial Number'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(serialNo: value ?? ''),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_typeFocus),
          ),
          TextFormField(
            focusNode: _typeFocus,
            initialValue: _editedInfo.type,
            decoration: const InputDecoration(labelText: 'Type'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(type: value ?? ''),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_manufacturerFocus),
          ),
          TextFormField(
            focusNode: _manufacturerFocus,
            initialValue: _editedInfo.manufacturer,
            decoration: const InputDecoration(labelText: 'Manufacturer'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(manufacturer: value ?? ''),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_sizeFocus),
          ),
          TextFormField(
            focusNode: _sizeFocus,
            initialValue: _editedInfo.size,
            decoration: const InputDecoration(labelText: 'Size'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(size: value ?? ''),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_modelFocus),
          ),
          TextFormField(
            focusNode: _modelFocus,
            initialValue: _editedInfo.modelNo,
            decoration: const InputDecoration(labelText: 'Model Number'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            onSaved: (value) =>
                _editedInfo = _editedInfo.copyWith(modelNo: value ?? ''),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_valveStatusFocus),
          ),
          const SizedBox(height: 16),
          const Text('Shutoff Valves:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            focusNode: _valveStatusFocus,
            initialValue: _editedInfo.shutoffValves.status,
            decoration: const InputDecoration(labelText: 'Status'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              shutoffValves:
                  _editedInfo.shutoffValves.copyWith(status: value ?? ''),
            ),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_valveCommentFocus),
          ),
          TextFormField(
            focusNode: _valveCommentFocus,
            initialValue: _editedInfo.shutoffValves.comment,
            decoration: const InputDecoration(labelText: 'Comment'),
            onSaved: (value) => _editedInfo = _editedInfo.copyWith(
              shutoffValves:
                  _editedInfo.shutoffValves.copyWith(comment: value ?? ''),
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
        Text('Permit Number: ${widget.info.permitNo}'),
        Text('Meter Number: ${widget.info.meterNo}'),
        Text('Serial Number: ${widget.info.serialNo}'),
        Text('Type: ${widget.info.type}'),
        Text('Manufacturer: ${widget.info.manufacturer}'),
        Text('Size: ${widget.info.size}'),
        Text('Model Number: ${widget.info.modelNo}'),
        const SizedBox(height: 16),
        const Text('Shutoff Valves:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Status: ${widget.info.shutoffValves.status}'),
        Text('Comment: ${widget.info.shutoffValves.comment}'),
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
          'Device Information',
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
