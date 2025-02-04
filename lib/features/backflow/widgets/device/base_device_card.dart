import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

abstract class BaseDeviceCard extends StatefulWidget {
  final DeviceInfo info;
  final Function(DeviceInfo) onInfoUpdate;
  final String title;

  const BaseDeviceCard({
    super.key,
    required this.info,
    required this.onInfoUpdate,
    required this.title,
  });
}

abstract class BaseDeviceCardState<T extends BaseDeviceCard> extends State<T> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final List<FocusNode> _focusNodes = [];
  late DeviceInfo _editedInfo;

  @override
  void initState() {
    super.initState();
    _editedInfo = widget.info;
  }

  void addFocusNodes(List<FocusNode> nodes) {
    for (final node in nodes) {
      _focusNodes.add(node);
    }
  }

  @override
  void dispose() {
    if (_focusNodes.isNotEmpty) {
      for (final node in _focusNodes) {
        node.dispose();
      }
    }
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

  void _focusFirstInvalid() {
    for (final node in _focusNodes.reversed) {
      final nodeField =
          node.context?.findAncestorWidgetOfExactType<TextFormField>();
      if (nodeField?.controller?.text.isEmpty ?? true) {
        node.requestFocus();
      }
    }
  }

  void saveInfo() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onInfoUpdate(_editedInfo);
      _toggleEdit();
    }

    _focusFirstInvalid();
  }

  Widget buildForm();

  Widget buildInfo();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onExpansionChanged: (expanded) {
          if (!expanded && _isEditing) {
            setState(() {
              _isEditing = false;
              _editedInfo = widget.info;
            });
          }
        },
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isEditing ? buildForm() : buildInfo(),
                if (!_isEditing)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _toggleEdit,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: _toggleEdit, child: const Text('Cancel')),
        ElevatedButton(onPressed: saveInfo, child: const Text('Save')),
      ],
    );
  }

  GlobalKey<FormState> get formKey => _formKey;

  bool get isEditing => _isEditing;

  DeviceInfo get editedInfo => _editedInfo;

  set editedInfo(DeviceInfo value) => _editedInfo = value;
}
