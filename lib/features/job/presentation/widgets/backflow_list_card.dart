import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/core/widgets/info_field.dart';
import 'package:report_flow/features/backflow/backflow_page.dart';

class BackflowListCard extends StatefulWidget {
  final BackflowList list;
  final Function(BackflowList) onInfoUpdate;
  final Future<bool> Function(Backflow) onSharePdf;

  const BackflowListCard({
    super.key,
    required this.list,
    required this.onInfoUpdate,
    required this.onSharePdf,
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

  void _addBackflow([Backflow? backflowTemplate]) async {
    final serialNumber = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String serialNo = '';
        return AlertDialog(
          title: const Text('Add New Backflow'),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Serial Number',
            ),
            onChanged: (value) => serialNo = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, serialNo),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (serialNumber != null && serialNumber.isNotEmpty) {
      // Create a new Backflow instance with the serial number
      late Backflow newBackflow = Backflow(
        locationInfo: LocationInfo(
            assemblyAddress: '', onSiteLocation: '', primaryService: ''),
        installationInfo:
            InstallationInfo(status: '', protectionType: '', serviceType: ''),
        deviceInfo: DeviceInfo(
            serialNo: serialNumber,
            shutoffValves: ShutoffValves(status: '', comment: '')),
        initialTest: Test.empty(),
        repairs: Repairs.empty(),
        finalTest: Test.empty(),
        isComplete: false,
      );

      if (backflowTemplate != null) {
        newBackflow = backflowTemplate.copyWith(
            deviceInfo:
                backflowTemplate.deviceInfo.copyWith(serialNo: serialNumber));
      }

      // Update the backflows map
      final updatedBackflows =
          Map<String, Backflow>.from(widget.list.backflows);
      updatedBackflows[serialNumber] = newBackflow;

      // Update the list using the callback
      widget.onInfoUpdate(widget.list.copyWith(backflows: updatedBackflows));

      // Navigate to the backflow page
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BackflowPage(
              backflow: newBackflow,
              onInfoUpdate: (updatedBackflow) =>
                  _updateBackflow(serialNumber, updatedBackflow),
              onSharePdf: widget.onSharePdf,
            ),
          ),
        );
      }
    }
  }

  void _updateBackflow(String key, Backflow updatedBackflow) {
    setState(() {
      final updatedBackflows =
          Map<String, Backflow>.from(widget.list.backflows);
      updatedBackflows[key] = updatedBackflow;
      widget.onInfoUpdate(widget.list.copyWith(backflows: updatedBackflows));
    });
  }

  void _showDeleteConfirmationDialog(String serialNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Backflow'),
          content:
              Text('Are you sure you want to remove backflow $serialNumber?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Remove the backflow from the list
                final updatedBackflows =
                    Map<String, Backflow>.from(widget.list.backflows);
                updatedBackflows.remove(serialNumber);

                // Update the list using the callback
                widget.onInfoUpdate(
                    widget.list.copyWith(backflows: updatedBackflows));

                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Backflows',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () => _addBackflow(),
                  label: const Text('Add'),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
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
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (String value) {
                                  switch (value) {
                                    case 'remove':
                                      _showDeleteConfirmationDialog(key);
                                      break;
                                    case 'duplicate':
                                      _addBackflow(device);
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'remove',
                                    child: Text('Remove'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'duplicate',
                                    child: Text('Duplicate'),
                                  ),
                                  // Add more PopupMenuItems here for additional options
                                ],
                              )
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
                                    onPressed: () => widget.onSharePdf(device),
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
                                        onInfoUpdate: (updatedBackflow) {
                                          _updateBackflow(key, updatedBackflow);
                                        },
                                        onSharePdf: (Backflow backflow) {
                                          return widget.onSharePdf(backflow);
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
