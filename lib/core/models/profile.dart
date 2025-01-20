class Profile {
  String id;
  String profileName;
  String testerName;
  String testKitSerial;
  String testCertNo;
  String repairCertNo;

  Profile({
    String? id,
    this.profileName = '',
    this.testerName = '',
    this.testKitSerial = '',
    this.testCertNo = '',
    this.repairCertNo = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
    'id': id,
    'profileName': profileName,
    'testerName': testerName,
    'testKitSerial': testKitSerial,
    'testCertNo': testCertNo,
    'repairCertNo': repairCertNo,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'],
    profileName: json['profileName'] ?? '',
    testerName: json['testerName'],
    testKitSerial: json['testKitSerial'],
    testCertNo: json['testCertNo'],
    repairCertNo: json['repairCertNo'],
  );
}