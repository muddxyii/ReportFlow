// profile.dart
class Profile {
  String id;
  String testerName;
  String testKitSerial;
  String testCertNo;
  String repairCertNo;

  Profile({
    String? id,
    this.testerName = '',
    this.testKitSerial = '',
    this.testCertNo = '',
    this.repairCertNo = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
    'id': id,
    'testerName': testerName,
    'testKitSerial': testKitSerial,
    'testCertNo': testCertNo,
    'repairCertNo': repairCertNo,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'],
    testerName: json['testerName'],
    testKitSerial: json['testKitSerial'],
    testCertNo: json['testCertNo'],
    repairCertNo: json['repairCertNo'],
  );
}