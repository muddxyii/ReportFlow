import 'package:flutter/foundation.dart';

class SettingsViewModel extends ChangeNotifier {
  String _testerName = '';
  String _testKitSerial = '';
  String _testCertNo = '';
  String _repairCertNo = '';

  // Getters
  String get testerName => _testerName;
  String get testKitSerial => _testKitSerial;
  String get testCertNo => _testCertNo;
  String get repairCertNo => _repairCertNo;
  String get appNameWithVersion => 'ReportFlow v2.0.0';
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

  Future<void> save() async {
    // Implement save logic
  }
}
