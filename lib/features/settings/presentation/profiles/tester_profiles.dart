import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reportflow/features/settings/presentation/profiles/profile_card.dart';
import 'package:reportflow/features/settings/presentation/profiles/profit_edit_dialog.dart';
import 'package:reportflow/features/settings/settings_viewmodel.dart';

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
        profileCount: viewModel.profileCount.toString(),
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
