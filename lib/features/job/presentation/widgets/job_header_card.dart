import 'package:flutter/material.dart';
import 'package:reportflow/core/models/report_flow_types.dart';

class JobHeaderCard extends StatelessWidget {
  final String jobName;
  final String jobType;
  final BackflowList list;

  const JobHeaderCard(
      {super.key,
      required this.jobName,
      required this.jobType,
      required this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(jobType, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  // Total/Completed ratio
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.assignment, size: 16),
                      const SizedBox(width: 4),
                      Text(
                          '${list.getCompletedCount()}/${list.backflows.length}'),
                    ],
                  ),
                  // Failed
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cancel_outlined,
                          size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text('${list.getFailedCount()}'),
                    ],
                  ),
                  // Repaired
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.build_outlined,
                          size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text('${list.getRepairCount()}'),
                    ],
                  ),
                  // Passed
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text('${list.getPassedCount()}'),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
