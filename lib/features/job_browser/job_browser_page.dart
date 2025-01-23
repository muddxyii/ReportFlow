import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_flow/core/data/job_repository.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/features/job/presentation/job_page.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class JobBrowserPage extends StatefulWidget {
  const JobBrowserPage({super.key});

  @override
  State<JobBrowserPage> createState() => _JobBrowserPageState();
}

class _JobBrowserPageState extends State<JobBrowserPage> {
  final _jobRepository = JobRepository();
  List<JobData> _jobs = [];
  List<JobData> _filteredJobs = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterJobs(String query) {
    setState(() {
      _filteredJobs = _jobs
          .where((job) =>
              job.details.jobName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    try {
      _jobs = await _jobRepository.getAllJobs();
      _jobs.sort((a, b) =>
          b.metadata.lastModifiedDate.compareTo(a.metadata.lastModifiedDate));
      _filteredJobs = _jobs;
    } catch (e) {
      debugPrint('Error loading jobs: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteJob(String jobId) async {
    try {
      await _jobRepository.deleteJob(jobId);
      await _loadJobs();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting job: $e')),
      );
    }
  }

  Future<void> _deleteAllJobs() async {
    try {
      for (final job in _jobs) {
        await _jobRepository.deleteJob(job.metadata.jobId);
      }
      await _loadJobs();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All jobs deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting jobs: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Browser'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => _confirmDeleteAll(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterJobs,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadJobs,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = _filteredJobs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.details.jobName,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Task: ${job.details.jobType}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Backflows: ${job.backflowList.backflows.length}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Last modified: ${DateFormat('MM/dd/yy hh:mm a').format(DateTime.parse(job.metadata.lastModifiedDate).toLocal())}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          final filePath = await _jobRepository
                                              .getJobFilePath(
                                                  job.metadata.jobId);
                                          if (!mounted) return;
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
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _confirmDelete(context, job),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, JobData jobData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content:
            Text('Are you sure you want to delete ${jobData.details.jobName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _deleteJob(jobData.metadata.jobId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile deleted')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Jobs'),
        content: const Text(
            'Are you sure you want to delete all jobs? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteAllJobs();
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
