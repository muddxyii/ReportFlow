class Metadata {
  final String jobId;
  final String formatVersion;
  final String creationDate;
  final String lastModifiedDate;

  Metadata({
    required this.jobId,
    required this.formatVersion,
    required this.creationDate,
    required this.lastModifiedDate,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        jobId: json['jobId']?.toString() ?? '',
        formatVersion: json['formatVersion']?.toString() ?? '',
        creationDate: json['creationDate']?.toString() ?? '',
        lastModifiedDate: json['lastModifiedDate']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        'formatVersion': formatVersion,
        'creationDate': creationDate,
        'lastModifiedDate': lastModifiedDate,
      };
}

class JobDetails {
  final String jobName;
  final String jobType;
  final String waterPurveyor;

  JobDetails({
    required this.jobName,
    required this.jobType,
    required this.waterPurveyor,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) => JobDetails(
        jobName: json['jobName']?.toString() ?? '',
        jobType: json['jobType']?.toString() ?? '',
        waterPurveyor: json['waterPurveyor']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'jobType': jobType,
        'jobName': jobName,
        'waterPurveyor': waterPurveyor,
      };
}

//region Customer Information

class FacilityOwnerInfo {
  final String owner;
  final String address;
  final String email;
  final String contact;
  final String phone;

  FacilityOwnerInfo({
    required this.owner,
    required this.address,
    required this.email,
    required this.contact,
    required this.phone,
  });

  factory FacilityOwnerInfo.fromJson(Map<String, dynamic> json) =>
      FacilityOwnerInfo(
        owner: json['owner']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        contact: json['contact']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'owner': owner,
        'address': address,
        'email': email,
        'contact': contact,
        'phone': phone,
      };

  FacilityOwnerInfo copyWith({
    String? owner,
    String? address,
    String? email,
    String? contact,
    String? phone,
  }) {
    return FacilityOwnerInfo(
      owner: owner ?? this.owner,
      address: address ?? this.address,
      email: email ?? this.email,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
    );
  }
}

class RepresentativeInfo {
  final String owner;
  final String address;
  final String contact;
  final String phone;

  RepresentativeInfo({
    required this.owner,
    required this.address,
    required this.contact,
    required this.phone,
  });

  factory RepresentativeInfo.fromJson(Map<String, dynamic> json) =>
      RepresentativeInfo(
        owner: json['owner']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        contact: json['contact']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'owner': owner,
        'address': address,
        'contact': contact,
        'phone': phone,
      };

  RepresentativeInfo copyWith({
    String? owner,
    String? address,
    String? contact,
    String? phone,
  }) {
    return RepresentativeInfo(
      owner: owner ?? this.owner,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
    );
  }
}

class CustomerInformation {
  final FacilityOwnerInfo facilityOwnerInfo;
  final RepresentativeInfo representativeInfo;

  CustomerInformation({
    required this.facilityOwnerInfo,
    required this.representativeInfo,
  });

  factory CustomerInformation.fromJson(Map<String, dynamic> json) =>
      CustomerInformation(
        facilityOwnerInfo:
            FacilityOwnerInfo.fromJson(json['facilityOwnerInfo']),
        representativeInfo:
            RepresentativeInfo.fromJson(json['representativeInfo']),
      );

  Map<String, dynamic> toJson() => {
        'facilityOwnerInfo': facilityOwnerInfo.toJson(),
        'representativeInfo': representativeInfo.toJson(),
      };
}

//endregion

//region Backflow Info

class LocationInfo {
  final String assemblyAddress;
  final String onSiteLocation;
  final String primaryService;

  LocationInfo({
    required this.assemblyAddress,
    required this.onSiteLocation,
    required this.primaryService,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        assemblyAddress: json['assemblyAddress']?.toString() ?? '',
        onSiteLocation: json['onSiteLocation']?.toString() ?? '',
        primaryService: json['primaryService']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'assemblyAddress': assemblyAddress,
        'onSiteLocation': onSiteLocation,
        'primaryService': primaryService,
      };

  LocationInfo copyWith(
      {String? assemblyAddress,
      String? onSiteLocation,
      String? primaryService}) {
    return LocationInfo(
      assemblyAddress: assemblyAddress ?? this.assemblyAddress,
      onSiteLocation: onSiteLocation ?? this.onSiteLocation,
      primaryService: primaryService ?? this.primaryService,
    );
  }
}

class InstallationInfo {
  final String status;
  final String protectionType;
  final String serviceType;

  InstallationInfo({
    required this.status,
    required this.protectionType,
    required this.serviceType,
  });

  factory InstallationInfo.fromJson(Map<String, dynamic> json) =>
      InstallationInfo(
        status: json['status']?.toString() ?? '',
        protectionType: json['protectionType']?.toString() ?? '',
        serviceType: json['serviceType']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'protectionType': protectionType,
        'serviceType': serviceType,
      };

  InstallationInfo copyWith(
      {String? status, String? protectionType, String? serviceType}) {
    return InstallationInfo(
      status: status ?? this.status,
      protectionType: protectionType ?? this.protectionType,
      serviceType: serviceType ?? this.serviceType,
    );
  }
}

class ShutoffValves {
  final String status;
  final String comment;

  ShutoffValves({
    required this.status,
    required this.comment,
  });

  factory ShutoffValves.fromJson(Map<String, dynamic> json) => ShutoffValves(
        status: json['status']?.toString() ?? '',
        comment: json['comment']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'comment': comment,
      };

  ShutoffValves copyWith({String? status, String? comment}) {
    return ShutoffValves(
      status: status ?? this.status,
      comment: comment ?? this.comment,
    );
  }
}

class DeviceInfo {
  final String permitNo;
  final String meterNo;
  final String serialNo;
  final String type;
  final String manufacturer;
  final String size;
  final String modelNo;
  final ShutoffValves shutoffValves;

  DeviceInfo({
    this.permitNo = '',
    this.meterNo = '',
    this.serialNo = '',
    this.type = '',
    this.manufacturer = '',
    this.size = '',
    this.modelNo = '',
    required this.shutoffValves,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
        permitNo: json['permitNo']?.toString() ?? '',
        meterNo: json['meterNo']?.toString() ?? '',
        serialNo: json['serialNo']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        manufacturer: json['manufacturer']?.toString() ?? '',
        size: json['size']?.toString() ?? '',
        modelNo: json['modelNo']?.toString() ?? '',
        shutoffValves: ShutoffValves.fromJson(json['shutoffValves']),
      );

  Map<String, dynamic> toJson() => {
        'permitNo': permitNo,
        'meterNo': meterNo,
        'serialNo': serialNo,
        'type': type,
        'manufacturer': manufacturer,
        'size': size,
        'modelNo': modelNo,
        'shutoffValves': shutoffValves.toJson(),
      };

  DeviceInfo copyWith(
      {String? permitNo,
      String? meterNo,
      String? serialNo,
      String? type,
      String? manufacturer,
      String? size,
      String? modelNo,
      ShutoffValves? shutoffValves}) {
    return DeviceInfo(
        permitNo: permitNo ?? this.permitNo,
        meterNo: meterNo ?? this.meterNo,
        serialNo: serialNo ?? this.serialNo,
        type: type ?? this.type,
        manufacturer: manufacturer ?? this.manufacturer,
        size: size ?? this.size,
        modelNo: modelNo ?? this.modelNo,
        shutoffValves: shutoffValves ?? this.shutoffValves);
  }
}

//endregion

//region Test Points and Valves

class CheckValve {
  final String value;
  final bool closedTight;

  CheckValve({
    required this.value,
    required this.closedTight,
  });

  factory CheckValve.fromJson(Map<String, dynamic> json) => CheckValve(
        value: json['value']?.toString() ?? '',
        closedTight: json['closedTight'] as bool? ?? false,
      );

  factory CheckValve.empty() => CheckValve(value: '', closedTight: false);

  Map<String, dynamic> toJson() => {
        'value': value,
        'closedTight': closedTight,
      };

  CheckValve copyWith({
    String? value,
    bool? closedTight,
  }) {
    return CheckValve(
      value: value ?? this.value,
      closedTight: closedTight ?? this.closedTight,
    );
  }
}

class ReliefValve {
  final String value;
  final bool opened;

  ReliefValve({
    required this.value,
    required this.opened,
  });

  factory ReliefValve.fromJson(Map<String, dynamic> json) => ReliefValve(
        value: json['value']?.toString() ?? '',
        opened: json['opened'] as bool? ?? false,
      );

  factory ReliefValve.empty() => ReliefValve(
        value: '',
        opened: false,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'opened': opened,
      };

  ReliefValve copyWith({
    String? value,
    bool? opened,
  }) {
    return ReliefValve(
      value: value ?? this.value,
      opened: opened ?? this.opened,
    );
  }
}

class AirInlet {
  final String value;
  final bool leaked;
  final bool opened;

  AirInlet({
    required this.value,
    required this.leaked,
    required this.opened,
  });

  factory AirInlet.fromJson(Map<String, dynamic> json) => AirInlet(
        value: json['value']?.toString() ?? '',
        leaked: json['leaked'] as bool? ?? false,
        opened: json['opened'] as bool? ?? false,
      );

  factory AirInlet.empty() => AirInlet(
        value: '',
        leaked: false,
        opened: false,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'leaked': leaked,
        'opened': opened,
      };

  AirInlet copyWith({
    String? value,
    bool? leaked,
    bool? opened,
  }) {
    return AirInlet(
      value: value ?? this.value,
      leaked: leaked ?? this.leaked,
      opened: opened ?? this.opened,
    );
  }
}

class Check {
  final String value;
  final bool leaked;

  Check({
    required this.value,
    required this.leaked,
  });

  factory Check.fromJson(Map<String, dynamic> json) => Check(
        value: json['value']?.toString() ?? '',
        leaked: json['leaked'] as bool? ?? false,
      );

  factory Check.empty() => Check(
        value: '',
        leaked: false,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'leaked': leaked,
      };

  Check copyWith({
    String? value,
    bool? leaked,
  }) {
    return Check(
      value: value ?? this.value,
      leaked: leaked ?? this.leaked,
    );
  }
}

class VacuumBreaker {
  final bool backPressure;
  final AirInlet airInlet;
  final Check check;

  VacuumBreaker({
    required this.backPressure,
    required this.airInlet,
    required this.check,
  });

  factory VacuumBreaker.fromJson(Map<String, dynamic> json) => VacuumBreaker(
        backPressure: json['backPressure'] as bool? ?? false,
        airInlet: AirInlet.fromJson(json['airInlet']),
        check: Check.fromJson(json['check']),
      );

  factory VacuumBreaker.empty() => VacuumBreaker(
        backPressure: false,
        airInlet: AirInlet.empty(),
        check: Check.empty(),
      );

  Map<String, dynamic> toJson() => {
        'backPressure': backPressure,
        'airInlet': airInlet.toJson(),
        'check': check.toJson(),
      };

  VacuumBreaker copyWith({
    bool? backPressure,
    AirInlet? airInlet,
    Check? check,
  }) {
    return VacuumBreaker(
      backPressure: backPressure ?? this.backPressure,
      airInlet: airInlet ?? this.airInlet,
      check: check ?? this.check,
    );
  }
}

//endregion

class TesterProfile {
  final String name;
  final String certNo;
  final String gaugeKit;
  final String date;

  TesterProfile({
    required this.name,
    required this.certNo,
    required this.gaugeKit,
    required this.date,
  });

  factory TesterProfile.fromJson(Map<String, dynamic> json) => TesterProfile(
        name: json['name']?.toString() ?? '',
        certNo: json['certNo']?.toString() ?? '',
        gaugeKit: json['gaugeKit']?.toString() ?? '',
        date: json['date']?.toString() ?? '',
      );

  factory TesterProfile.empty() => TesterProfile(
        name: '',
        certNo: '',
        gaugeKit: '',
        date: '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'certNo': certNo,
        'gaugeKit': gaugeKit,
        'date': date,
      };
}

class Test {
  final String linePressure;
  final CheckValve checkValve1;
  final CheckValve checkValve2;
  final ReliefValve reliefValve;
  final VacuumBreaker vacuumBreaker;
  final TesterProfile testerProfile;

  Test({
    required this.linePressure,
    required this.checkValve1,
    required this.checkValve2,
    required this.reliefValve,
    required this.vacuumBreaker,
    required this.testerProfile,
  });

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        linePressure: json['linePressure']?.toString() ?? '',
        checkValve1: CheckValve.fromJson(json['checkValve1']),
        checkValve2: CheckValve.fromJson(json['checkValve2']),
        reliefValve: ReliefValve.fromJson(json['reliefValve']),
        vacuumBreaker: VacuumBreaker.fromJson(json['vacuumBreaker']),
        testerProfile: TesterProfile.fromJson(json['testerProfile']),
      );

  factory Test.empty() => Test(
        linePressure: '',
        checkValve1: CheckValve.empty(),
        checkValve2: CheckValve.empty(),
        reliefValve: ReliefValve.empty(),
        vacuumBreaker: VacuumBreaker.empty(),
        testerProfile: TesterProfile.empty(),
      );

  Map<String, dynamic> toJson() => {
        'linePressure': linePressure,
        'checkValve1': checkValve1.toJson(),
        'checkValve2': checkValve2.toJson(),
        'reliefValve': reliefValve.toJson(),
        'vacuumBreaker': vacuumBreaker.toJson(),
        'testerProfile': testerProfile.toJson(),
      };

  Test copyWith({
    String? linePressure,
    CheckValve? checkValve1,
    CheckValve? checkValve2,
    ReliefValve? reliefValve,
    VacuumBreaker? vacuumBreaker,
    TesterProfile? testerProfile,
  }) {
    return Test(
      linePressure: linePressure ?? this.linePressure,
      checkValve1: checkValve1 ?? this.checkValve1,
      checkValve2: checkValve2 ?? this.checkValve2,
      reliefValve: reliefValve ?? this.reliefValve,
      vacuumBreaker: vacuumBreaker ?? this.vacuumBreaker,
      testerProfile: testerProfile ?? this.testerProfile,
    );
  }
}

//region Repair Info

class CheckValveRepairs {
  final bool cleaned;
  final bool checkDisc;
  final bool discHolder;
  final bool spring;
  final bool guide;
  final bool seat;
  final bool other;

  CheckValveRepairs({
    required this.cleaned,
    required this.checkDisc,
    required this.discHolder,
    required this.spring,
    required this.guide,
    required this.seat,
    required this.other,
  });

  factory CheckValveRepairs.fromJson(Map<String, dynamic> json) =>
      CheckValveRepairs(
        cleaned: json['cleaned'] as bool? ?? false,
        checkDisc: json['checkDisc'] as bool? ?? false,
        discHolder: json['discHolder'] as bool? ?? false,
        spring: json['spring'] as bool? ?? false,
        guide: json['guide'] as bool? ?? false,
        seat: json['seat'] as bool? ?? false,
        other: json['other'] as bool? ?? false,
      );

  factory CheckValveRepairs.empty() => CheckValveRepairs(
        cleaned: false,
        checkDisc: false,
        discHolder: false,
        spring: false,
        guide: false,
        seat: false,
        other: false,
      );

  Map<String, dynamic> toJson() => {
        'cleaned': cleaned,
        'checkDisc': checkDisc,
        'discHolder': discHolder,
        'spring': spring,
        'guide': guide,
        'seat': seat,
        'other': other,
      };

  CheckValveRepairs copyWith({
    bool? cleaned,
    bool? checkDisc,
    bool? discHolder,
    bool? spring,
    bool? guide,
    bool? seat,
    bool? other,
  }) =>
      CheckValveRepairs(
        cleaned: cleaned ?? this.cleaned,
        checkDisc: checkDisc ?? this.checkDisc,
        discHolder: discHolder ?? this.discHolder,
        spring: spring ?? this.spring,
        guide: guide ?? this.guide,
        seat: seat ?? this.seat,
        other: other ?? this.other,
      );
}

class ReliefValveRepairs {
  final bool cleaned;
  final bool rubberKit;
  final bool discHolder;
  final bool spring;
  final bool guide;
  final bool seat;
  final bool other;

  ReliefValveRepairs({
    required this.cleaned,
    required this.rubberKit,
    required this.discHolder,
    required this.spring,
    required this.guide,
    required this.seat,
    required this.other,
  });

  factory ReliefValveRepairs.fromJson(Map<String, dynamic> json) =>
      ReliefValveRepairs(
        cleaned: json['cleaned'] as bool? ?? false,
        rubberKit: json['rubberKit'] as bool? ?? false,
        discHolder: json['discHolder'] as bool? ?? false,
        spring: json['spring'] as bool? ?? false,
        guide: json['guide'] as bool? ?? false,
        seat: json['seat'] as bool? ?? false,
        other: json['other'] as bool? ?? false,
      );

  factory ReliefValveRepairs.empty() => ReliefValveRepairs(
        cleaned: false,
        rubberKit: false,
        discHolder: false,
        spring: false,
        guide: false,
        seat: false,
        other: false,
      );

  Map<String, dynamic> toJson() => {
        'cleaned': cleaned,
        'rubberKit': rubberKit,
        'discHolder': discHolder,
        'spring': spring,
        'guide': guide,
        'seat': seat,
        'other': other,
      };

  ReliefValveRepairs copyWith({
    bool? cleaned,
    bool? rubberKit,
    bool? discHolder,
    bool? spring,
    bool? guide,
    bool? seat,
    bool? other,
  }) =>
      ReliefValveRepairs(
        cleaned: cleaned ?? this.cleaned,
        rubberKit: rubberKit ?? this.rubberKit,
        discHolder: discHolder ?? this.discHolder,
        spring: spring ?? this.spring,
        guide: guide ?? this.guide,
        seat: seat ?? this.seat,
        other: other ?? this.other,
      );
}

class VacuumBreakerRepairs {
  final bool cleaned;
  final bool rubberKit;
  final bool discHolder;
  final bool spring;
  final bool guide;
  final bool seat;
  final bool other;

  VacuumBreakerRepairs({
    required this.cleaned,
    required this.rubberKit,
    required this.discHolder,
    required this.spring,
    required this.guide,
    required this.seat,
    required this.other,
  });

  factory VacuumBreakerRepairs.fromJson(Map<String, dynamic> json) =>
      VacuumBreakerRepairs(
        cleaned: json['cleaned'] as bool? ?? false,
        rubberKit: json['rubberKit'] as bool? ?? false,
        discHolder: json['discHolder'] as bool? ?? false,
        spring: json['spring'] as bool? ?? false,
        guide: json['guide'] as bool? ?? false,
        seat: json['seat'] as bool? ?? false,
        other: json['other'] as bool? ?? false,
      );

  factory VacuumBreakerRepairs.empty() => VacuumBreakerRepairs(
        cleaned: false,
        rubberKit: false,
        discHolder: false,
        spring: false,
        guide: false,
        seat: false,
        other: false,
      );

  Map<String, dynamic> toJson() => {
        'cleaned': cleaned,
        'rubberKit': rubberKit,
        'discHolder': discHolder,
        'spring': spring,
        'guide': guide,
        'seat': seat,
        'other': other,
      };

  VacuumBreakerRepairs copyWith({
    bool? cleaned,
    bool? rubberKit,
    bool? discHolder,
    bool? spring,
    bool? guide,
    bool? seat,
    bool? other,
  }) =>
      VacuumBreakerRepairs(
        cleaned: cleaned ?? this.cleaned,
        rubberKit: rubberKit ?? this.rubberKit,
        discHolder: discHolder ?? this.discHolder,
        spring: spring ?? this.spring,
        guide: guide ?? this.guide,
        seat: seat ?? this.seat,
        other: other ?? this.other,
      );
}

class Repairs {
  final CheckValveRepairs checkValve1Repairs;
  final CheckValveRepairs checkValve2Repairs;
  final ReliefValveRepairs reliefValveRepairs;
  final VacuumBreakerRepairs vacuumBreakerRepairs;
  final TesterProfile testerProfile;

  Repairs({
    required this.checkValve1Repairs,
    required this.checkValve2Repairs,
    required this.reliefValveRepairs,
    required this.vacuumBreakerRepairs,
    required this.testerProfile,
  });

  Repairs copyWith({
    CheckValveRepairs? checkValve1Repairs,
    CheckValveRepairs? checkValve2Repairs,
    ReliefValveRepairs? reliefValveRepairs,
    VacuumBreakerRepairs? vacuumBreakerRepairs,
    TesterProfile? testerProfile,
  }) {
    return Repairs(
      checkValve1Repairs: checkValve1Repairs ?? this.checkValve1Repairs,
      checkValve2Repairs: checkValve2Repairs ?? this.checkValve2Repairs,
      reliefValveRepairs: reliefValveRepairs ?? this.reliefValveRepairs,
      vacuumBreakerRepairs: vacuumBreakerRepairs ?? this.vacuumBreakerRepairs,
      testerProfile: testerProfile ?? this.testerProfile,
    );
  }

  factory Repairs.fromJson(Map<String, dynamic> json) => Repairs(
        checkValve1Repairs:
            CheckValveRepairs.fromJson(json['checkValve1Repairs']),
        checkValve2Repairs:
            CheckValveRepairs.fromJson(json['checkValve2Repairs']),
        reliefValveRepairs:
            ReliefValveRepairs.fromJson(json['reliefValveRepairs']),
        vacuumBreakerRepairs:
            VacuumBreakerRepairs.fromJson(json['vacuumBreakerRepairs']),
        testerProfile: TesterProfile.fromJson(json['testerProfile']),
      );

  factory Repairs.empty() => Repairs(
        checkValve1Repairs: CheckValveRepairs.empty(),
        checkValve2Repairs: CheckValveRepairs.empty(),
        reliefValveRepairs: ReliefValveRepairs.empty(),
        vacuumBreakerRepairs: VacuumBreakerRepairs.empty(),
        testerProfile: TesterProfile.empty(),
      );

  Map<String, dynamic> toJson() => {
        'checkValve1Repairs': checkValve1Repairs.toJson(),
        'checkValve2Repairs': checkValve2Repairs.toJson(),
        'reliefValveRepairs': reliefValveRepairs.toJson(),
        'vacuumBreakerRepairs': vacuumBreakerRepairs.toJson(),
        'testerProfile': testerProfile.toJson(),
      };
}

//endregion

//region Main Collective Info

class Backflow {
  final LocationInfo locationInfo;
  final InstallationInfo installationInfo;
  final DeviceInfo deviceInfo;
  final Test initialTest;
  final Repairs repairs;
  final Test finalTest;
  final bool isComplete;

  Backflow({
    required this.locationInfo,
    required this.installationInfo,
    required this.deviceInfo,
    required this.initialTest,
    required this.repairs,
    required this.finalTest,
    required this.isComplete,
  });

  factory Backflow.fromJson(Map<String, dynamic> json) => Backflow(
        locationInfo: LocationInfo.fromJson(json['locationInfo']),
        installationInfo: InstallationInfo.fromJson(json['installationInfo']),
        deviceInfo: DeviceInfo.fromJson(json['deviceInfo']),
        initialTest: Test.fromJson(json['initialTest']),
        repairs: Repairs.fromJson(json['repairs']),
        finalTest: Test.fromJson(json['finalTest']),
        isComplete: json['isComplete'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'locationInfo': locationInfo.toJson(),
        'installationInfo': installationInfo.toJson(),
        'deviceInfo': deviceInfo.toJson(),
        'initialTest': initialTest.toJson(),
        'repairs': repairs.toJson(),
        'finalTest': finalTest.toJson(),
        'isComplete': isComplete,
      };

  Backflow copyWith({
    LocationInfo? locationInfo,
    InstallationInfo? installationInfo,
    DeviceInfo? deviceInfo,
    Test? initialTest,
    Repairs? repairs,
    Test? finalTest,
    bool? isComplete,
  }) {
    return Backflow(
      locationInfo: locationInfo ?? this.locationInfo,
      installationInfo: installationInfo ?? this.installationInfo,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      initialTest: initialTest ?? this.initialTest,
      repairs: repairs ?? this.repairs,
      finalTest: finalTest ?? this.finalTest,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class BackflowList {
  final Map<String, Backflow> backflows;

  BackflowList({
    required this.backflows,
  });

  factory BackflowList.fromJson(Map<String, dynamic> json) {
    final backflows = <String, Backflow>{};
    json.forEach((key, value) {
      backflows[key] = Backflow.fromJson(value as Map<String, dynamic>);
    });
    return BackflowList(backflows: backflows);
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    backflows.forEach((key, value) {
      result[key] = value.toJson();
    });
    return result;
  }

  BackflowList copyWith({
    Map<String, Backflow>? backflows,
  }) {
    return BackflowList(
      backflows: backflows ?? this.backflows,
    );
  }

  int getCompletedCount() {
    return backflows.values
        .where((backflow) => backflow.isComplete == true)
        .length;
  }
}

class JobData {
  final Metadata metadata;
  final JobDetails details;
  final CustomerInformation customerInformation;
  final BackflowList backflowList;

  JobData({
    required this.metadata,
    required this.details,
    required this.customerInformation,
    required this.backflowList,
  });

  factory JobData.fromJson(Map<String, dynamic> json) => JobData(
        metadata: Metadata.fromJson(json['metadata']),
        details: JobDetails.fromJson(json['details']),
        customerInformation:
            CustomerInformation.fromJson(json['customerInformation']),
        backflowList: BackflowList.fromJson(json['backflowList']),
      );

  Map<String, dynamic> toJson() => {
        'metadata': metadata.toJson(),
        'details': details.toJson(),
        'customerInformation': customerInformation.toJson(),
        'backflowList': backflowList.toJson(),
      };

  JobData copyWith({
    Metadata? metadata,
    JobDetails? details,
    CustomerInformation? customerInformation,
    BackflowList? backflowList,
  }) {
    return JobData(
      metadata: metadata ?? this.metadata,
      details: details ?? this.details,
      customerInformation: customerInformation ?? this.customerInformation,
      backflowList: backflowList ?? this.backflowList,
    );
  }
}

//endregion
