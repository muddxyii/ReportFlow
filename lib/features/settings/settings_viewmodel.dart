import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:report_flow/core/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  static const _keyProfiles = 'profiles';
  List<Profile> _profiles = [];
  String _appNameWithVersion = 'ReportFlow';

  SettingsViewModel() {
    load();
  }

  // Getters
  String get appNameWithVersion => _appNameWithVersion;

  String get companyCopyright => '© 2024-${DateTime.now().year} AnyBackflow';

  get profiles => _profiles;

  Future<void> _initializeAppNameWithVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appNameWithVersion = 'ReportFlow v${packageInfo.version}';
    notifyListeners();
  }

  Future<void> addProfile(Profile profile) async {
    _profiles.add(profile);
    await _saveProfiles();
    notifyListeners();
  }

  Future<void> updateProfile(Profile profile) async {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
      await _saveProfiles();
      notifyListeners();
    }
  }

  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    await _saveProfiles();
    notifyListeners();
  }

  Future<void> _saveProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final profilesJson = _profiles.map((p) => p.toJson()).toList();
    await prefs.setString(_keyProfiles, jsonEncode(profilesJson));
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final profilesJson = prefs.getString(_keyProfiles);
    if (profilesJson != null) {
      final List<dynamic> decoded = jsonDecode(profilesJson);
      _profiles = decoded.map((json) => Profile.fromJson(json)).toList();
      notifyListeners();
    }
    await _initializeAppNameWithVersion();
  }
}
