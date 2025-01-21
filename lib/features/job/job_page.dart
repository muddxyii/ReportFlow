import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class JobPage extends StatefulWidget {
  final String filePath;

  const JobPage({super.key, required this.filePath});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  JobData? _jobData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadJobData();
  }

  Future<void> _loadJobData() async {
    try {
      final file = File(widget.filePath);
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString);

      setState(() {
        _jobData = JobData.fromJson(json);
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading job data: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _error != null
            ? Text(_error!, style: TextStyle(color: Colors.red))
            : _jobData == null
                ? const CircularProgressIndicator()
                : Text(
                    'Job Type: ${_jobData!.metadata.jobType}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
      ),
    );
  }
}
