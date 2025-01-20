import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  static const _keyTesterName = 'testerName';
  static const _keyTestKitSerial = 'testKitSerial';
  static const _keyTestCertNo = 'testCertNo';
  static const _keyRepairCertNo = 'repairCertNo';

  String _testerName = '';
  String _testKitSerial = '';
  String _testCertNo = '';
  String _repairCertNo = '';

  String _appNameWithVersion = 'ReportFlow';

  SettingsViewModel() {
    _initializeAppNameWithVersion();
    load();
  }

  // Getters
  String get testerName => _testerName;
  String get testKitSerial => _testKitSerial;
  String get testCertNo => _testCertNo;
  String get repairCertNo => _repairCertNo;
  String get appNameWithVersion => _appNameWithVersion;
  String get companyCopyright => '© 2024-${DateTime.now().year} AnyBackflow';

  // Setters with notification
  set testerName(String value) {
    _testerName = value;
    notifyListeners();
  }

  set testKitSerial(String value) {
    _testKitSerial = value;
    notifyListeners();
  }

  set testCertNo(String value) {
    _testCertNo = value;
    notifyListeners();
  }

  set repairCertNo(String value) {
    _repairCertNo = value;
    notifyListeners();
  }

  Future<void> _initializeAppNameWithVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appNameWithVersion = 'ReportFlow v${packageInfo.version}';
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTesterName, _testerName);
    await prefs.setString(_keyTestKitSerial, _testKitSerial);
    await prefs.setString(_keyTestCertNo, _testCertNo);
    await prefs.setString(_keyRepairCertNo, _repairCertNo);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _testerName = prefs.getString(_keyTesterName) ?? '';
    _testKitSerial = prefs.getString(_keyTestKitSerial) ?? '';
    _testCertNo = prefs.getString(_keyTestCertNo) ?? '';
    _repairCertNo = prefs.getString(_keyRepairCertNo) ?? '';
    notifyListeners();
  }
}
