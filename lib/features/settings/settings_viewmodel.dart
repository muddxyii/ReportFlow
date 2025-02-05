import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:report_flow/core/data/profile_repository.dart';
import 'package:report_flow/core/models/profile.dart';

class SettingsViewModel extends ChangeNotifier {
  final _profileRepository = ProfileRepository();
  List<Profile> _profiles = [];
  String _appNameWithVersion = 'ReportFlow';

  SettingsViewModel() {
    load();
  }

  // Getters
  String get appNameWithVersion => _appNameWithVersion;

  String get companyCopyright => '© 2024-${DateTime.now().year} AnyBackflow';

  get profiles => _profiles;

  get profileCount => _profiles.length + 1;

  Future<void> _initializeAppNameWithVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appNameWithVersion = 'ReportFlow v${packageInfo.version}';
    notifyListeners();
  }

  Future<void> addProfile(Profile profile) async {
    await _profileRepository.saveProfile(profile);
    await _loadProfiles();
  }

  Future<void> updateProfile(Profile profile) async {
    await _profileRepository.updateProfile(profile);
    await _loadProfiles();
  }

  Future<void> deleteProfile(String id) async {
    await _profileRepository.deleteProfile(id);
    await _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    _profiles = await _profileRepository.getProfiles();
    notifyListeners();
  }

  Future<void> load() async {
    await _loadProfiles();
    await _initializeAppNameWithVersion();
  }
}
