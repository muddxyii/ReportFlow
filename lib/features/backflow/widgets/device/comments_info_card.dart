import 'package:flutter/material.dart';
import 'package:reportflow/core/widgets/form_input_field.dart';
import 'package:reportflow/core/widgets/info_field.dart';
import 'package:reportflow/features/backflow/widgets/device/base_device_card.dart';

class CommentsInfoCard extends BaseDeviceCard {
  const CommentsInfoCard({
    super.key,
    required super.info,
    required super.onInfoUpdate,
  }) : super(title: 'Comments');

  @override
  State<CommentsInfoCard> createState() => _CommentsInfoCardState();
}

class _CommentsInfoCardState extends BaseDeviceCardState<CommentsInfoCard> {
  final _commentFocus = FocusNode();

  @override
  void dispose() {
    _commentFocus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CommentsInfoCard oldWidget) {
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
            label: 'Old Comments',
            initialValue: editedInfo.oldComments,
            enabled: false,
          ),
          FormInputField(
            label: 'Comments',
            initialValue: editedInfo.comments,
            focusNode: _commentFocus,
            onSaved: (value) => editedInfo = editedInfo.copyWith(
              comments: value ?? '',
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
        InfoField(
            label: 'Old Comments',
            value: widget.info.oldComments.isEmpty
                ? '...'
                : widget.info.oldComments),
        InfoField(
            label: 'Comments',
            value: widget.info.comments.isEmpty ? '...' : widget.info.comments),
      ],
    );
  }
}
