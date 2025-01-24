import 'dart:convert';

import 'package:report_flow/core/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  static const _keyProfiles = 'profiles';

  Future<List<Profile>> getProfiles() async {
    final profilesJson = await _getProfilesJson();
    if (profilesJson.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(profilesJson);
      return decoded.map((json) => Profile.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveProfile(Profile profile) async {
    final profiles = await getProfiles();
    profiles.add(profile);
    await _saveProfiles(profiles);
  }

  Future<void> updateProfile(Profile profile) async {
    final profiles = await getProfiles();
    final index = profiles.indexWhere((p) => p.id == profile.id);

    if (index != -1) {
      profiles[index] = profile;
      await _saveProfiles(profiles);
    }
  }

  Future<void> deleteProfile(String id) async {
    final profiles = await getProfiles();
    profiles.removeWhere((p) => p.id == id);
    await _saveProfiles(profiles);
  }

  Future<void> _saveProfiles(List<Profile> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    final profilesJson = profiles.map((p) => p.toJson()).toList();
    await prefs.setString(_keyProfiles, jsonEncode(profilesJson));
  }

  Future<String> _getProfilesJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfiles) ?? '';
  }
}
