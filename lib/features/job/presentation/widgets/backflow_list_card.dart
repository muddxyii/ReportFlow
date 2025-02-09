import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/core/widgets/info_field.dart';
import 'package:report_flow/features/backflow/backflow_page.dart';

class BackflowListCard extends StatefulWidget {
  final BackflowList list;
  final CustomerInformation customerInfo;
  final Function(BackflowList) onInfoUpdate;

  const BackflowListCard({
    super.key,
    required this.list,
    required this.customerInfo,
    required this.onInfoUpdate,
  });

  @override
  State<BackflowListCard> createState() => _BackflowListCardState();
}

class _BackflowListCardState extends State<BackflowListCard> {
  final _searchController = TextEditingController();
  late List<MapEntry<String, Backflow>> _filteredBackflows;

  @override
  void initState() {
    super.initState();
    _filterBackflows('');
  }

  @override
  void didUpdateWidget(BackflowListCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list != widget.list) {
      _filterBackflows('');
      _searchController.text = '';
    }
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
          .toList()
        ..sort((a, b) => a.value.isComplete == b.value.isComplete
            ? 0
            : a.value.isComplete
                ? 1
                : -1);
    });
  }

  void _updateBackflow(String key, Backflow updatedBackflow) {
    setState(() {
      final updatedBackflows =
          Map<String, Backflow>.from(widget.list.backflows);
      updatedBackflows[key] = updatedBackflow;
      widget.onInfoUpdate(widget.list.copyWith(backflows: updatedBackflows));
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
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
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
                final entry = _filteredBackflows[index];
                final key = entry.key;
                final device = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    color: device.isComplete ? const Color(0xFFE7F5E7) : null,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  device.deviceInfo.serialNo.isNotEmpty
                                      ? device.deviceInfo.serialNo
                                      : "Unknown Serial",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                  // TODO: Implement more_vert bar settings
                                  // Stuff like 'Mark As Complete'
                                  onPressed: null,
                                  icon: const Icon(Icons.more_vert))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: InfoField(
                                  label: 'Model',
                                  value: device.deviceInfo.modelNo.isNotEmpty
                                      ? device.deviceInfo.modelNo
                                      : "Unknown",
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InfoField(
                                  label: 'Size',
                                  value: device.deviceInfo.size.isNotEmpty
                                      ? device.deviceInfo.size
                                      : "Unk..",
                                ),
                              ),
                            ],
                          ),
                          InfoField(
                              label: 'Location',
                              value:
                                  device.locationInfo.onSiteLocation.isNotEmpty
                                      ? device.locationInfo.onSiteLocation
                                      : "Unknown"),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (device.isComplete)
                                IconButton(
                                    // TODO: Implement pdf gen / sharing
                                    onPressed: null,
                                    icon: const Icon(Icons.ios_share)),
                              IconButton(
                                icon: const Icon(Icons.assignment),
                                onPressed: () async {
                                  if (!mounted) return;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BackflowPage(
                                        backflow: device,
                                        customerInfo: widget.customerInfo,
                                        onInfoUpdate: (updatedBackflow) {
                                          _updateBackflow(key, updatedBackflow);
                                        },
                                      ),
                                    ),
                                  );
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
