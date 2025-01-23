import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_flow/core/data/job_repository.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/features/job/presentation/job_page.dart';

class JobBrowserPage extends StatefulWidget {
  const JobBrowserPage({super.key});

  @override
  State<JobBrowserPage> createState() => _JobBrowserPageState();
}

class _JobBrowserPageState extends State<JobBrowserPage> {
  final _jobRepository = JobRepository();
  List<JobData> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    try {
      _jobs = await _jobRepository.getAllJobs();
      _jobs.sort((a, b) =>
          b.metadata.lastModifiedDate.compareTo(a.metadata.lastModifiedDate));
    } catch (e) {
      debugPrint('Error loading jobs: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadJobs,
              child: ListView.builder(
                itemCount: _jobs.length,
                itemBuilder: (context, index) {
                  final job = _jobs[index];
                  return ListTile(
                    title: Text(job.details.jobName),
                    subtitle: Text(
                        'Last modified: ${DateFormat('MM/dd/yy hh:mm a').format(DateTime.parse(job.metadata.lastModifiedDate).toLocal())}'),
                    onTap: () async {
                      final filePath = await _jobRepository
                          .getJobFilePath(job.metadata.jobId);
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobPage(
                            filePath: filePath,
                            fromIntent: false,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
