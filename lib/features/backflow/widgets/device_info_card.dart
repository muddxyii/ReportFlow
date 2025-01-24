import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class DeviceInfoCard extends StatelessWidget {
  final DeviceInfo info;

  final Function(DeviceInfo) onInfoUpdate;

  const DeviceInfoCard(
      {super.key, required this.info, required this.onInfoUpdate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Device Information',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Permit Number: ${info.permitNo}'),
                Text('Meter Number: ${info.meterNo}'),
                Text('Serial Number: ${info.serialNo}'),
                Text('Type: ${info.type}'),
                Text('Manufacturer: ${info.manufacturer}'),
                Text('Size: ${info.size}'),
                Text('Model Number: ${info.modelNo}'),
                const SizedBox(height: 16),
                const Text('Shutoff Valves:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Status: ${info.shutoffValves.status}'),
                Text('Comment: ${info.shutoffValves.comment}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
