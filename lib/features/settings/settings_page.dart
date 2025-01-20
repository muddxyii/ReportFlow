import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_viewmodel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isTesterInfoExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Consumer<SettingsViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Tester Information Section
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text('Tester Information'),
                                trailing: Icon(_isTesterInfoExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                onTap: () {
                                  setState(() {
                                    _isTesterInfoExpanded = !_isTesterInfoExpanded;
                                  });
                                },
                              ),
                              if (_isTesterInfoExpanded)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'Tester Name',
                                              ),
                                              onChanged: (value) =>
                                              viewModel.testerName = value,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'Test Kit Serial',
                                              ),
                                              onChanged: (value) =>
                                              viewModel.testKitSerial = value,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'Test Cert No.',
                                              ),
                                              onChanged: (value) =>
                                              viewModel.testCertNo = value,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'Repair Cert No.',
                                              ),
                                              onChanged: (value) =>
                                              viewModel.repairCertNo = value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => viewModel.save(),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer
                Padding(
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
              ],
            );
          },
        ),
      ),
    );
  }
}
