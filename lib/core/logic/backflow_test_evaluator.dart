import 'package:reportflow/core/models/report_flow_types.dart';

class BackflowTestEvaluator {
  static const String passIcon = '✅';
  static const String passMessage = 'Backflow passed!';

  static const String unknownIcon = '⚠️';
  static const String unknownMessage = 'Not enough information';

  static const String failIcon = '❌';

  String statusMessage = unknownMessage;

  String getStatusIcon(Test backflowTest, String deviceType) {
    if (backflowTest.linePressure.isEmpty) {
      statusMessage = unknownMessage;
      return unknownIcon;
    }

    switch (deviceType) {
      case 'DC':
        return _evaluateDCTest(backflowTest);
      case 'RP':
        return _evaluateRPTest(backflowTest);
      case 'PVB':
        return _evaluatePVBTest(backflowTest);
      case 'SVB':
        return _evaluateSVBTest(backflowTest);
      case 'SC':
        return _evaluateSCTest(backflowTest);
      case 'TYPE 2':
        return _evaluateType2Test(backflowTest);
      default:
        return '$unknownIcon INVALID_DEVICE_TYPE';
    }
  }

  bool isPassing(String icon) => icon == passIcon;

  String getStatusMessage() => statusMessage;

  /// **Purpose:** Evaluates if checks closed tight;
  /// **Behaviour:** Updates statusMessage and returns false if checks did not close tight.
  bool _didChecksCt(bool cv1Ct, bool cv2Ct) {
    if (!cv1Ct && !cv2Ct) {
      statusMessage = 'Both checks didn\'t close tight';
      return false;
    } else if (!cv1Ct) {
      statusMessage = 'Check #1 didn\'t close tight';
      return false;
    } else if (!cv2Ct) {
      statusMessage = 'Check #2 didn\'t close tight';
      return false;
    }

    statusMessage = unknownMessage;
    return true;
  }

  String _evaluateDCTest(Test test) {
    CheckValve cv1 = test.checkValve1;
    CheckValve cv2 = test.checkValve2;

    // Not enough information to judge
    if (cv1.value.isEmpty || cv2.value.isEmpty) {
      statusMessage = unknownMessage;
      return unknownIcon;
    }

    // Checks must be closed tight
    if (!_didChecksCt(cv1.closedTight, cv2.closedTight)) {
      return failIcon;
    }

    // Checks must be have a value <= 1
    try {
      // Parse double values from string
      double v1 = double.parse(cv1.value);
      double v2 = double.parse(cv2.value);

      if (v1 < 1.0 && v2 < 1.0) {
        statusMessage = 'Both checks\' value was lower than 1.0';
        return failIcon;
      } else if (v1 < 1.0) {
        statusMessage = 'Check #1\'s value was lower than 1.0';
        return failIcon;
      } else if (v2 < 1.0) {
        statusMessage = 'Check #2\'s value was lower than 1.0';
        return failIcon;
      }

      // Checks passed, unknown until all logic has passed
      statusMessage = unknownMessage;
    } catch (e) {
      statusMessage = e.toString();
      return unknownIcon;
    }

    statusMessage = passMessage;
    return passIcon;
  }

  String _evaluateRPTest(Test test) {
    CheckValve cv1 = test.checkValve1;
    CheckValve cv2 = test.checkValve2;
    ReliefValve rv = test.reliefValve;

    // Not enough information to judge
    if (cv1.value.isEmpty || rv.value.isEmpty) {
      statusMessage = unknownMessage;
      return unknownIcon;
    }

    // Checks must be closed tight
    if (!_didChecksCt(cv1.closedTight, cv2.closedTight)) {
      return failIcon;
    }

    // Relief Valve must open
    if (!rv.opened) {
      statusMessage = "Relief Valve did not open";
      return failIcon;
    }

    // Checks must be have a value <= 1
    try {
      // Parse double values from string
      double v1 = double.parse(cv1.value);
      double v2 = double.parse(rv.value);

      if (v1 < 5.0 && v2 < 3.0) {
        statusMessage =
            'Both Check Valve #1 and Relief Valve failed as their values were below required thresholds';
        return failIcon;
      } else if (v1 < 5.0) {
        statusMessage = 'Check #1\'s value was lower than 5.0';
        return failIcon;
      } else if (v2 < 2.0) {
        statusMessage = 'Relief Valve\'s value was lower than 2.0';
        return failIcon;
      } else if (v1 - v2 < 3.0) {
        statusMessage =
            'Check #1\'s value is not at least 3.0 greater than Relief Valve\'s value';
        return failIcon;
      }

      // Checks passed, unknown until all logic has passed
      statusMessage = unknownMessage;
    } catch (e) {
      statusMessage = e.toString();
      return unknownIcon;
    }

    statusMessage = passMessage;
    return passIcon;
  }

  String _evaluatePVBTest(Test test) {
    AirInlet airInlet = test.vacuumBreaker.airInlet;
    Check check = test.vacuumBreaker.check;
    bool backPressure = test.vacuumBreaker.backPressure;

    // Not enough information to judge
    if (airInlet.value.isEmpty || check.value.isEmpty) {
      statusMessage = unknownMessage;
      return unknownIcon;
    }

    // Check if check failed
    if (backPressure) {
      statusMessage = 'Back pressure is present';
      return failIcon;
    }

    // Check if air inlet failed
    if (airInlet.leaked || !airInlet.opened) {
      if (airInlet.leaked) {
        statusMessage = 'Air Inlet leaked';
      } else {
        statusMessage = 'Air Inlet did not open';
      }

      return failIcon;
    }

    // Check if check failed
    if (check.leaked) {
      statusMessage = 'Check did not open';
      return failIcon;
    }

    try {
      // Parse double values from string
      double airIn = double.parse(airInlet.value);
      double ck = double.parse(check.value);

      if (airIn < 1.0 && ck < 1.0) {
        statusMessage =
            'Both Air Inlet and Check failed as their values were lower than 1.0';
        return failIcon;
      } else if (airIn < 1.0) {
        statusMessage = 'Air Inlet\'s value was lower than 1.0';
        return failIcon;
      } else if (ck < 1.0) {
        statusMessage = 'Check\'s value was lower than 1.0';
        return failIcon;
      }

      // Air Inlet + Check passed, unknown until all logic has passed
      statusMessage = unknownMessage;
    } catch (e) {
      statusMessage = e.toString();
      return unknownIcon;
    }

    statusMessage = passMessage;
    return passIcon;
  }

  String _evaluateSVBTest(Test test) {
    AirInlet airInlet = test.vacuumBreaker.airInlet;
    Check check = test.vacuumBreaker.check;
    bool backPressure = test.vacuumBreaker.backPressure;

    // Not enough information to judge
    if (airInlet.value.isEmpty || check.value.isEmpty) {
      statusMessage = unknownMessage;
      return unknownIcon;
    }

    // Check if check failed
    if (backPressure) {
      statusMessage = 'Back pressure is present';
      return failIcon;
    }

    // Check if air inlet failed
    if (airInlet.leaked || !airInlet.opened) {
      if (airInlet.leaked) {
        statusMessage = 'Air Inlet leaked';
      } else {
        statusMessage = 'Air Inlet did not open';
      }

      return failIcon;
    }

    // Check if check failed
    if (check.leaked) {
      statusMessage = 'Check did not open';
      return failIcon;
    }

    try {
      // Parse double values from string
      double airIn = double.parse(airInlet.value);
      double ck = double.parse(check.value);

      if (airIn < 1.0 && ck < 1.0) {
        statusMessage =
            'Both Air Inlet and Check failed as their values were below required thresholds';
        return failIcon;
      } else if (airIn < 1.0) {
        statusMessage = 'Air Inlet\'s value was lower than 1.0';
        return failIcon;
      } else if (ck < 1.0) {
        statusMessage = 'Check\'s value was lower than 1.0';
        return failIcon;
      }

      // Air Inlet + Check passed, unknown until all logic has passed
      statusMessage = unknownMessage;
    } catch (e) {
      statusMessage = e.toString();
      return unknownIcon;
    }

    statusMessage = passMessage;
    return passIcon;
  }

  String _evaluateSCTest(Test test) {
    CheckValve cv1 = test.checkValve1;

    // Not enough information to judge
    if (cv1.value.isEmpty) {
      statusMessage = unknownMessage;
      return unknownIcon;
    }

    // Check must be closed tight
    if (!_didChecksCt(cv1.closedTight, true)) {
      return failIcon;
    }

    // Check must be have a value <= 1
    try {
      // Parse double values from string
      double v1 = double.parse(cv1.value);

      if (v1 < 1.0) {
        statusMessage = 'Check #1\'s value was lower than 1.0';
        return failIcon;
      }

      // Checks passed, unknown until all logic has passed
      statusMessage = unknownMessage;
    } catch (e) {
      statusMessage = e.toString();
      return unknownIcon;
    }

    statusMessage = passMessage;
    return passIcon;
  }

  String _evaluateType2Test(Test test) {
    CheckValve cv1 = test.checkValve1;

    // Not enough information to judge
    if (cv1.value.isEmpty) {
      statusMessage = unknownMessage;
      return unknownIcon;
    }

    // Check must be closed tight
    if (!_didChecksCt(cv1.closedTight, true)) {
      return failIcon;
    }

    // Check must be have a value <= 1
    try {
      // Parse double values from string
      double v1 = double.parse(cv1.value);

      if (v1 < 1.0) {
        statusMessage = 'Check #1\'s value was lower than 1.0';
        return failIcon;
      }

      // Checks passed, unknown until all logic has passed
      statusMessage = unknownMessage;
    } catch (e) {
      statusMessage = e.toString();
      return unknownIcon;
    }

    statusMessage = passMessage;
    return passIcon;
  }
}
