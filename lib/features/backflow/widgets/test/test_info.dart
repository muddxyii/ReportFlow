import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class TestInfo extends StatelessWidget {
  final Test test;

  const TestInfo({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Line Pressure: ${test.linePressure}'),
        Text('Tester: ${test.testerProfile.name}'),
        Text('Date: ${test.testerProfile.date}'),
      ],
    );
  }
}
