import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/core/widgets/form_input_field.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class TestInputPage extends StatefulWidget {
  final Function(Test) onSave;

  const TestInputPage({super.key, required this.onSave});

  @override
  State<TestInputPage> createState() => _TestInputPageState();
}

class _TestInputPageState extends State<TestInputPage> {
  final _formKey = GlobalKey<FormState>();

  late Test _editedTest;
  String linePressure = '';
  bool cv1ClosedTight = false;
  bool cv2ClosedTight = false;
  String cv1Value = '';
  String cv2Value = '';
  String rvValue = '';
  bool rvOpened = false;

  // Vacuum Breaker
  bool vbBackPressure = false;
  String vbAirInletValue = '';
  bool vbAirInletLeaked = false;
  bool vbAirInletOpened = false;
  String vbCheckValue = '';
  bool vbCheckLeaked = false;

  // Tester Profile
  String testerName = '';
  String certNo = '';
  String gaugeKit = '';
  String date = '';

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final test = Test(
        linePressure: linePressure,
        checkValve1: CheckValve(
          value: cv1Value,
          closedTight: cv1ClosedTight,
        ),
        checkValve2: CheckValve(
          value: cv2Value,
          closedTight: cv2ClosedTight,
        ),
        reliefValve: ReliefValve(
          value: rvValue,
          opened: rvOpened,
        ),
        vacuumBreaker: VacuumBreaker(
          backPressure: vbBackPressure,
          airInlet: AirInlet(
            value: vbAirInletValue,
            leaked: vbAirInletLeaked,
            opened: vbAirInletOpened,
          ),
          check: Check(
            value: vbCheckValue,
            leaked: vbCheckLeaked,
          ),
        ),
        testerProfile: TesterProfile(
          name: testerName,
          certNo: certNo,
          gaugeKit: gaugeKit,
          date: date,
        ),
      );

      widget.onSave(test);
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
      title: const Text('Initial Test'),
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
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line Pressure
              FormInputField(
                label: 'Line Pressure',
                textInputType: TextInputType.number,
                validateValue: true,
                onSaved: (value) => _editedTest =
                    _editedTest.copyWith(linePressure: value ?? ''),
              ),
              const SizedBox(height: 16),

              // Check Valve 1
              Text('Check Valve #1',
                  style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Value'),
                onChanged: (value) => setState(() => cv1Value = value),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              CheckboxListTile(
                title: const Text('Closed Tight'),
                value: cv1ClosedTight,
                onChanged: (value) =>
                    setState(() => cv1ClosedTight = value ?? false),
              ),
              const SizedBox(height: 16),

              // Check Valve 2
              Text('Check Valve #2',
                  style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Value'),
                onChanged: (value) => setState(() => cv2Value = value),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              CheckboxListTile(
                title: const Text('Closed Tight'),
                value: cv2ClosedTight,
                onChanged: (value) =>
                    setState(() => cv2ClosedTight = value ?? false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
