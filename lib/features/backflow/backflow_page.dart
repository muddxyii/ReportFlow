import 'package:flutter/material.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/features/backflow/widgets/device/comments_info_card.dart';
import 'package:reportflow/features/backflow/widgets/device/device_info_card.dart';
import 'package:reportflow/features/backflow/widgets/device/permit_info_card.dart';
import 'package:reportflow/features/backflow/widgets/device/sov_info_card.dart';
import 'package:reportflow/features/backflow/widgets/installation_info_card.dart';
import 'package:reportflow/features/backflow/widgets/location_info_card.dart';
import 'package:reportflow/features/backflow/widgets/test/test_info_card.dart';
import 'package:reportflow/features/settings/presentation/settings_page.dart';

class BackflowPage extends StatefulWidget {
  final Backflow backflow;

  final Function(Backflow) onInfoUpdate;
  final Future<bool> Function(Backflow) onSharePdf;

  const BackflowPage({
    super.key,
    required this.backflow,
    required this.onInfoUpdate,
    required this.onSharePdf,
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
      backflow = backflow.copyWith(finalTest: updatedTest, isComplete: false);
    });
    widget.onInfoUpdate(backflow);
  }

  bool _hasExistingTestData() {
    if (backflow.initialTest.testerProfile.name.isNotEmpty ||
        backflow.repairs.testerProfile.name.isNotEmpty ||
        backflow.finalTest.testerProfile.name.isNotEmpty) {
      return true;
    }

    return false;
  }

  void _resetTestData() {
    setState(() {
      backflow = backflow.copyWith(
          initialTest: Test.empty(),
          repairs: Repairs.empty(),
          finalTest: Test.empty(),
          isComplete: false);
    });
    widget.onInfoUpdate(backflow);
  }

  String _getPageTitle() {
    return '${backflow.deviceInfo.serialNo} Details';
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
      title: Text(_getPageTitle()),
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
          PermitInfoCard(
              info: backflow.deviceInfo, onInfoUpdate: _updateDeviceInfo),
          const SizedBox(height: 8),
          DeviceInfoCard(
            info: backflow.deviceInfo,
            onInfoUpdate: _updateDeviceInfo,
            lockDeviceType: _hasExistingTestData(),
          ),
          const SizedBox(height: 8),
          SovInfoCard(
              info: backflow.deviceInfo, onInfoUpdate: _updateDeviceInfo),
          const SizedBox(height: 8),
          TestInfoCard(
            backflow: backflow,
            onInitialTestUpdate: _updateInitialTest,
            onRepairsUpdate: _updateRepairs,
            onFinalTestUpdate: _updateFinalTest,
            onResetTestData: _resetTestData,
          ),
          const SizedBox(height: 8),
          CommentsInfoCard(
              info: backflow.deviceInfo, onInfoUpdate: _updateDeviceInfo),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _sharePdf(),
              child: const Text('Generate Pdf'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sharePdf() async {
    final shouldMarkComplete = await widget.onSharePdf(backflow);
    if (shouldMarkComplete) {
      setState(() {
        backflow = backflow.copyWith(isComplete: true);
      });
      widget.onInfoUpdate(backflow);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
