import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class JobPage extends StatefulWidget {
  final String filePath;

  const JobPage({super.key, required this.filePath});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  JobData? _jobData;

  @override
  void initState() {
    super.initState();
    _loadJobData();
  }

  Future<void> _loadJobData() async {
    try {
      // Check file status
      if (widget.filePath.isEmpty) {
        throw Exception("File path is null or empty.");
      }

      final file = File(widget.filePath);
      if (!await file.exists()) {
        throw Exception("File does not exist at ${widget.filePath}");
      }

      // Get json from file
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString);
      final jobData = JobData.fromJson(json);

      // Try to delete file in cache
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } catch (deleteError) {
        if (kDebugMode) {
          print('Failed to delete invalid file: $deleteError');
        }
      }

      // Check for existing job file
      final appCacheDir = await getTemporaryDirectory();
      final jobCacheDir = Directory('${appCacheDir.path}/jobs');
      final existingFile =
          File('${jobCacheDir.path}/${jobData.metadata.jobId}.rfjson');

      if (await existingFile.exists()) {
        // Show dialog and wait for user choice
        final choice = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Duplicate Job Found'),
            content: const Text(
                'A job with this ID already exists. What would you like to do?'),
            actions: [
              TextButton(
                child: const Text('Edit Existing'),
                onPressed: () => Navigator.of(context).pop('edit'),
              ),
              TextButton(
                child: const Text('Overwrite'),
                onPressed: () => Navigator.of(context).pop('overwrite'),
              ),
            ],
          ),
        );

        if (choice == 'edit') {
          //TODO: Implement edit existing job
          if (mounted) {
            Navigator.of(context).pop();
          }
          return;
        }

        if (choice == null) {
          // Dialog was dismissed
          if (mounted) {
            Navigator.of(context).pop();
          }
          return;
        }
      }

      // Delete original file
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } catch (deleteError) {
        if (kDebugMode) {
          print('Failed to delete invalid file: $deleteError');
        }
      }

      // Save to cache
      await jobCacheDir.create(recursive: true);
      final cacheFile =
          File('${jobCacheDir.path}/${jobData.metadata.jobId}.rfjson');
      await cacheFile.writeAsString(jsonString);

      setState(() {
        _jobData = jobData;
      });
    } catch (e) {
      // Try to delete file in cache
      try {
        final file = File(widget.filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (deleteError) {
        if (kDebugMode) {
          print('Failed to delete invalid file: $deleteError');
        }
      }
      if (mounted) {
        // Show SnackBar Error Message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Invalid ReportFlow File - Unable to parse job data'),
            duration: Duration(seconds: 5),
          ),
        );

        // Go back a page
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _jobData == null
              ? const CircularProgressIndicator()
              : Text(
                  'Job Type: ${_jobData!.metadata.jobType}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
        ),
      ),
    );
  }
}
