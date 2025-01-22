import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class BackflowListCard extends StatelessWidget {
  final BackflowList list;

  const BackflowListCard({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Backflow Devices',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...list.backflows.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child:
                    Text('Serial Number: ${entry.value.deviceInfo.serialNo}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
