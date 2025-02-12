import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/services/pdf/pdf_service.dart';

class PdfRepository {
  final pdfService = PdfService();

  Future<String> generatePdf(String waterPurveyor, Backflow backflow,
      CustomerInformation customerInfo) async {
    try {
      final templatePath = await _copyAssetToTemp(
          'assets/pdf-templates/Abf-Fillable-01-25.pdf', 'template.pdf');

      final outputDir = await _getPdfCacheDir();
      await outputDir.create(recursive: true);

      final now = DateTime.now();
      final fileName = '${backflow.deviceInfo.serialNo}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}-'
          '${now.year}.pdf';

      final outputPath = '${outputDir.path}/$fileName';

      await pdfService.fillForm(
        templatePath: templatePath,
        formData: _getFormData(waterPurveyor, backflow, customerInfo),
        outputPath: outputPath,
      );

      return outputPath;
    } on PdfException catch (e) {
      if (kDebugMode) {
        print('Error filling PDF form: $e');
      }
      rethrow;
    }
  }

  Map<String, String> _getFormData(String waterPurveyor, Backflow backflow,
      CustomerInformation customerInfo) {
    return {
      ..._getBasicInfo(waterPurveyor, customerInfo),
      ..._getDeviceInfo(backflow),
      ..._getInitialTest(backflow),
      ..._getRepairs(backflow),
      ..._getFinalTest(backflow)
    };
  }

  Map<String, String> _getBasicInfo(
      String waterPurveyor, CustomerInformation customerInfo) {
    return {
      // Water Purveyor
      'WaterPurveyor': waterPurveyor,

      // Facility Owner Information
      'FacilityOwner': customerInfo.facilityOwnerInfo.owner,
      'Address': customerInfo.facilityOwnerInfo.address,
      'Email': customerInfo.facilityOwnerInfo.email,
      'Contact': customerInfo.facilityOwnerInfo.contact,
      'Phone': customerInfo.facilityOwnerInfo.phone,

      // Representative Information
      'OwnerRep': customerInfo.representativeInfo.owner,
      'RepAddress': customerInfo.representativeInfo.address,
      'PersontoContact': customerInfo.representativeInfo.contact,
      'Phone-0': customerInfo.representativeInfo.phone,
    };
  }

  Map<String, String> _getDeviceInfo(Backflow backflow) {
    return {
      // Backflow
      'WaterMeterNo': backflow.deviceInfo.meterNo,
      'SerialNo': backflow.deviceInfo.serialNo,
      'ModelNo': backflow.deviceInfo.modelNo,
      'Size': backflow.deviceInfo.size,
      'Manufacturer': backflow.deviceInfo.manufacturer,
      'BFType': backflow.deviceInfo.type,

      // Backflow Location Info
      'AssemblyAddress': backflow.locationInfo.assemblyAddress,
      'On Site Location of Assembly': backflow.locationInfo.onSiteLocation,
      'PrimaryBusinessService': backflow.locationInfo.primaryService,

      // Backflow Installation Info
      'ProtectionType': backflow.installationInfo.protectionType,
      'ServiceType': backflow.installationInfo.serviceType,
      'InstallationIs': backflow.installationInfo.status,

      //Shutoff Valves
      'SOVList': backflow.deviceInfo.shutoffValves.status,
      'SOVComment': backflow.deviceInfo.shutoffValves.comment,
    };
  }

  Map<String, String> _getInitialTest(Backflow backflow) {
    if (backflow.initialTest.testerProfile.name.isEmpty) {
      return {
        'LinePressure': backflow.finalTest.linePressure.isEmpty
            ? backflow.initialTest.linePressure
            : backflow.finalTest.linePressure
      };
    }

    return {
      'LinePressure': backflow.finalTest.linePressure.isEmpty
          ? backflow.initialTest.linePressure
          : backflow.finalTest.linePressure,

      //region Ck1
      'InitialCT1': backflow.initialTest.checkValve1.value,
      'InitialCTBox':
          backflow.initialTest.checkValve1.closedTight ? 'On' : 'Off',
      'InitialCT1Leaked': backflow.deviceInfo.type == 'DC' ||
              backflow.deviceInfo.type == 'RP' ||
              backflow.deviceInfo.type == 'SC' ||
              backflow.deviceInfo.type == 'TYPE 2'
          ? backflow.initialTest.checkValve1.closedTight
              ? 'Off'
              : 'On'
          : 'Off',
      //endregion

      //region Ck2
      'InitialCT2': backflow.initialTest.checkValve2.value,
      'InitialCT2Box':
          backflow.initialTest.checkValve2.closedTight ? 'On' : 'Off',
      'InitialCT2Leaked':
          backflow.deviceInfo.type == 'DC' || backflow.deviceInfo.type == 'RP'
              ? backflow.initialTest.checkValve2.closedTight
                  ? 'Off'
                  : 'On'
              : 'Off',
      //endregion

      //region RV
      'InitialPSIRV': backflow.initialTest.reliefValve.value,
      'InitialRVDidNotOpen': backflow.deviceInfo.type == 'RP'
          ? backflow.initialTest.reliefValve.opened
              ? 'Off'
              : 'On'
          : 'Off',
      //endregion

      //region PVB
      'InitialAirInlet': backflow.initialTest.vacuumBreaker.airInlet.value,
      'InitialAirInletLeaked':
          backflow.initialTest.vacuumBreaker.airInlet.leaked ? 'On' : 'Off',
      'InitialCkPVBLDidNotOpen':
          backflow.deviceInfo.type == 'PVB' || backflow.deviceInfo.type == 'SVB'
              ? backflow.initialTest.vacuumBreaker.airInlet.opened
                  ? 'Off'
                  : 'On'
              : 'Off',

      'InitialCk1PVB': backflow.initialTest.vacuumBreaker.check.value,
      'InitialCkPVBLeaked':
          backflow.initialTest.vacuumBreaker.check.leaked ? 'On' : 'Off',
      //endregion

      //region Tester Profile
      'InitialTester': backflow.initialTest.testerProfile.name,
      'InitialTesterNo': backflow.initialTest.testerProfile.certNo,
      'DateFailed': backflow.initialTest.testerProfile.date,
      'InitialTestKitSerial': backflow.initialTest.testerProfile.gaugeKit,
      //endregion

      //endregion
    };
  }

  Map<String, String> _getRepairs(Backflow backflow) {
    if (backflow.repairs.testerProfile.name.isEmpty) {
      return {};
    }

    return {
      //region CK1
      'Ck1Cleaned': backflow.repairs.checkValve1Repairs.cleaned ? 'On' : 'Off',
      'Ck1CheckDisc':
          backflow.repairs.checkValve1Repairs.checkDisc ? 'On' : 'Off',
      'Ck1DiscHolder':
          backflow.repairs.checkValve1Repairs.discHolder ? 'On' : 'Off',
      'Ck1Spring': backflow.repairs.checkValve1Repairs.spring ? 'On' : 'Off',
      'Ck1Guide': backflow.repairs.checkValve1Repairs.guide ? 'On' : 'Off',
      'Ck1Seat': backflow.repairs.checkValve1Repairs.seat ? 'On' : 'Off',
      'Ck1Other': backflow.repairs.checkValve1Repairs.other ? 'On' : 'Off',
      //endregion

      //region CK2
      'Ck2Cleaned': backflow.repairs.checkValve2Repairs.cleaned ? 'On' : 'Off',
      'Ck2CheckDisc':
          backflow.repairs.checkValve2Repairs.checkDisc ? 'On' : 'Off',
      'Ck2DiscHolder':
          backflow.repairs.checkValve2Repairs.discHolder ? 'On' : 'Off',
      'Ck2Spring': backflow.repairs.checkValve2Repairs.spring ? 'On' : 'Off',
      'Ck2Guide': backflow.repairs.checkValve2Repairs.guide ? 'On' : 'Off',
      'Ck2Seat': backflow.repairs.checkValve2Repairs.seat ? 'On' : 'Off',
      'Ck2Other': backflow.repairs.checkValve2Repairs.other ? 'On' : 'Off',
      //endregion

      //region RV
      'RVCleaned': backflow.repairs.reliefValveRepairs.cleaned ? 'On' : 'Off',
      'RVRubberKit':
          backflow.repairs.reliefValveRepairs.rubberKit ? 'On' : 'Off',
      'RVDiscHolder':
          backflow.repairs.reliefValveRepairs.discHolder ? 'On' : 'Off',
      'RVSpring': backflow.repairs.reliefValveRepairs.spring ? 'On' : 'Off',
      'RVGuide': backflow.repairs.reliefValveRepairs.guide ? 'On' : 'Off',
      'RVSeat': backflow.repairs.reliefValveRepairs.seat ? 'On' : 'Off',
      'RVOther': backflow.repairs.reliefValveRepairs.other ? 'On' : 'Off',
      //endregion

      //region PVB
      'PVBCleaned':
          backflow.repairs.vacuumBreakerRepairs.cleaned ? 'On' : 'Off',
      'PVBRubberKit':
          backflow.repairs.vacuumBreakerRepairs.rubberKit ? 'On' : 'Off',
      'PVBDiscHolder':
          backflow.repairs.vacuumBreakerRepairs.discHolder ? 'On' : 'Off',
      'PVBSpring': backflow.repairs.vacuumBreakerRepairs.spring ? 'On' : 'Off',
      'PVBGuide': backflow.repairs.vacuumBreakerRepairs.guide ? 'On' : 'Off',
      'PVBSeat': backflow.repairs.vacuumBreakerRepairs.seat ? 'On' : 'Off',
      'PVBOther': backflow.repairs.vacuumBreakerRepairs.other ? 'On' : 'Off',
      //endregion

      //region Tester Profile
      'RepairedTester': backflow.repairs.testerProfile.name,
      'RepairedTesterNo': backflow.repairs.testerProfile.certNo,
      'DateRepaired': backflow.repairs.testerProfile.date,
      'RepairedTestKitSerial': backflow.repairs.testerProfile.gaugeKit,
      //endregion
    };
  }

  Map<String, String> _getFinalTest(Backflow backflow) {
    if (backflow.finalTest.testerProfile.name.isEmpty) {
      return {};
    }

    return {
      //region Ck1
      'FinalCT1': backflow.finalTest.checkValve1.value,
      'FinalCT1Box': backflow.finalTest.checkValve1.closedTight ? 'On' : 'Off',
      //endregion

      //region Ck2
      'FinalCT2': backflow.finalTest.checkValve2.value,
      'FinalCT2Box': backflow.finalTest.checkValve2.closedTight ? 'On' : 'Off',
      //endregion

      //region RV
      'FinalRV': backflow.finalTest.reliefValve.value,
      //endregion

      //region PVB
      'BackPressure':
          backflow.deviceInfo.type == 'PVB' || backflow.deviceInfo.type == 'SVB'
              ? backflow.finalTest.vacuumBreaker.backPressure
                  ? 'Yes'
                  : 'No'
              : '',
      'FinalAirInlet': backflow.finalTest.vacuumBreaker.airInlet.value,
      'Check Valve': backflow.finalTest.vacuumBreaker.check.value,
      //endregion

      //region Tester Profile
      'FinalTester': backflow.finalTest.testerProfile.name,
      'FinalTesterNo': backflow.finalTest.testerProfile.certNo,
      'DatePassed': backflow.finalTest.testerProfile.date,
      'FinalTestKitSerial': backflow.finalTest.testerProfile.gaugeKit,
      //endregion

      'ReportComments': backflow.deviceInfo.comments,
    };
  }

  Future<String> _copyAssetToTemp(String assetPath, String filename) async {
    try {
      // Read asset bytes
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$filename');

      // Write bytes to temporary file
      await tempFile.writeAsBytes(bytes, flush: true);

      return tempFile.path;
    } catch (e) {
      throw PdfException('Failed to copy template: $e');
    }
  }

  Future<Directory> _getPdfCacheDir() async {
    final appCacheDir = await getTemporaryDirectory();
    return Directory('${appCacheDir.path}/pdfs');
  }
}
