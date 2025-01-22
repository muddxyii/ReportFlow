import 'package:flutter/material.dart';
import 'package:report_flow/core/data/job_repository.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/features/job/presentation/widgets/backflow_list_card.dart';
import 'package:report_flow/features/job/presentation/widgets/customer_info_card.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class JobPage extends StatefulWidget {
  final String filePath;

  const JobPage({super.key, required this.filePath});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  JobData? _jobData;
  final _jobRepository = JobRepository();

  @override
  void initState() {
    super.initState();
    _loadJobData();
  }

  Future<void> _loadJobData() async {
    try {
      final jobData = await _jobRepository.loadJob(widget.filePath);

      if (!mounted) return;

      final choice = await _handleDuplicateJob(jobData);
      if (choice == null || choice == 'edit') {
        Navigator.of(context).pop();
        return;
      }

      setState(() => _jobData = jobData);
    } catch (e) {
      if (!mounted) return;
      _showErrorAndNavigateBack();
    }
  }

  Future<String?> _handleDuplicateJob(JobData jobData) async {
    if (await _jobRepository.jobExists(jobData.metadata.jobId)) {
      return showDialog<String>(
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
    }
    return 'overwrite';
  }

  void _showErrorAndNavigateBack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Invalid ReportFlow File - Unable to parse job data'),
        duration: Duration(seconds: 5),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
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
      body: _jobData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _jobData!.metadata.jobName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  CustomerInfoCard(info: _jobData!.customerInformation),
                  const SizedBox(height: 16),
                  BackflowListCard(list: _jobData!.backflowList),
                ],
              ),
            ),
    );
  }
}
