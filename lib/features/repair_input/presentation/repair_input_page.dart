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

  Widget _getCk1Tile() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          'CK #1',
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
                    value: _editedRepairs.checkValve1Repairs.cleaned,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve1Repairs: _editedRepairs
                                .checkValve1Repairs
                                .copyWith(cleaned: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Check Disc',
                    value: _editedRepairs.checkValve1Repairs.checkDisc,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve1Repairs: _editedRepairs
                                .checkValve1Repairs
                                .copyWith(checkDisc: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Disc Holder',
                    value: _editedRepairs.checkValve1Repairs.discHolder,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve1Repairs: _editedRepairs
                                .checkValve1Repairs
                                .copyWith(discHolder: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Spring',
                    value: _editedRepairs.checkValve1Repairs.spring,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve1Repairs: _editedRepairs
                                .checkValve1Repairs
                                .copyWith(spring: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Guide',
                    value: _editedRepairs.checkValve1Repairs.guide,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve1Repairs: _editedRepairs
                                .checkValve1Repairs
                                .copyWith(guide: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Seat',
                    value: _editedRepairs.checkValve1Repairs.seat,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve1Repairs: _editedRepairs
                                .checkValve1Repairs
                                .copyWith(seat: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Other',
                    value: _editedRepairs.checkValve1Repairs.other,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve1Repairs: _editedRepairs
                                .checkValve1Repairs
                                .copyWith(other: value));
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCk2Tile() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          'CK 2',
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
                    value: _editedRepairs.checkValve2Repairs.cleaned,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve2Repairs: _editedRepairs
                                .checkValve2Repairs
                                .copyWith(cleaned: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Check Disc',
                    value: _editedRepairs.checkValve2Repairs.checkDisc,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve2Repairs: _editedRepairs
                                .checkValve2Repairs
                                .copyWith(checkDisc: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Disc Holder',
                    value: _editedRepairs.checkValve2Repairs.discHolder,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve2Repairs: _editedRepairs
                                .checkValve2Repairs
                                .copyWith(discHolder: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Spring',
                    value: _editedRepairs.checkValve2Repairs.spring,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve2Repairs: _editedRepairs
                                .checkValve2Repairs
                                .copyWith(spring: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Guide',
                    value: _editedRepairs.checkValve2Repairs.guide,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve2Repairs: _editedRepairs
                                .checkValve2Repairs
                                .copyWith(guide: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Seat',
                    value: _editedRepairs.checkValve2Repairs.seat,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve2Repairs: _editedRepairs
                                .checkValve2Repairs
                                .copyWith(seat: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Other',
                    value: _editedRepairs.checkValve2Repairs.other,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            checkValve2Repairs: _editedRepairs
                                .checkValve2Repairs
                                .copyWith(other: value));
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRvTile() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          'Relief Valve',
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
                    value: _editedRepairs.reliefValveRepairs.cleaned,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            reliefValveRepairs: _editedRepairs
                                .reliefValveRepairs
                                .copyWith(cleaned: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Rubber Kit',
                    value: _editedRepairs.reliefValveRepairs.rubberKit,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            reliefValveRepairs: _editedRepairs
                                .reliefValveRepairs
                                .copyWith(rubberKit: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Disc Holder',
                    value: _editedRepairs.reliefValveRepairs.discHolder,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            reliefValveRepairs: _editedRepairs
                                .reliefValveRepairs
                                .copyWith(discHolder: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Spring',
                    value: _editedRepairs.reliefValveRepairs.spring,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            reliefValveRepairs: _editedRepairs
                                .reliefValveRepairs
                                .copyWith(spring: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Guide',
                    value: _editedRepairs.reliefValveRepairs.guide,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            reliefValveRepairs: _editedRepairs
                                .reliefValveRepairs
                                .copyWith(guide: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Seat',
                    value: _editedRepairs.reliefValveRepairs.seat,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            reliefValveRepairs: _editedRepairs
                                .reliefValveRepairs
                                .copyWith(seat: value));
                      });
                    }),
                FormCheckboxField(
                    label: 'Other',
                    value: _editedRepairs.reliefValveRepairs.other,
                    onChanged: (bool? value) {
                      setState(() {
                        _editedRepairs = _editedRepairs.copyWith(
                            reliefValveRepairs: _editedRepairs
                                .reliefValveRepairs
                                .copyWith(other: value));
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
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
      case 'SC':
        return Column(
          children: [_getCk1Tile()],
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
