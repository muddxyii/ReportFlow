import 'package:flutter/material.dart';

class TestStatusCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool initiallyExpanded;
  final List<Widget> content;

  const TestStatusCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.initiallyExpanded = false,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: Icon(icon, color: iconColor, size: 24),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ],
      ),
    );
  }
}
