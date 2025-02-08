import 'package:flutter/material.dart';
import 'package:report_flow/core/logic/backflow_test_evaluator.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/features/backflow/widgets/test/base_test_card.dart';
import 'package:report_flow/features/backflow/widgets/test/repair_info.dart';
import 'package:report_flow/features/backflow/widgets/test/test_info.dart';
import 'package:report_flow/features/repair_input/presentation/repair_input_page.dart';
import 'package:report_flow/features/test_input/presentation/test_input_page.dart';

class TestInfoCard extends StatefulWidget {
  final Backflow backflow;
  final Function(Test) onInitialTestUpdate;
  final Function(Repairs) onRepairsUpdate;
  final Function(Test) onFinalTestUpdate;
  final Function() onResetTestData;

  const TestInfoCard({
    super.key,
    required this.backflow,
    required this.onInitialTestUpdate,
    required this.onRepairsUpdate,
    required this.onFinalTestUpdate,
    required this.onResetTestData,
  });

  @override
  State<TestInfoCard> createState() => _TestInfoCardState();
}

class _TestInfoCardState extends State<TestInfoCard> {
  late Backflow _editedBackflow;
  final _testEvaluator = BackflowTestEvaluator();

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
          onSave: (test) async {
            bool isInitialTest = !isFinalTest;
            if (isInitialTest) {
              String statusIcon = _testEvaluator.getStatusIcon(
                test,
                _editedBackflow.deviceInfo.type,
              );

              if (_testEvaluator.isPassing(statusIcon)) {
                // If initial test passes, use it as final test
                await widget.onFinalTestUpdate(test);
              } else {
                await widget.onInitialTestUpdate(test);
              }
            } else {
              await widget.onFinalTestUpdate(test);
            }
          },
          deviceType: _editedBackflow.deviceInfo.type,
          isFinalTest: isFinalTest,
        ),
      ),
    );
  }

  void _navigateToRepairs() async {
    final repairs = await Navigator.push<Repairs>(
      context,
      MaterialPageRoute(
        builder: (context) => RepairInputPage(
          onSave: widget.onRepairsUpdate,
          repairInfo: _editedBackflow.repairs,
          deviceType: _editedBackflow.deviceInfo.type,
        ),
      ),
    );

    if (repairs != null) {
      widget.onRepairsUpdate(repairs);
    }
  }

  void _resetTestData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Test Data"),
        content: const Text("Are you sure you want to reset all test data?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onResetTestData();
              Navigator.pop(context);
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasInitialTest = _editedBackflow.initialTest.linePressure.isNotEmpty;
    final hasRepairInfo = _editedBackflow.repairs.testerProfile.name.isNotEmpty;
    final hasFinalTest = _editedBackflow.finalTest.linePressure.isNotEmpty;

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
                  onPressed: _resetTestData,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // No test data - prompt for initial test
            if (!hasFinalTest && !hasInitialTest)
              _getInitialTestPrompt()
            // Only final test exists - show final card
            else if (hasFinalTest && !hasInitialTest)
              _getFinalTestCard()
            // Has initial test - show repair flow
            else if (hasInitialTest) ...[
              _getInitialTestCard(),
              //No repairs - prompt for repairs
              if (!hasRepairInfo)
                _getRepairPrompt()
              // Has repairs - show repair card and final test prompt/card
              else ...[
                _getRepairCard(),
                hasFinalTest ? _getFinalTestCard() : _getFinalTestPrompt()
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _getInitialTestPrompt() {
    return TestStatusCard(
      icon: Icons.pending,
      iconColor: Colors.grey,
      title: 'Initial Test Required',
      initiallyExpanded: true,
      content: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _navigateToTestInput(),
            child: const Text('Perform Initial Test'),
          ),
        ),
      ],
    );
  }

  Widget _getInitialTestCard() {
    return TestStatusCard(
      icon: Icons.cancel,
      iconColor: Colors.red,
      title: 'Initial Test Failed',
      onEditPressed: _editedBackflow.finalTest.linePressure.isNotEmpty
          ? null
          : _navigateToTestInput,
      content: [
        TestInfo(
            test: _editedBackflow.initialTest,
            deviceType: _editedBackflow.deviceInfo.type)
      ],
    );
  }

  Widget _getRepairPrompt() {
    return TestStatusCard(
      icon: Icons.build,
      iconColor: Colors.orange,
      title: 'Repairs Required',
      initiallyExpanded: true,
      content: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _navigateToRepairs,
            child: const Text('Record Repairs'),
          ),
        ),
      ],
    );
  }

  Widget _getRepairCard() {
    return TestStatusCard(
      icon: Icons.build,
      iconColor: Colors.orange,
      title: 'Repairs Completed',
      onEditPressed: _navigateToRepairs,
      content: [
        RepairInfo(
            repairs: _editedBackflow.repairs,
            deviceType: _editedBackflow.deviceInfo.type),
      ],
    );
  }

  Widget _getFinalTestPrompt() {
    return TestStatusCard(
      icon: Icons.pending,
      iconColor: Colors.grey,
      title: 'Final Test Required',
      initiallyExpanded: true,
      content: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _navigateToTestInput(isFinalTest: true),
            child: const Text('Perform Final Test'),
          ),
        ),
      ],
    );
  }

  Widget _getFinalTestCard() {
    return TestStatusCard(
      icon: Icons.check_circle,
      iconColor: Colors.green,
      title: 'Final Test Completed',
      onEditPressed: () => _navigateToTestInput(isFinalTest: true),
      content: [
        TestInfo(
            test: _editedBackflow.finalTest,
            deviceType: _editedBackflow.deviceInfo.type)
      ],
    );
  }
}
