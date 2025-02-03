import 'package:flutter/material.dart';
import 'package:report_flow/core/logic/backflow_test_evaluator.dart';
import 'package:report_flow/core/models/report_flow_types.dart';
import 'package:report_flow/core/widgets/form_checkbox_field.dart';
import 'package:report_flow/core/widgets/form_input_field.dart';
import 'package:report_flow/core/widgets/info_field.dart';
import 'package:report_flow/features/settings/presentation/settings_page.dart';

class TestInputPage extends StatefulWidget {
  final Function(Test) onSave;
  final String deviceType;
  final bool isFinalTest;

  const TestInputPage(
      {super.key,
      required this.onSave,
      required this.deviceType,
      this.isFinalTest = false});

  @override
  State<TestInputPage> createState() => _TestInputPageState();
}

class _TestInputPageState extends State<TestInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _testEvaluator = BackflowTestEvaluator();
  final Map<String, FocusNode> _focusNodes = {};
  final List<String> _focusOrder = [];

  late Test _editedTest;

  @override
  void initState() {
    super.initState();
    _initializeFocusNodes();
    _editedTest = Test(
      linePressure: '',
      checkValve1: CheckValve(value: '', closedTight: false),
      checkValve2: CheckValve(value: '', closedTight: false),
      reliefValve: ReliefValve(value: '', opened: false),
      vacuumBreaker: VacuumBreaker(
        backPressure: false,
        airInlet: AirInlet(value: '', leaked: false, opened: false),
        check: Check(value: '', leaked: false),
      ),
      testerProfile: TesterProfile(
        name: '',
        certNo: '',
        gaugeKit: '',
        date: '',
      ),
    );
  }

  @override
  void dispose() {
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _initializeFocusNodes() {
    // Base fields
    _addFocusNode('linePressure');

    // DC specific fields
    switch (widget.deviceType) {
      case 'DC':
        _addFocusNode('cv1Value');
        _addFocusNode('cv2Value');
        break;
      default:
        break;
    }
  }

  void _addFocusNode(String key) {
    _focusNodes[key] = FocusNode();
    _focusOrder.add(key);
  }

  void _handleFieldSubmitted(String currentKey) {
    final currentIndex = _focusOrder.indexOf(currentKey);
    if (currentIndex < _focusOrder.length - 1) {
      _focusNodes[_focusOrder[currentIndex + 1]]?.requestFocus();
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_editedTest);
      Navigator.pop(context);
    }
  }

  String _getPageTitle() {
    if (widget.isFinalTest) {
      return 'Final ${widget.deviceType} Test';
    }
    return 'Initial ${widget.deviceType} Test';
  }

  Widget _getDeviceSection() {
    switch (widget.deviceType) {
      case 'DC':
        return _buildDcSection();
      default:
        return Text('Could not discern Device Type: ${widget.deviceType}');
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
                focusNode: _focusNodes['linePressure'],
                textInputType: TextInputType.number,
                autoFocusField: true,
                validateValue: true,
                onChanged: (value) {
                  setState(() {
                    _editedTest = _editedTest.copyWith(
                      linePressure: value ?? '',
                    );
                  });
                },
                onSubmitted: () => _handleFieldSubmitted('linePressure'),
              ),
              const SizedBox(height: 24),

              // Device Section
              _getDeviceSection(),
              const SizedBox(height: 24),

              // Passing Status
              InfoField(
                  label:
                      'Passing Status: ${_testEvaluator.getStatusIcon(_editedTest, widget.deviceType)}',
                  value: _testEvaluator.statusMessage),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDcSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cv1
        Text('Check Valve #1', style: Theme.of(context).textTheme.titleMedium),
        FormInputField(
          label: 'Pressure Reading',
          focusNode: _focusNodes['cv1Value'],
          textInputType: TextInputType.number,
          validateValue: true,
          formatDecimal: true,
          onChanged: (value) {
            setState(() {
              _editedTest = _editedTest.copyWith(
                  checkValve1:
                      _editedTest.checkValve1.copyWith(value: value ?? ''));
            });
          },
          onSubmitted: () => _handleFieldSubmitted('cv1Value'),
        ),
        const SizedBox(height: 8),
        FormCheckboxField(
          label: 'Closed Tight',
          value: _editedTest.checkValve1.closedTight,
          onChanged: (value) {
            setState(() {
              _editedTest = _editedTest.copyWith(
                  checkValve1: _editedTest.checkValve1
                      .copyWith(closedTight: value ?? false));
            });
          },
        ),
        const SizedBox(height: 16),

        // Cv2
        Text('Check Valve #2', style: Theme.of(context).textTheme.titleMedium),
        FormInputField(
          label: 'Pressure Reading',
          focusNode: _focusNodes['cv2Value'],
          textInputType: TextInputType.number,
          validateValue: true,
          formatDecimal: true,
          onChanged: (value) {
            setState(() {
              _editedTest = _editedTest.copyWith(
                  checkValve2:
                      _editedTest.checkValve2.copyWith(value: value ?? ''));
            });
          },
          onSubmitted: () => _handleFieldSubmitted('cv2Value'),
        ),
        const SizedBox(height: 8),
        FormCheckboxField(
          label: 'Closed Tight',
          value: _editedTest.checkValve2.closedTight,
          onChanged: (value) {
            setState(() {
              _editedTest = _editedTest.copyWith(
                  checkValve2: _editedTest.checkValve2
                      .copyWith(closedTight: value ?? false));
            });
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
