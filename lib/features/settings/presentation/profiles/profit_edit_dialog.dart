import 'package:flutter/material.dart';
import 'package:report_flow/core/models/profile.dart';

class ProfileEditDialog extends StatefulWidget {
  final Profile? profile;
  final Future<void> Function(Profile) onSave;

  const ProfileEditDialog({
    this.profile,
    required this.onSave,
    super.key,
  });

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final _formKey = GlobalKey<FormState>();

  // Focus Nodes
  final _profileNameFocus = FocusNode();
  final _testerNameFocus = FocusNode();
  final _serialFocus = FocusNode();
  final _testCertFocus = FocusNode();
  final _repairCertFocus = FocusNode();

  // Text Controllers
  late final TextEditingController _profileNameController;
  late final TextEditingController _testerNameController;
  late final TextEditingController _serialController;
  late final TextEditingController _testCertController;
  late final TextEditingController _repairCertController;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile ?? Profile();
    _profileNameController = TextEditingController(text: profile.profileName);
    _testerNameController = TextEditingController(text: profile.testerName);
    _serialController = TextEditingController(text: profile.testKitSerial);
    _testCertController = TextEditingController(text: profile.testCertNo);
    _repairCertController = TextEditingController(text: profile.repairCertNo);

    if (widget.profile == null) {
      _profileNameFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    _profileNameFocus.dispose();
    _testerNameFocus.dispose();
    _serialFocus.dispose();
    _testCertFocus.dispose();
    _repairCertFocus.dispose();

    _profileNameController.dispose();
    _testerNameController.dispose();
    _serialController.dispose();
    _testCertController.dispose();
    _repairCertController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      for (var field in [
        (_profileNameController.text, _profileNameFocus),
        (_testerNameController.text, _testerNameFocus),
        (_serialController.text, _serialFocus),
        (_testCertController.text, _testCertFocus),
        (_repairCertController.text, _repairCertFocus),
      ]) {
        if (field.$1.isEmpty) {
          field.$2.requestFocus();
          break;
        }
      }
      return;
    }

    final profile = Profile(
      id: widget.profile?.id,
      profileName: _profileNameController.text,
      testerName: _testerNameController.text,
      testKitSerial: _serialController.text,
      testCertNo: _testCertController.text,
      repairCertNo: _repairCertController.text,
    );

    await widget.onSave(profile);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.profile == null ? 'Add Profile' : 'Edit Profile'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _profileNameController,
                focusNode: _profileNameFocus,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Profile Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter profile name' : null,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_testerNameFocus),
              ),
              TextFormField(
                controller: _testerNameController,
                focusNode: _testerNameFocus,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Tester Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter tester name' : null,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_serialFocus),
              ),
              TextFormField(
                controller: _serialController,
                focusNode: _serialFocus,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Test Kit Serial'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter serial' : null,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_testCertFocus),
              ),
              TextFormField(
                controller: _testCertController,
                focusNode: _testCertFocus,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Test Cert No.'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter test cert' : null,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_repairCertFocus),
              ),
              TextFormField(
                controller: _repairCertController,
                focusNode: _repairCertFocus,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Repair Cert No.'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter repair cert' : null,
                onFieldSubmitted: (_) => _handleSave(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _handleSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
