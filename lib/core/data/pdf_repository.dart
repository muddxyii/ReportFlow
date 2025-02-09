import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/services/pdf/pdf_service.dart';

class PdfRepository {
  final pdfService = PdfService();

  Future<void> generatePdf(Backflow backflow) async {
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

      await pdfService.fillForm(
        templatePath: templatePath,
        formData: {
          'WaterMeterNo': backflow.deviceInfo.meterNo,
          'SerialNo': backflow.deviceInfo.serialNo,
          // Add other fields...
        },
        outputPath: '${outputDir.path}/$fileName',
      );
    } on PdfException catch (e) {
      if (kDebugMode) {
        print('Error filling PDF form: $e');
      }
      rethrow;
    }
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
