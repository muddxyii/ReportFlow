import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('app_channel');

  @override
  void initState() {
    super.initState();
    _handleIncomingJson();
    _listenForNewJson();
  }

  Future<void> _handleIncomingJson() async {
    try {
      final String? path = await platform.invokeMethod('getInitialFilePath');
      if (path != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
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
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        }
      }
    });
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
      body: const Center(
        child: Text('Welcome to ReportFlow'),
      ),
    );
  }
}
