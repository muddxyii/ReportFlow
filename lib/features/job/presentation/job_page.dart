import 'dart:io';

import 'package:flutter/material.dart';
import 'package:report_flow/core/data/job_repository.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/features/job/presentation/widgets/backflow_list_card.dart';
import 'package:report_flow/features/job/presentation/widgets/customer_info_card.dart';
import 'package:report_flow/features/job/presentation/widgets/job_header_card.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

enum JobLoadingState { initial, loading, loaded, error }

class JobPage extends StatefulWidget {
  final String filePath;
  final bool fromIntent;

  const JobPage({super.key, required this.filePath, required this.fromIntent});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final _jobRepository = JobRepository();
  JobLoadingState _loadingState = JobLoadingState.initial;
  JobData? _jobData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeJob();
  }

  Future<void> _initializeJob() async {
    setState(() => _loadingState = JobLoadingState.loading);

    try {
      final jobData = await _loadAndProcessJob();
      if (widget.fromIntent) {
        await _jobRepository.cacheJob(File(widget.filePath), jobData);
      }

      if (!mounted) return;

      setState(() {
        _jobData = jobData;
        _loadingState = JobLoadingState.loaded;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _loadingState = JobLoadingState.error;
      });
      _showErrorSnackBar();
    }
  }

  Future<JobData> _loadAndProcessJob() async {
    final initialJobData =
        await _jobRepository.loadJobFromPath(widget.filePath);

    if (await _jobRepository.jobExists(initialJobData.metadata.jobId) &&
        widget.fromIntent) {
      final action = await _handleDuplicateJob();
      if (action == 'cancel') throw Exception('Job loading cancelled');

      if (action == 'edit') {
        return await _jobRepository
            .getExistingJob(initialJobData.metadata.jobId);
      }
    }

    return initialJobData;
  }

  Future<String> _handleDuplicateJob() async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
    return result ?? 'cancel';
  }

  Future<void> _updateJob(JobData Function(JobData) update) async {
    if (_jobData == null) return;

    try {
      final updatedJob = update(_jobData!);
      await _jobRepository.saveJob(updatedJob);

      setState(() => _jobData = updatedJob);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to save job: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showErrorSnackBar() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(_errorMessage ?? 'An error occurred'),
        duration: const Duration(seconds: 5),
      ),
    );
    Navigator.of(context).pop();
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_loadingState) {
      case JobLoadingState.initial:
      case JobLoadingState.loading:
        return const Center(child: CircularProgressIndicator());

      case JobLoadingState.error:
        return Center(child: Text(_errorMessage ?? 'An error occurred'));

      case JobLoadingState.loaded:
        if (_jobData == null) return const SizedBox.shrink();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JobHeaderCard(
                jobName: _jobData!.details.jobName,
                jobType: _jobData!.details.jobType,
              ),
              CustomerInfoCard(
                info: _jobData!.customerInformation,
                onInfoUpdate: (updatedInfo) => _updateJob(
                  (job) => job.copyWith(customerInformation: updatedInfo),
                ),
              ),
              const SizedBox(height: 8),
              BackflowListCard(
                list: _jobData!.backflowList,
                onInfoUpdate: (updatedList) => _updateJob(
                    (job) => job.copyWith(backflowList: updatedList)),
              ),
            ],
          ),
        );
    }
  }
}
