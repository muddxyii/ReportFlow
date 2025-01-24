import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class BackflowListCard extends StatefulWidget {
  final BackflowList list;

  const BackflowListCard({super.key, required this.list});

  @override
  State<BackflowListCard> createState() => _BackflowListCardState();
}

class _BackflowListCardState extends State<BackflowListCard> {
  final _searchController = TextEditingController();
  late List<MapEntry<String, Backflow>> _filteredBackflows;

  @override
  void initState() {
    super.initState();
    _filteredBackflows = widget.list.backflows.entries.toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBackflows(String query) {
    setState(() {
      _filteredBackflows = widget.list.backflows.entries
          .where((entry) => entry.value.deviceInfo.serialNo
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backflows',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterBackflows,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredBackflows.length,
              itemBuilder: (context, index) {
                final device = _filteredBackflows[index].value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.deviceInfo.serialNo.isNotEmpty
                                ? device.deviceInfo.serialNo
                                : "Unknown Serial",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Model: ${device.deviceInfo.modelNo.isNotEmpty ? device.deviceInfo.modelNo : "Unknown"}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Size: ${device.deviceInfo.size.isNotEmpty ? device.deviceInfo.size : "Unknown"}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Location: ${device.locationInfo.onSiteLocation.isNotEmpty ? device.locationInfo.onSiteLocation : "Unknown"}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  //TODO: IMPLEMENT BACKFLOW EDITING
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
