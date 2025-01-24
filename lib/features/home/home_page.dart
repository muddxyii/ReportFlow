import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:report_flow/core/data/job_repository.dart';
import 'package:report_flow/core/data/profile_repository.dart';
import 'package:report_flow/features/job/presentation/job_page.dart';
import 'package:report_flow/features/job_browser/job_browser_page.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('app_channel');
  final _profileRepository = ProfileRepository();
  final _jobRepository = JobRepository();
  bool _checkedProfiles = false;

  @override
  void initState() {
    super.initState();
    _handleIncomingJson();
    _listenForNewJson();
    _checkProfiles();
    _cleanupOldJobs();
  }

  Future<void> _handleIncomingJson() async {
    try {
      final String? path = await platform.invokeMethod('getInitialFilePath');
      if (path != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JobPage(
                      fromIntent: true,
                      filePath: path,
                    )),
          );
        }
      }
    } catch (e) {
      debugPrint('Error handling JSON: $e');
    }
  }

  void _listenForNewJson() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onNewFilePath') {
        final String? newPath = call.arguments as String?;
        if (newPath != null && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      }
    });
  }

  Future<void> _checkProfiles() async {
    if (_checkedProfiles) return;

    final profiles = await _profileRepository.getProfiles();
    if (profiles.isEmpty && mounted) {
      _checkedProfiles = true;
      _showCreateProfileDialog();
    }
  }

  void _showCreateProfileDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('No Profile Found'),
        content:
            const Text('Would you like to create a profile to get started?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not Now'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            child: const Text('Create Profile'),
          ),
        ],
      ),
    );
  }

  Future<void> _cleanupOldJobs() async {
    try {
      await _jobRepository.cleanupOldJobs();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cleaning up old jobs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportFlow'),
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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to ReportFlow'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JobBrowserPage()),
            ),
            child: const Text('Browse Jobs'),
          ),
        ],
      )),
    );
  }
}
