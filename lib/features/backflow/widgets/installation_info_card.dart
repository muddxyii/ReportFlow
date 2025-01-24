import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class InstallationInfoCard extends StatelessWidget {
  final InstallationInfo info;

  final Function(InstallationInfo) onInfoUpdate;

  const InstallationInfoCard(
      {super.key, required this.info, required this.onInfoUpdate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Installation Information',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${info.status}'),
                Text('Protection Type: ${info.protectionType}'),
                Text('Service Type: ${info.serviceType}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
