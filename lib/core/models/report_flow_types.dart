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
    required this.permitNo,
    required this.meterNo,
    required this.serialNo,
    required this.type,
    required this.manufacturer,
    required this.size,
    required this.modelNo,
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

  Map<String, dynamic> toJson() => {
        'value': value,
        'closedTight': closedTight,
      };
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

  Map<String, dynamic> toJson() => {
        'value': value,
        'opened': opened,
      };
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

  Map<String, dynamic> toJson() => {
        'value': value,
        'leaked': leaked,
        'opened': opened,
      };
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

  Map<String, dynamic> toJson() => {
        'value': value,
        'leaked': leaked,
      };
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

  Map<String, dynamic> toJson() => {
        'backPressure': backPressure,
        'airInlet': airInlet.toJson(),
        'check': check.toJson(),
      };
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

  Map<String, dynamic> toJson() => {
        'linePressure': linePressure,
        'checkValve1': checkValve1.toJson(),
        'checkValve2': checkValve2.toJson(),
        'reliefValve': reliefValve.toJson(),
        'vacuumBreaker': vacuumBreaker.toJson(),
        'testerProfile': testerProfile.toJson(),
      };
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

  Map<String, dynamic> toJson() => {
        'cleaned': cleaned,
        'checkDisc': checkDisc,
        'discHolder': discHolder,
        'spring': spring,
        'guide': guide,
        'seat': seat,
        'other': other,
      };
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

  Map<String, dynamic> toJson() => {
        'cleaned': cleaned,
        'checkDisc': rubberKit,
        'discHolder': discHolder,
        'spring': spring,
        'guide': guide,
        'seat': seat,
        'other': other,
      };
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

  Map<String, dynamic> toJson() => {
        'cleaned': cleaned,
        'checkDisc': rubberKit,
        'discHolder': discHolder,
        'spring': spring,
        'guide': guide,
        'seat': seat,
        'other': other,
      };
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

  Backflow({
    required this.locationInfo,
    required this.installationInfo,
    required this.deviceInfo,
    required this.initialTest,
    required this.repairs,
    required this.finalTest,
  });

  factory Backflow.fromJson(Map<String, dynamic> json) => Backflow(
        locationInfo: LocationInfo.fromJson(json['locationInfo']),
        installationInfo: InstallationInfo.fromJson(json['installationInfo']),
        deviceInfo: DeviceInfo.fromJson(json['deviceInfo']),
        initialTest: Test.fromJson(json['initialTest']),
        repairs: Repairs.fromJson(json['repairs']),
        finalTest: Test.fromJson(json['finalTest']),
      );

  Map<String, dynamic> toJson() => {
        'locationInfo': locationInfo.toJson(),
        'installationInfo': installationInfo.toJson(),
        'deviceInfo': deviceInfo.toJson(),
        'initialTest': initialTest.toJson(),
        'repairs': repairs.toJson(),
        'finalTest': finalTest.toJson(),
      };
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
