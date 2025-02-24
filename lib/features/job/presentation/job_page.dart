import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reportflow/core/data/job_repository.dart';
import 'package:reportflow/core/data/pdf_repository.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/features/job/presentation/widgets/backflow_list_card.dart';
import 'package:reportflow/features/job/presentation/widgets/customer_info_card.dart';
import 'package:reportflow/features/job/presentation/widgets/job_header_card.dart';
import 'package:reportflow/features/job/presentation/widgets/purveyor_info_card.dart';
import 'package:reportflow/features/settings/presentation/settings_page.dart';
import 'package:share_plus/share_plus.dart';

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to save job: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
                list: _jobData!.backflowList,
              ),
              PurveyorInfoCard(
                  waterPurveyor: _jobData!.details.waterPurveyor,
                  onPurveyorUpdate: (updatedPurveyor) => _updateJob((job) =>
                      job.copyWith(
                          details: job.details
                              .copyWith(waterPurveyor: updatedPurveyor)))),
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
                onSharePdf: (Backflow backflow) {
                  return _generateAndSharePdf(backflow);
                },
              ),
            ],
          ),
        );
    }
  }

  Future<bool> _generateAndSharePdf(Backflow backflow) async {
    final pdfRepo = PdfRepository();
    final pdfPath = await pdfRepo.generatePdf(_jobData!.details.waterPurveyor,
        backflow, _jobData!.customerInformation);

    if (pdfPath.isEmpty) {
      return false;
    }

    final jobName = _jobData!.details.jobName;
    final jobType = _jobData!.details.jobType;
    final currentBackflowNum = _jobData!.backflowList.getCompletedCount() + 1;
    final totalBackflowNum = _jobData!.backflowList.backflows.length;
    final serialNo = backflow.deviceInfo.serialNo;

    final subjectLineText =
        '$jobName - $jobType ($currentBackflowNum of $totalBackflowNum)';
    final bodyText = '$serialNo - Report Generated With ReportFlow';

    final result = await Share.shareXFiles([XFile(pdfPath)],
        subject: subjectLineText, text: bodyText);

    if (!backflow.isComplete &&
        result.status == ShareResultStatus.success &&
        mounted) {
      final shouldMarkComplete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mark as Complete?'),
          content:
              const Text('Would you like to mark this backflow as complete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      return shouldMarkComplete ?? false;
    }

    return false;
  }
}
