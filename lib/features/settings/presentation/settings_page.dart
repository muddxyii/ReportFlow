import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reportflow/features/settings/presentation/profiles/tester_profiles.dart';
import 'package:reportflow/features/settings/settings_viewmodel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: TesterProfiles(),
              ),
            ),
            Consumer<SettingsViewModel>(
              builder: (context, viewModel, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Text(
                      viewModel.appNameWithVersion,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      viewModel.companyCopyright,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
