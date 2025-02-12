import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reportflow/core/logic/backflow_test_evaluator.dart';
import 'package:reportflow/core/models/profile.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/core/widgets/form_input_field.dart';
import 'package:reportflow/core/widgets/info_field.dart';
import 'package:reportflow/core/widgets/profile_selection_dialog.dart';
import 'package:reportflow/features/settings/presentation/settings_page.dart';
import 'package:reportflow/features/test_input/presentation/widgets/dc_test_card.dart';
import 'package:reportflow/features/test_input/presentation/widgets/pvb_test_card.dart';
import 'package:reportflow/features/test_input/presentation/widgets/rp_test_card.dart';
import 'package:reportflow/features/test_input/presentation/widgets/sc_test_card.dart';
import 'package:reportflow/features/test_input/presentation/widgets/svb_test_card.dart';
import 'package:reportflow/features/test_input/presentation/widgets/type2_test_card.dart';

class TestInputPage extends StatefulWidget {
  final Function(Test) onSave;
  final Test testData;
  final String deviceType;
  final bool isFinalTest;

  const TestInputPage(
      {super.key,
      required this.onSave,
      required this.testData,
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
    _addFocusNode('linePressure');
    _editedTest = widget.testData;
  }

  @override
  void dispose() {
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  String _getPageTitle() {
    if (widget.isFinalTest) {
      return 'Final ${widget.deviceType} Test';
    }
    return 'Initial ${widget.deviceType} Test';
  }

  void _addFocusNode(String key) {
    _focusNodes[key] = FocusNode();
    _focusOrder.add(key);
  }

  void addFocusNode(String key, FocusNode? node) {
    _focusNodes[key] = node ?? FocusNode();
    _focusOrder.add(key);
  }

  void _handleFieldSubmitted(String currentKey) {
    final currentIndex = _focusOrder.indexOf(currentKey);
    if (currentIndex < _focusOrder.length - 1) {
      _focusNodes[_focusOrder[currentIndex + 1]]?.requestFocus();
    }
  }

  Widget _getDeviceSection() {
    switch (widget.deviceType.toUpperCase()) {
      case 'DC':
        return DcTestCard(
          test: _editedTest,
          onTestUpdated: (test) => setState(() => _editedTest = test),
          addFocusNode: (keyStr, focusNode) {
            addFocusNode(keyStr, focusNode);
          },
        );
      case 'RP':
        return RpTestCard(
          test: _editedTest,
          onTestUpdated: (test) => setState(() => _editedTest = test),
          addFocusNode: (keyStr, focusNode) {
            addFocusNode(keyStr, focusNode);
          },
        );
      case 'PVB':
        return PvbTestCard(
          test: _editedTest,
          onTestUpdated: (test) => setState(() => _editedTest = test),
          addFocusNode: (keyStr, focusNode) {
            addFocusNode(keyStr, focusNode);
          },
        );
      case 'SVB':
        return SvbTestCard(
          test: _editedTest,
          onTestUpdated: (test) => setState(() => _editedTest = test),
          addFocusNode: (keyStr, focusNode) {
            addFocusNode(keyStr, focusNode);
          },
        );
      case 'SC':
        return ScTestCard(
          test: _editedTest,
          onTestUpdated: (test) => setState(() => _editedTest = test),
          addFocusNode: (keyStr, focusNode) {
            addFocusNode(keyStr, focusNode);
          },
        );
      case 'TYPE 2':
        return Type2TestCard(
          test: _editedTest,
          onTestUpdated: (test) => setState(() => _editedTest = test),
          addFocusNode: (keyStr, focusNode) {
            addFocusNode(keyStr, focusNode);
          },
        );
      default:
        return Text('${widget.deviceType} is not supported yet');
    }
  }

  void _focusFirstEmptyField() {
    for (final key in _focusOrder.reversed) {
      final node = _focusNodes[key];
      final nodeField =
          node?.context?.findAncestorWidgetOfExactType<TextFormField>();
      if (nodeField?.controller?.text.isEmpty ?? true) {
        node?.requestFocus();
      }
    }
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      // Check if it's final test and evaluate backflow
      if (widget.isFinalTest &&
          !_testEvaluator.isPassing(
              _testEvaluator.getStatusIcon(_editedTest, widget.deviceType))) {
        // Show alert dialog for failing backflow
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Test Failed'),
              content: const Text(
                  'The backflow test has failed. It cannot be saved as a final test.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      final selectedProfile = await showDialog<Profile>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const ProfileSelectionDialog(),
      );

      if (selectedProfile != null && mounted) {
        final TesterProfile profile = TesterProfile(
            name: selectedProfile.testerName,
            certNo: selectedProfile.testCertNo,
            gaugeKit: selectedProfile.testKitSerial,
            date: DateFormat('MM/dd/yyyy').format(DateTime.now()));

        _editedTest = _editedTest.copyWith(testerProfile: profile);
        widget.onSave(_editedTest);
        Navigator.pop(context);
      }
    } else {
      _focusFirstEmptyField();
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
                initialValue: _editedTest.linePressure,
                focusNode: _focusNodes['linePressure'],
                textInputType: TextInputType.number,
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
}
