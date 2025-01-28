import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

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
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement test functionality
                },
                child: const Text('Perform Initial Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement test functionality
        },
        child: const Text('Perform Initial Test'),
      ),
    );
  }
}
