import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/services/pdf/pdf_service.dart';

class PdfRepository {
  final pdfService = PdfService();

  Future<String> generatePdf(
      Backflow backflow, CustomerInformation customerInfo) async {
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
        formData: _getFormData(backflow, customerInfo),
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

  Map<String, String> _getFormData(
      Backflow backflow, CustomerInformation customerInfo) {
    return {
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

      // Backflow
      'WaterMeterNo': backflow.deviceInfo.meterNo,
      'SerialNo': backflow.deviceInfo.serialNo,
      'Model': backflow.deviceInfo.modelNo,
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

      // Backflow Initial Test
      'LinePressure': backflow.initialTest.linePressure,
      'InitialCT1': backflow.initialTest.checkValve1.value,
      'InitialCT2': backflow.initialTest.checkValve2.value,
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
