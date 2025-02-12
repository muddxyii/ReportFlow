import 'package:flutter/material.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/core/widgets/info_field.dart';

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
        Text('$label ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        Row(
          children: [
            if (valve.value.isNotEmpty)
              Expanded(
                child: Text('Val: ${valve.value}'),
              ),
            Expanded(
              child: Row(
                children: [
                  Text('Ct: '),
                  _getCheckIcon(valve.closedTight),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildReliefValveInfo(
      BuildContext context, String label, ReliefValve rv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        Row(
          children: [
            if (rv.value.isNotEmpty)
              Expanded(
                child: Text('Val: ${rv.value}'),
              ),
            Expanded(
              child: Row(
                children: [
                  Text('Opened: '),
                  _getCheckIcon(rv.opened),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBackPressureInfo(
      BuildContext context, String label, bool backPressure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text('Status: ${backPressure ? 'Yes' : 'No'}'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAirInletInfo(
      BuildContext context, String label, AirInlet airInlet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        Row(
          children: [
            if (airInlet.value.isNotEmpty)
              Expanded(
                child: Text('Val: ${airInlet.value}'),
              ),
            Expanded(
              child: Row(
                children: [
                  Text('Opened: '),
                  _getCheckIcon(airInlet.opened),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCheckInfo(BuildContext context, String label, Check check) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        Row(
          children: [
            Expanded(
              child: Text('Val: ${check.value}'),
            ),
            Expanded(
              child: Row(
                children: [
                  Text('Leaked: '),
                  _getCheckIcon(check.leaked),
                ],
              ),
            ),
          ],
        ),
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
            _buildCheckValveInfo(context, 'CK #1', test.checkValve1),
            _buildCheckValveInfo(context, 'CK #2', test.checkValve2),
          ],
        );

      case 'rp':
        return Column(
          children: [
            _buildCheckValveInfo(context, 'CK #1', test.checkValve1),
            _buildCheckValveInfo(context, 'CK #2', test.checkValve2),
            _buildReliefValveInfo(context, 'RV', test.reliefValve),
          ],
        );

      case 'pvb':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackPressureInfo(
                context, 'Back Pressure', test.vacuumBreaker.backPressure),
            _buildAirInletInfo(
                context, 'Air Inlet', test.vacuumBreaker.airInlet),
            _buildCheckInfo(context, 'Check', test.vacuumBreaker.check),
          ],
        );

      case 'svb':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackPressureInfo(
                context, 'Back Pressure', test.vacuumBreaker.backPressure),
            _buildAirInletInfo(
                context, 'Air Inlet', test.vacuumBreaker.airInlet),
            _buildCheckInfo(context, 'Check', test.vacuumBreaker.check),
          ],
        );

      case 'sc':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckValveInfo(context, 'CK #1', test.checkValve1),
          ],
        );

      case 'type 2':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckValveInfo(context, 'CK #1', test.checkValve1),
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
