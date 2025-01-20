import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile.dart';
import 'settings_viewmodel.dart';

class TesterProfiles extends StatelessWidget {
  const TesterProfiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, viewModel, _) => Column(
        children: [
          if (viewModel.profiles.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('No profiles yet. Add one to get started.'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.profiles.length,
              itemBuilder: (context, index) {
                final profile = viewModel.profiles[index];
                return ProfileCard(profile: profile);
              },
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context, viewModel),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text('Add Profile'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => ProfileEditDialog(
        onSave: (profile) async {
          await viewModel.addProfile(profile);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile added successfully')),
            );
          }
        },
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SettingsViewModel>();

    return Card(
      child: ListTile(
        title: Text(profile.profileName.isEmpty ? 'Unnamed Profile' : profile.profileName),
        subtitle: Text(profile.testerName.isEmpty ? 'No Tester Name' : profile.testerName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(context, viewModel),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => ProfileEditDialog(
        profile: profile,
        onSave: (updated) async {
          await viewModel.updateProfile(updated);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text('Are you sure you want to delete ${profile.testerName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await viewModel.deleteProfile(profile.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile deleted')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

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
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _testerNameController.dispose();
    _serialController.dispose();
    _testCertController.dispose();
    _repairCertController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
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
                decoration: const InputDecoration(labelText: 'Profile Name'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter profile name' : null,
              ),
              TextFormField(
                controller: _testerNameController,
                decoration: const InputDecoration(labelText: 'Tester Name'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter tester name' : null,
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
          onPressed: _handleSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}