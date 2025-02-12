import 'package:flutter/material.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/core/widgets/info_field.dart';

class RepairInfo extends StatelessWidget {
  final Repairs repairs;
  final String deviceType;

  const RepairInfo(
      {super.key, required this.repairs, required this.deviceType});

  Widget _buildRepairSection(
      BuildContext context, String title, Map<String, bool> repairItems) {
    final selectedRepairs =
        repairItems.entries.where((entry) => entry.value).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        selectedRepairs.isEmpty
            ? const Chip(label: Text('No Repairs'))
            : Wrap(
                spacing: 8,
                children: selectedRepairs
                    .map((entry) => Chip(
                          label: Text(entry.key),
                        ))
                    .toList(),
              ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDeviceSpecificInfo(BuildContext context) {
    switch (deviceType.toUpperCase()) {
      case 'DC':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRepairSection(context, 'Check Valve 1', {
              'Cleaned': repairs.checkValve1Repairs.cleaned,
              'Check Disc': repairs.checkValve1Repairs.checkDisc,
              'Disc Holder': repairs.checkValve1Repairs.discHolder,
              'Spring': repairs.checkValve1Repairs.spring,
              'Guide': repairs.checkValve1Repairs.guide,
              'Seat': repairs.checkValve1Repairs.seat,
              'Other': repairs.checkValve1Repairs.other,
            }),
            _buildRepairSection(context, 'Check Valve 2', {
              'Cleaned': repairs.checkValve2Repairs.cleaned,
              'Check Disc': repairs.checkValve2Repairs.checkDisc,
              'Disc Holder': repairs.checkValve2Repairs.discHolder,
              'Spring': repairs.checkValve2Repairs.spring,
              'Guide': repairs.checkValve2Repairs.guide,
              'Seat': repairs.checkValve2Repairs.seat,
              'Other': repairs.checkValve2Repairs.other,
            }),
          ],
        );

      case 'RP':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRepairSection(context, 'Check Valve 1', {
              'Cleaned': repairs.checkValve1Repairs.cleaned,
              'Check Disc': repairs.checkValve1Repairs.checkDisc,
              'Disc Holder': repairs.checkValve1Repairs.discHolder,
              'Spring': repairs.checkValve1Repairs.spring,
              'Guide': repairs.checkValve1Repairs.guide,
              'Seat': repairs.checkValve1Repairs.seat,
              'Other': repairs.checkValve1Repairs.other,
            }),
            _buildRepairSection(context, 'Check Valve 2', {
              'Cleaned': repairs.checkValve2Repairs.cleaned,
              'Check Disc': repairs.checkValve2Repairs.checkDisc,
              'Disc Holder': repairs.checkValve2Repairs.discHolder,
              'Spring': repairs.checkValve2Repairs.spring,
              'Guide': repairs.checkValve2Repairs.guide,
              'Seat': repairs.checkValve2Repairs.seat,
              'Other': repairs.checkValve2Repairs.other,
            }),
            _buildRepairSection(context, 'Relief Valve', {
              'Cleaned': repairs.reliefValveRepairs.cleaned,
              'Rubber Kit': repairs.reliefValveRepairs.rubberKit,
              'Disc Holder': repairs.reliefValveRepairs.discHolder,
              'Spring': repairs.reliefValveRepairs.spring,
              'Guide': repairs.reliefValveRepairs.guide,
              'Seat': repairs.reliefValveRepairs.seat,
              'Other': repairs.reliefValveRepairs.other,
            }),
          ],
        );

      case 'PVB':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRepairSection(context, 'Pressure Vacuum Breaker', {
              'Cleaned': repairs.vacuumBreakerRepairs.cleaned,
              'Rubber Kit': repairs.vacuumBreakerRepairs.rubberKit,
              'Disc Holder': repairs.vacuumBreakerRepairs.discHolder,
              'Spring': repairs.vacuumBreakerRepairs.spring,
              'Guide': repairs.vacuumBreakerRepairs.guide,
              'Seat': repairs.vacuumBreakerRepairs.seat,
              'Other': repairs.vacuumBreakerRepairs.other,
            }),
          ],
        );

      case 'SVB':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRepairSection(context, 'Pressure Vacuum Breaker', {
              'Cleaned': repairs.vacuumBreakerRepairs.cleaned,
              'Rubber Kit': repairs.vacuumBreakerRepairs.rubberKit,
              'Disc Holder': repairs.vacuumBreakerRepairs.discHolder,
              'Spring': repairs.vacuumBreakerRepairs.spring,
              'Guide': repairs.vacuumBreakerRepairs.guide,
              'Seat': repairs.vacuumBreakerRepairs.seat,
              'Other': repairs.vacuumBreakerRepairs.other,
            }),
          ],
        );

      case 'SC':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRepairSection(context, 'Check Valve 1', {
              'Cleaned': repairs.checkValve1Repairs.cleaned,
              'Check Disc': repairs.checkValve1Repairs.checkDisc,
              'Disc Holder': repairs.checkValve1Repairs.discHolder,
              'Spring': repairs.checkValve1Repairs.spring,
              'Guide': repairs.checkValve1Repairs.guide,
              'Seat': repairs.checkValve1Repairs.seat,
              'Other': repairs.checkValve1Repairs.other,
            }),
          ],
        );

      case 'TYPE 2':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRepairSection(context, 'Check Valve 1', {
              'Cleaned': repairs.checkValve1Repairs.cleaned,
              'Check Disc': repairs.checkValve1Repairs.checkDisc,
              'Disc Holder': repairs.checkValve1Repairs.discHolder,
              'Spring': repairs.checkValve1Repairs.spring,
              'Guide': repairs.checkValve1Repairs.guide,
              'Seat': repairs.checkValve1Repairs.seat,
              'Other': repairs.checkValve1Repairs.other,
            }),
          ],
        );

      default:
        return Column(
          children: [
            Text('$deviceType repairs are not supported yet'),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDeviceSpecificInfo(context),
        InfoField(
            label: 'Tester',
            value: repairs.testerProfile.name.isEmpty
                ? 'Unknown'
                : repairs.testerProfile.name),
        InfoField(
            label: 'Date',
            value: repairs.testerProfile.date.isEmpty
                ? 'Unknown'
                : repairs.testerProfile.date),
      ],
    );
  }
}
