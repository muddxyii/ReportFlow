import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_viewmodel.dart';

class TesterProfile extends StatelessWidget {
  const TesterProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<SettingsViewModel>(
        builder: (context, viewModel, _) => ListTile(
          title: Text(viewModel.testerName.isEmpty ? 'Profile 1' : viewModel.testerName),
          subtitle: Text('Kit: ${viewModel.testKitSerial}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(context, viewModel),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Handle delete
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => TesterProfileEditDialog(viewModel: viewModel),
    );
  }
}

class TesterProfileEditDialog extends StatefulWidget {
  final SettingsViewModel viewModel;

  const TesterProfileEditDialog({
    required this.viewModel,
    super.key,
  });

  @override
  State<TesterProfileEditDialog> createState() => _TesterProfileEditDialogState();
}

class _TesterProfileEditDialogState extends State<TesterProfileEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _serialController;
  late final TextEditingController _testCertController;
  late final TextEditingController _repairCertController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.viewModel.testerName);
    _serialController = TextEditingController(text: widget.viewModel.testKitSerial);
    _testCertController = TextEditingController(text: widget.viewModel.testCertNo);
    _repairCertController = TextEditingController(text: widget.viewModel.repairCertNo);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serialController.dispose();
    _testCertController.dispose();
    _repairCertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tester Name'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter name' : null,
              ),
              TextFormField(
                controller: _serialController,
                decoration: const InputDecoration(labelText: 'Test Kit Serial'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter serial' : null,
              ),
              TextFormField(
                controller: _testCertController,
                decoration: const InputDecoration(labelText: 'Test Cert No.'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter test cert' : null,
              ),
              TextFormField(
                controller: _repairCertController,
                decoration: const InputDecoration(labelText: 'Repair Cert No.'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter repair cert' : null,
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
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              widget.viewModel
                ..testerName = _nameController.text
                ..testKitSerial = _serialController.text
                ..testCertNo = _testCertController.text
                ..repairCertNo = _repairCertController.text
                ..save();

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Profile saved')
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}