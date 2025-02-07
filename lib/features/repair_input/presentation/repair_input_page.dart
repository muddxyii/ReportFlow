import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_flow/core/models/profile.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/core/widgets/form_checkbox_field.dart';
import 'package:report_flow/core/widgets/profile_selection_dialog.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class RepairInputPage extends StatefulWidget {
  final Function(Repairs) onSave;
  final Repairs repairInfo;
  final String deviceType;

  const RepairInputPage({
    super.key,
    required this.onSave,
    required this.repairInfo,
    required this.deviceType,
  });

  @override
  State<RepairInputPage> createState() => _RepairInputPageState();
}

class _RepairInputPageState extends State<RepairInputPage> {
  final _formKey = GlobalKey<FormState>();

  late Repairs _editedRepairs;

  @override
  void initState() {
    super.initState();
    _editedRepairs = widget.repairInfo;
  }

  String _getPageTitle() {
    return '${widget.deviceType} Repairs';
  }

  Widget _buildCheckValveTile({
    required String title,
    required CheckValveRepairs repairs,
    required Function(CheckValveRepairs) onChanged,
  }) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                FormCheckboxField(
                  label: 'Cleaned',
                  value: repairs.cleaned,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(cleaned: value)),
                ),
                FormCheckboxField(
                  label: 'Check Disc',
                  value: repairs.checkDisc,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(checkDisc: value)),
                ),
                FormCheckboxField(
                  label: 'Disc Holder',
                  value: repairs.discHolder,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(discHolder: value)),
                ),
                FormCheckboxField(
                  label: 'Spring',
                  value: repairs.spring,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(spring: value)),
                ),
                FormCheckboxField(
                  label: 'Guide',
                  value: repairs.guide,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(guide: value)),
                ),
                FormCheckboxField(
                  label: 'Seat',
                  value: repairs.seat,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(seat: value)),
                ),
                FormCheckboxField(
                  label: 'Other',
                  value: repairs.other,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(other: value)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReliefValveTile({
    required String title,
    required ReliefValveRepairs repairs,
    required Function(ReliefValveRepairs) onChanged,
  }) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                FormCheckboxField(
                  label: 'Cleaned',
                  value: repairs.cleaned,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(cleaned: value)),
                ),
                FormCheckboxField(
                  label: 'Rubbet Kit',
                  value: repairs.rubberKit,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(rubberKit: value)),
                ),
                FormCheckboxField(
                  label: 'Disc Holder',
                  value: repairs.discHolder,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(discHolder: value)),
                ),
                FormCheckboxField(
                  label: 'Spring',
                  value: repairs.spring,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(spring: value)),
                ),
                FormCheckboxField(
                  label: 'Guide',
                  value: repairs.guide,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(guide: value)),
                ),
                FormCheckboxField(
                  label: 'Seat',
                  value: repairs.seat,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(seat: value)),
                ),
                FormCheckboxField(
                  label: 'Other',
                  value: repairs.other,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(other: value)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVacuumBreakerTile({
    required String title,
    required VacuumBreakerRepairs repairs,
    required Function(VacuumBreakerRepairs) onChanged,
  }) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                FormCheckboxField(
                  label: 'Cleaned',
                  value: repairs.cleaned,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(cleaned: value)),
                ),
                FormCheckboxField(
                  label: 'Rubbet Kit',
                  value: repairs.rubberKit,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(rubberKit: value)),
                ),
                FormCheckboxField(
                  label: 'Disc Holder',
                  value: repairs.discHolder,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(discHolder: value)),
                ),
                FormCheckboxField(
                  label: 'Spring',
                  value: repairs.spring,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(spring: value)),
                ),
                FormCheckboxField(
                  label: 'Guide',
                  value: repairs.guide,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(guide: value)),
                ),
                FormCheckboxField(
                  label: 'Seat',
                  value: repairs.seat,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(seat: value)),
                ),
                FormCheckboxField(
                  label: 'Other',
                  value: repairs.other,
                  onChanged: (value) =>
                      onChanged(repairs.copyWith(other: value)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCk1Tile() {
    return _buildCheckValveTile(
      title: 'CK #1',
      repairs: _editedRepairs.checkValve1Repairs,
      onChanged: (repairs) => setState(() {
        _editedRepairs = _editedRepairs.copyWith(checkValve1Repairs: repairs);
      }),
    );
  }

  Widget _getCk2Tile() {
    return _buildCheckValveTile(
      title: 'CK #2',
      repairs: _editedRepairs.checkValve2Repairs,
      onChanged: (repairs) => setState(() {
        _editedRepairs = _editedRepairs.copyWith(checkValve2Repairs: repairs);
      }),
    );
  }

  Widget _getRvTile() {
    return _buildReliefValveTile(
      title: 'RV',
      repairs: _editedRepairs.reliefValveRepairs,
      onChanged: (repairs) => setState(() {
        _editedRepairs = _editedRepairs.copyWith(reliefValveRepairs: repairs);
      }),
    );
  }

  Widget _getVacuumBreakerTile() {
    return _buildVacuumBreakerTile(
      title: 'Vacuum Breaker',
      repairs: _editedRepairs.vacuumBreakerRepairs,
      onChanged: (repairs) => setState(() {
        _editedRepairs = _editedRepairs.copyWith(vacuumBreakerRepairs: repairs);
      }),
    );
  }

  Widget _getRepairTiles() {
    switch (widget.deviceType.toUpperCase()) {
      case 'DC':
        return Column(
          children: [_getCk1Tile(), _getCk2Tile()],
        );
      case 'RP':
        return Column(
          children: [_getCk1Tile(), _getCk2Tile(), _getRvTile()],
        );
      case 'PVB':
        return Column(
          children: [_getVacuumBreakerTile()],
        );
      case 'SVB':
        return Column(
          children: [_getVacuumBreakerTile()],
        );
      case 'SC':
        return Column(
          children: [_getCk1Tile()],
        );
      case 'TYPE 2':
        return Column(
          children: [Text('Type 2 repairs are not supported yet')],
        );
      default:
        return Text('Type "${widget.deviceType}" not supported');
    }
  }

  void _handleSave() async {
    final selectedProfile = await showDialog<Profile>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const ProfileSelectionDialog(
        isRepair: true,
      ),
    );

    if (selectedProfile != null && mounted) {
      final TesterProfile profile = TesterProfile(
          name: selectedProfile.testerName,
          certNo: selectedProfile.repairCertNo,
          gaugeKit: selectedProfile.testKitSerial,
          date: DateFormat('MM/dd/yyyy').format(DateTime.now()));

      _editedRepairs = _editedRepairs.copyWith(testerProfile: profile);
      widget.onSave(_editedRepairs);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleSave,
        child: const Icon(Icons.save),
      ),
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getRepairTiles(),
          ],
        ),
      ),
    );
  }
}
