import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/features/backflow/widgets/test/test_info.dart';
import 'package:report_flow/features/backflow/widgets/test/test_status_card.dart';
import 'package:report_flow/features/test_input/test_input_page.dart';

class TestInfoCard extends StatefulWidget {
  final Backflow backflow;
  final Function(Test) onInitialTestUpdate;
  final Function(Repairs) onRepairsUpdate;
  final Function(Test) onFinalTestUpdate;
  final Function(bool) onCompletionStatusUpdate;

  const TestInfoCard({
    super.key,
    required this.backflow,
    required this.onInitialTestUpdate,
    required this.onRepairsUpdate,
    required this.onFinalTestUpdate,
    required this.onCompletionStatusUpdate,
  });

  @override
  State<TestInfoCard> createState() => _TestInfoCardState();
}

class _TestInfoCardState extends State<TestInfoCard> {
  late Backflow _editedBackflow;

  @override
  void initState() {
    super.initState();
    _editedBackflow = widget.backflow;
  }

  @override
  void didUpdateWidget(TestInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backflow != widget.backflow) {
      _editedBackflow = widget.backflow;
    }
  }

  void _navigateToTestInput({bool isFinalTest = false}) async {
    final test = await Navigator.push<Test>(
      context,
      MaterialPageRoute(
        builder: (context) => TestInputPage(
          onSave: (test) => isFinalTest
              ? widget.onFinalTestUpdate(test)
              : widget.onInitialTestUpdate(test),
          deviceType: _editedBackflow.deviceInfo.type,
        ),
      ),
    );

    if (test != null) {
      setState(() {
        _editedBackflow = _editedBackflow.copyWith(
          initialTest: isFinalTest ? _editedBackflow.initialTest : test,
          finalTest: isFinalTest ? test : _editedBackflow.finalTest,
        );
      });
    }
  }

  void _navigateToRepairs() async {
    // TODO: Implement repairs navigation
    final repairs = Repairs(
      checkValve1Repairs: CheckValveRepairs(
        cleaned: true,
        checkDisc: false,
        discHolder: false,
        spring: false,
        guide: false,
        seat: false,
        other: false,
      ),
      checkValve2Repairs: CheckValveRepairs(
        cleaned: true,
        checkDisc: false,
        discHolder: false,
        spring: false,
        guide: false,
        seat: false,
        other: false,
      ),
      reliefValveRepairs: ReliefValveRepairs(
        cleaned: true,
        rubberKit: false,
        discHolder: false,
        spring: false,
        guide: false,
        seat: false,
        other: false,
      ),
      vacuumBreakerRepairs: VacuumBreakerRepairs(
        cleaned: true,
        rubberKit: false,
        discHolder: false,
        spring: false,
        guide: false,
        seat: false,
        other: false,
      ),
      testerProfile: TesterProfile(
        name: "John Doe",
        certNo: "12345",
        gaugeKit: "ABC123",
        date: DateTime.now().toIso8601String(),
      ),
    );
    widget.onRepairsUpdate(repairs);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Test Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.manage_history,
                    size: 28,
                  ),
                  onPressed: () {
                    // TODO: Implement reset logic
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_editedBackflow.finalTest.linePressure.isNotEmpty) ...[
              TestStatusCard(
                icon: Icons.check_circle,
                iconColor: Colors.green,
                title: 'Final Test Completed',
                content: [TestInfo(test: _editedBackflow.finalTest)],
              ),
            ] else ...[
              if (_editedBackflow.initialTest.linePressure.isEmpty)
                TestStatusCard(
                  icon: Icons.pending,
                  iconColor: Colors.grey,
                  title: 'Initial Test Required',
                  content: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToTestInput(),
                        child: const Text('Perform Initial Test'),
                      ),
                    ),
                  ],
                )
              else ...[
                TestStatusCard(
                  icon: Icons.cancel,
                  iconColor: Colors.red,
                  title: 'Initial Test',
                  content: [TestInfo(test: _editedBackflow.initialTest)],
                ),
                if (_editedBackflow.repairs.testerProfile.name.isEmpty)
                  TestStatusCard(
                    icon: Icons.build,
                    iconColor: Colors.orange,
                    title: 'Repairs Required',
                    content: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _navigateToRepairs,
                          child: const Text('Record Repairs'),
                        ),
                      ),
                    ],
                  )
                else ...[
                  TestStatusCard(
                    icon: Icons.build,
                    iconColor: Colors.orange,
                    title: 'Repairs Completed',
                    content: [
                      Text(
                          'Tester: ${_editedBackflow.repairs.testerProfile.name}'),
                      Text(
                          'Date: ${_editedBackflow.repairs.testerProfile.date}'),
                    ],
                  ),
                  TestStatusCard(
                    icon: Icons.pending,
                    iconColor: Colors.grey,
                    title: 'Final Test Required',
                    content: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              _navigateToTestInput(isFinalTest: true),
                          child: const Text('Perform Final Test'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }
}
