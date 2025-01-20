import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsViewModel extends ChangeNotifier {
  String _testerName = '';
  String _testKitSerial = '';
  String _testCertNo = '';
  String _repairCertNo = '';
  String _appNameWithVersion = 'ReportFlow';

  SettingsViewModel() {
    _initializeAppNameWithVersion();
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
    // Implement save logic
  }
}
