import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class JobRepository {
  final jsonEncoder = JsonEncoder.withIndent('  ');

  Future<JobData> loadJob(String filePath) async {
    if (filePath.isEmpty) {
      throw Exception("File path is null or empty.");
    }

    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception("File does not exist at $filePath");
    }

    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);
    final jobData = JobData.fromJson(json);

    await _cacheJob(file, jobData, jsonString);

    return jobData;
  }

  Future<void> saveJob(JobData jobData) async {
    if (jobData.metadata.jobId.isEmpty) {
      throw Exception("Job ID is null or empty.");
    }

    final jobCacheDir = await _getJobCacheDir();
    await jobCacheDir.create(recursive: true);

    final cacheFile =
        File('${jobCacheDir.path}/${jobData.metadata.jobId}.rfjson');
    final jsonString = jsonEncoder.convert(jobData.toJson());

    await cacheFile.writeAsString(jsonString);
  }

  Future<bool> jobExists(String jobId) async {
    final jobCacheDir = await _getJobCacheDir();
    final existingFile = File('${jobCacheDir.path}/$jobId.rfjson');
    return await existingFile.exists();
  }

  Future<void> _cacheJob(File file, JobData jobData, String jsonString) async {
    final jobCacheDir = await _getJobCacheDir();
    await jobCacheDir.create(recursive: true);

    final cacheFile =
        File('${jobCacheDir.path}/${jobData.metadata.jobId}.rfjson');
    await cacheFile.writeAsString(jsonString);

    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete original file: $e');
      }
    }
  }

  Future<Directory> _getJobCacheDir() async {
    final appCacheDir = await getTemporaryDirectory();
    return Directory('${appCacheDir.path}/jobs');
  }
}
