import 'package:flutter/material.dart';
import 'package:reportflow/core/widgets/form_input_field.dart';
import 'package:reportflow/core/widgets/info_field.dart';
import 'package:reportflow/features/backflow/widgets/device/base_device_card.dart';

class PermitInfoCard extends BaseDeviceCard {
  const PermitInfoCard({
    super.key,
    required super.info,
    required super.onInfoUpdate,
  }) : super(title: 'Permit / Meter');

  @override
  State<PermitInfoCard> createState() => _PermitInfoCardState();
}

class _PermitInfoCardState extends BaseDeviceCardState<PermitInfoCard> {
  final _permitFocus = FocusNode();
  final _meterFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    addFocusNodes([_meterFocus]);
  }

  @override
  void dispose() {
    _permitFocus.dispose();
    _meterFocus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PermitInfoCard oldWidget) {
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
            label: 'Permit Number',
            initialValue: editedInfo.permitNo,
            focusNode: _permitFocus,
            onSaved: (value) =>
                editedInfo = editedInfo.copyWith(permitNo: value ?? ''),
            onSubmitted: () => FocusScope.of(context).requestFocus(_meterFocus),
          ),
          FormInputField(
            label: 'Meter Number',
            initialValue: editedInfo.meterNo,
            validateValue: true,
            textInputAction: TextInputAction.done,
            focusNode: _meterFocus,
            onSaved: (value) =>
                editedInfo = editedInfo.copyWith(meterNo: value ?? ''),
            onSubmitted: () => super.saveInfo(),
          ),
          const SizedBox(height: 16),
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
        InfoField(
            label: 'Permit Number',
            value: widget.info.permitNo.isEmpty
                ? 'Unknown'
                : widget.info.permitNo),
        InfoField(label: 'Meter Number', value: widget.info.meterNo),
      ],
    );
  }
}
