import 'package:flutter/material.dart';
import 'package:reportflow/core/widgets/form_dropdown_field.dart';
import 'package:reportflow/core/widgets/form_input_field.dart';
import 'package:reportflow/core/widgets/info_field.dart';
import 'package:reportflow/features/backflow/widgets/device/base_device_card.dart';

class SovInfoCard extends BaseDeviceCard {
  const SovInfoCard({
    super.key,
    required super.info,
    required super.onInfoUpdate,
  }) : super(title: 'Shutoff Valves');

  @override
  State<SovInfoCard> createState() => _SovInfoCardState();
}

class _SovInfoCardState extends BaseDeviceCardState<SovInfoCard> {
  static const List<String> _sovOptions = [
    'BOTH OK',
    'BOTH CLOSED',
    'BOTH VALVES',
    '#1 VALVE',
    '#2 VALVE'
  ];

  final _valveCommentFocus = FocusNode();

  @override
  void dispose() {
    _valveCommentFocus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SovInfoCard oldWidget) {
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
          FormDropdownField(
            label: 'Status',
            value: editedInfo.shutoffValves.status.isEmpty
                ? null
                : editedInfo.shutoffValves.status,
            items: _sovOptions,
            onChanged: (value) {
              setState(() {
                editedInfo = editedInfo.copyWith(
                    shutoffValves:
                        editedInfo.shutoffValves.copyWith(status: value ?? ''));
              });
            },
          ),
          FormInputField(
            label: 'Comment',
            initialValue: editedInfo.shutoffValves.comment,
            focusNode: _valveCommentFocus,
            onSaved: (value) => editedInfo = editedInfo.copyWith(
              shutoffValves:
                  editedInfo.shutoffValves.copyWith(comment: value ?? ''),
            ),
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
        InfoField(label: 'Status', value: widget.info.shutoffValves.status),
        InfoField(
            label: 'Comment',
            value: widget.info.shutoffValves.comment.isEmpty
                ? '...'
                : widget.info.shutoffValves.comment),
      ],
    );
  }
}
