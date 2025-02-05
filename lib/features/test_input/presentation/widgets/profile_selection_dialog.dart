import 'package:flutter/material.dart';
import 'package:report_flow/core/data/profile_repository.dart';
import 'package:report_flow/core/models/profile.dart';
import 'package:report_flow/core/widgets/info_field.dart';

class ProfileSelectionDialog extends StatefulWidget {
  const ProfileSelectionDialog({super.key});

  @override
  State<ProfileSelectionDialog> createState() => _ProfileSelectionDialogState();
}

class _ProfileSelectionDialogState extends State<ProfileSelectionDialog> {
  final _profileRepository = ProfileRepository();
  Profile? selectedProfile;
  List<Profile>? profiles;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final loadedProfiles = await _profileRepository.getProfiles();
    setState(() => profiles = loadedProfiles);

    if (profiles?.isNotEmpty ?? false) {
      selectedProfile = profiles?.first;
    }
  }

  Widget _getProfileDropdown() {
    return DropdownButtonFormField<Profile>(
      value: selectedProfile,
      items: profiles!.map((profile) {
        return DropdownMenuItem(
          value: profile,
          child: Text(profile.profileName),
        );
      }).toList(),
      onChanged: (profile) => setState(() => selectedProfile = profile),
      decoration: InputDecoration(
        labelText: 'Profile',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _getProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoField(
            label: 'Name',
            value: selectedProfile!.testerName,
          ),
          InfoField(
            label: 'Test Cert No.',
            value: selectedProfile!.testCertNo,
          ),
          InfoField(
            label: 'Gauge Kit No.',
            value: selectedProfile!.testKitSerial,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profiles == null) {
      return const AlertDialog(
        content: Center(child: CircularProgressIndicator()),
      );
    }

    if (profiles!.isEmpty) {
      return AlertDialog(
        title: const Text('No Profiles Found'),
        content: const Text('Please create a profile in Settings first.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Select Profile'),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_getProfileDropdown(), _getProfileInfo()],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: selectedProfile == null
              ? null
              : () => Navigator.pop(context, selectedProfile),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
