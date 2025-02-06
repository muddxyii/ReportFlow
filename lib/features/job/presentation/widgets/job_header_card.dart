import 'package:flutter/material.dart';

class JobHeaderCard extends StatelessWidget {
  final String jobName;
  final String jobType;

  const JobHeaderCard({
    super.key,
    required this.jobName,
    required this.jobType,
  });

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
            ],
          ),
        ),
      ),
    );
  }
}
