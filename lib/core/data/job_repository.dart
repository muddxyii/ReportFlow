import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class JobRepository {
  final _jsonEncoder = JsonEncoder.withIndent('  ');
  static const _fileExtension = '.rfjson';

  //region File Operations
  Future<JobData> loadJobFromPath(String filePath) async {
    _validatePath(filePath);
    final file = File(filePath);
    await _validateFileExists(file);
    return _parseJobData(await file.readAsString());
  }

  Future<JobData> getExistingJob(String jobId) async {
    final file = await _getJobFile(jobId);
    await _validateFileExists(file);
    return _parseJobData(await file.readAsString());
  }

  Future<List<JobData>> getAllJobs() async {
    final dir = await _getJobCacheDir();
    if (!await dir.exists()) return [];

    final jobs = <JobData>[];
    await for (final file in dir.list(followLinks: false)) {
      if (file is File && file.path.endsWith(_fileExtension)) {
        try {
          final jobData = _parseJobData(await file.readAsString());
          jobs.add(jobData);
        } catch (e) {
          if (kDebugMode) print('Failed to parse job file: $e');
        }
      }
    }

    return jobs;
  }

  Future<String> getJobFilePath(String jobId) async {
    _validateJobId(jobId);
    File file = await _getJobFile(jobId);
    return file.path;
  }

  Future<void> saveJob(JobData jobData) async {
    _validateJobId(jobData.metadata.jobId);

    final updatedMetadata = Metadata(
      jobId: jobData.metadata.jobId,
      formatVersion: jobData.metadata.formatVersion,
      creationDate: jobData.metadata.creationDate,
      lastModifiedDate: DateTime.now().toUtc().toIso8601String(),
    );
    final updatedJobData = jobData.copyWith(metadata: updatedMetadata);

    final file = await _getJobFile(updatedJobData.metadata.jobId);
    final jobCacheDir = await _getJobCacheDir();

    await jobCacheDir.create(recursive: true);
    await file.writeAsString(_jsonEncoder.convert(updatedJobData.toJson()));
  }

  Future<bool> jobExists(String jobId) async {
    final file = await _getJobFile(jobId);
    return file.exists();
  }

  /// **Purpose:**
  /// This function is used to save job data and delete the associated file.
  ///
  /// **Usage:**
  /// Call this method only when caching a job for the first time.
  ///
  /// **Parameters:**
  /// - `file` (File): The file to be deleted after caching the job.
  /// - `jobData` (JobData): The job data to be saved.
  Future<void> cacheJob(File file, JobData jobData) async {
    await saveJob(jobData);
    await _deleteFile(file);
  }

  //endregion

  //region Private Helpers

  Future<File> _getJobFile(String jobId) async {
    final dir = await _getJobCacheDir();
    return File('${dir.path}/$jobId$_fileExtension');
  }

  Future<Directory> _getJobCacheDir() async {
    final appCacheDir = await getTemporaryDirectory();
    return Directory('${appCacheDir.path}/jobs');
  }

  JobData _parseJobData(String jsonString) {
    final json = jsonDecode(jsonString);
    return JobData.fromJson(json);
  }

  void _validatePath(String path) {
    if (path.isEmpty) throw Exception('File path is empty');
  }

  void _validateJobId(String jobId) {
    if (jobId.isEmpty) throw Exception('Job ID is empty');
  }

  Future<void> _validateFileExists(File file) async {
    if (!await file.exists()) {
      throw Exception('File does not exist: ${file.path}');
    }
  }

  Future<void> _deleteFile(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } catch (e) {
      if (kDebugMode) print('Failed to delete file: $e');
    }
  }

//endregion
}
