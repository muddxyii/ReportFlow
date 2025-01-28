import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/features/backflow/widgets/device_info_card.dart';
import 'package:report_flow/features/backflow/widgets/installation_info_card.dart';
import 'package:report_flow/features/backflow/widgets/location_info_card.dart';
import 'package:report_flow/features/backflow/widgets/test/test_info_card.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class BackflowPage extends StatefulWidget {
  final Backflow backflow;

  final Function(Backflow) onInfoUpdate;

  const BackflowPage({
    super.key,
    required this.backflow,
    required this.onInfoUpdate,
  });

  @override
  State<BackflowPage> createState() => _BackflowPageState();
}

class _BackflowPageState extends State<BackflowPage> {
  late Backflow backflow;

  @override
  void initState() {
    super.initState();
    backflow = widget.backflow;
  }

  @override
  void didUpdateWidget(BackflowPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backflow != widget.backflow) {
      backflow = widget.backflow;
    }
  }

  void _updateLocationInfo(LocationInfo updatedInfo) {
    setState(() {
      backflow = backflow.copyWith(locationInfo: updatedInfo);
    });
    widget.onInfoUpdate(backflow);
  }

  void _updateInstallationInfo(InstallationInfo updatedInfo) {
    setState(() {
      backflow = backflow.copyWith(installationInfo: updatedInfo);
    });
    widget.onInfoUpdate(backflow);
  }

  void _updateDeviceInfo(DeviceInfo updatedInfo) {
    setState(() {
      backflow = backflow.copyWith(deviceInfo: updatedInfo);
    });
    widget.onInfoUpdate(backflow);
  }

  void _updateInitialTest(Test updatedTest) {
    setState(() {
      backflow = backflow.copyWith(initialTest: updatedTest);
    });
    widget.onInfoUpdate(backflow);
  }

  void _updateRepairs(Repairs updatedRepairs) {
    setState(() {
      backflow = backflow.copyWith(repairs: updatedRepairs);
    });
    widget.onInfoUpdate(backflow);
  }

  void _updateFinalTest(Test updatedTest) {
    setState(() {
      backflow = backflow.copyWith(finalTest: updatedTest);
    });
    widget.onInfoUpdate(backflow);
  }

  void _updateCompletionStatus(bool updatedStatus) {
    setState(() {
      backflow = backflow.copyWith(isComplete: updatedStatus);
    });
    widget.onInfoUpdate(backflow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Backflow Details'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationInfoCard(
            info: backflow.locationInfo,
            onInfoUpdate: _updateLocationInfo,
          ),
          const SizedBox(height: 8),
          InstallationInfoCard(
            info: backflow.installationInfo,
            onInfoUpdate: _updateInstallationInfo,
          ),
          const SizedBox(height: 8),
          DeviceInfoCard(
            info: backflow.deviceInfo,
            onInfoUpdate: _updateDeviceInfo,
          ),
          const SizedBox(height: 8),
          TestInfoCard(
            backflow: backflow,
            onInitialTestUpdate: _updateInitialTest,
            onRepairsUpdate: _updateRepairs,
            onFinalTestUpdate: _updateFinalTest,
            onCompletionStatusUpdate: _updateCompletionStatus,
          ),
        ],
      ),
    );
  }
}
