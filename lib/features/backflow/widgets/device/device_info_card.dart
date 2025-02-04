import 'package:flutter/material.dart';
import 'package:report_flow/core/widgets/form_dropdown_field.dart';
import 'package:report_flow/core/widgets/form_input_field.dart';
import 'package:report_flow/core/widgets/info_field.dart';
import 'package:report_flow/features/backflow/widgets/device/base_device_card.dart';

class DeviceInfoCard extends BaseDeviceCard {
  const DeviceInfoCard({
    super.key,
    required super.info,
    required super.onInfoUpdate,
  }) : super(title: 'Device');

  @override
  State<DeviceInfoCard> createState() => _DeviceInfoCardState();
}

class _DeviceInfoCardState extends BaseDeviceCardState<DeviceInfoCard> {
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

  final _serialFocus = FocusNode();
  final _sizeFocus = FocusNode();
  final _modelFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    addFocusNodes([_serialFocus, _sizeFocus, _modelFocus]);
  }

  @override
  void dispose() {
    _serialFocus.dispose();
    _sizeFocus.dispose();
    _modelFocus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DeviceInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      editedInfo = widget.info;
    }
  }

  @override
  Widget buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputField(
            label: 'Serial Number',
            initialValue: editedInfo.serialNo,
            validateValue: true,
            focusNode: _serialFocus,
            onSaved: (value) =>
                editedInfo = editedInfo.copyWith(serialNo: value ?? ''),
          ),
          SizedBox(height: 36),
          FormDropdownField(
              label: 'Type',
              value: editedInfo.type.isEmpty ? null : editedInfo.type,
              items: _typeOptions,
              onChanged: (value) {
                setState(() {
                  editedInfo = editedInfo.copyWith(type: value ?? '');
                });
              }),
          FormDropdownField(
              label: 'Manufacturer',
              value: editedInfo.manufacturer.isEmpty
                  ? null
                  : editedInfo.manufacturer,
              items: _manuOptions,
              onChanged: (value) {
                setState(() {
                  editedInfo = editedInfo.copyWith(manufacturer: value ?? '');
                });
              }),
          FormInputField(
            label: 'Size',
            initialValue: editedInfo.size,
            validateValue: true,
            focusNode: _sizeFocus,
            onSaved: (value) =>
                editedInfo = editedInfo.copyWith(size: value ?? ''),
            onSubmitted: () => FocusScope.of(context).requestFocus(_modelFocus),
          ),
          FormInputField(
            label: 'Model Number',
            initialValue: editedInfo.modelNo,
            validateValue: true,
            focusNode: _modelFocus,
            onSaved: (value) =>
                editedInfo = editedInfo.copyWith(modelNo: value ?? ''),
          ),
          buildActionButtons(),
        ],
      ),
    );
  }

  @override
  Widget buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoField(label: 'Serial Number', value: widget.info.serialNo),
        InfoField(label: 'Type', value: widget.info.type),
        InfoField(label: 'Manufacturer', value: widget.info.manufacturer),
        InfoField(label: 'Size', value: widget.info.size),
        InfoField(label: 'Model Number', value: widget.info.modelNo),
      ],
    );
  }
}
