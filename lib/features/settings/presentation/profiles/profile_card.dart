import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_flow/core/models/profile.dart';
import 'package:report_flow/features/settings/presentation/profiles/profit_edit_dialog.dart';
import 'package:report_flow/features/settings/settings_viewmodel.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SettingsViewModel>();

    return Card(
      child: ListTile(
        title: Text(profile.profileName.isEmpty
            ? 'Unnamed Profile'
            : profile.profileName),
        subtitle: Text(
            profile.testerName.isEmpty ? 'No Tester Name' : profile.testerName),
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
