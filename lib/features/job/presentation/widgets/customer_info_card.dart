import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class CustomerInfoCard extends StatelessWidget {
  final CustomerInformation info;

  const CustomerInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Facility Owner',
                style: Theme.of(context).textTheme.titleMedium),
            Text('Name: ${info.facilityOwnerInfo.owner}'),
            Text('Contact: ${info.facilityOwnerInfo.contact}'),
            Text('Phone: ${info.facilityOwnerInfo.phone}'),
            const SizedBox(height: 16),
            Text('Representative',
                style: Theme.of(context).textTheme.titleMedium),
            Text('Name: ${info.representativeInfo.owner}'),
            Text('Contact: ${info.representativeInfo.contact}'),
            Text('Phone: ${info.representativeInfo.phone}'),
          ],
        ),
      ),
    );
  }
}
