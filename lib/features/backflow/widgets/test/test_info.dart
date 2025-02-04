import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/core/widgets/info_field.dart';

class TestInfo extends StatelessWidget {
  final Test test;
  final String deviceType;

  const TestInfo({super.key, required this.test, required this.deviceType});

  Icon _getCheckIcon(bool checkCtStatus) {
    if (checkCtStatus) {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
      );
    }

    return Icon(
      Icons.cancel,
      color: Colors.red,
    );
  }

  Widget _buildCheckValveInfo(
      BuildContext context, String label, CheckValve valve) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$label ',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            _getCheckIcon(valve.closedTight)
          ],
        ),
        Text('Val: ${valve.value}'),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDeviceSpecificInfo(BuildContext context) {
    switch (deviceType.toLowerCase()) {
      case 'dc':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child:
                      _buildCheckValveInfo(context, 'CV-1', test.checkValve1),
                ),
                Expanded(
                  child:
                      _buildCheckValveInfo(context, 'CV-2', test.checkValve2),
                )
              ],
            ),
          ],
        );

      case 'rp':
        return Column(
          children: [
            Text('No rp support yet'),
          ],
        );
      default:
        return Column(
          children: [
            Text('Unknown device type: $deviceType'),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoField(label: 'PSI', value: test.linePressure),
        _buildDeviceSpecificInfo(context),
        InfoField(
            label: 'Tester',
            value: test.testerProfile.name.isEmpty
                ? 'Unknown'
                : test.testerProfile.name),
        InfoField(
            label: 'Date',
            value: test.testerProfile.date.isEmpty
                ? 'Unknown'
                : test.testerProfile.date),
      ],
    );
  }
}
