import 'package:flutter/services.dart';

abstract class PdfOperations {
  Future<void> fillForm({
    required String templatePath,
    required Map<String, String> formData,
    required String outputPath,
  });
}

/// Platform-specific implementation of PDF operations
class PdfService implements PdfOperations {
  static const platform = MethodChannel('com.your.app/pdf');

  @override
  Future<void> fillForm({
    required String templatePath,
    required Map<String, String> formData,
    required String outputPath,
  }) async {
    try {
      await platform.invokeMethod('fillPdfForm', {
        'templatePath': templatePath,
        'formData': formData,
        'outputPath': outputPath,
      });
    } catch (e) {
      throw PdfException._fromPlatformError(e);
    }
  }
}

/// Custom exception for PDF operations
class PdfException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  PdfException(this.message, {this.code, this.details});

  factory PdfException._fromPlatformError(dynamic error) {
    if (error is PlatformException) {
      return PdfException(
        error.message ?? 'Unknown platform error',
        code: error.code,
        details: error.details,
      );
    }
    return PdfException(error.toString());
  }

  @override
  String toString() =>
      'PdfException: $message${code != null ? ' (code: $code)' : ''}';
}
