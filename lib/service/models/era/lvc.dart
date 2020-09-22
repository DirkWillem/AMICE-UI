import 'package:amice/service/tools/decoder.dart';

enum LVCState {
  initializing,
  sleep,
  error,
  powerUpHVCheck,
  powerUpPrimaryLV,
  powerUpPrimaryLVDelay,
  lvVoltageCheck,
  enableLVState,
  sextupleConvDelay,
  sextupleConv,
  quintupleConvDelay,
  quintupleConv,
  quadrupleConvDelay,
  quadrupleConv,
  tripleConvDelay,
  tripleConv,
  doubleConvDelay,
  doubleConv,
  singleConvDelay,
  singleConv
}

enum VehicleState { standby, demo, auto, drive, wsc, ess, externalCharging }

class LVCVehicleState {
  final LVCState state;
  final VehicleState vehicleState;

  LVCVehicleState({this.state, this.vehicleState});

  factory LVCVehicleState.decode(Decoder d) {
    return LVCVehicleState(
      state: d.big.decodeEnum(_LVCStateEnumDef(), 0),
      vehicleState: d.big.decodeEnum(_VehicleStateEnumDef(), 1),
    );
  }
}

class _LVCStateEnumDef extends EnumDef<LVCState> {
  _LVCStateEnumDef()
      : super(UnderlyingType.u8, [
          LVCState.initializing,
          LVCState.sleep,
          LVCState.error,
          LVCState.powerUpHVCheck,
          LVCState.powerUpPrimaryLV,
          LVCState.powerUpPrimaryLVDelay,
          LVCState.lvVoltageCheck,
          LVCState.enableLVState,
          LVCState.sextupleConvDelay,
          LVCState.sextupleConv,
          LVCState.quintupleConvDelay,
          LVCState.quintupleConv,
          LVCState.quadrupleConvDelay,
          LVCState.quadrupleConv,
          LVCState.tripleConvDelay,
          LVCState.tripleConv,
          LVCState.doubleConvDelay,
          LVCState.doubleConv,
          LVCState.singleConvDelay,
          LVCState.singleConv
        ]);
}

extension _LVCStateName on LVCState {
  String get name {
    switch (this) {
      case LVCState.initializing:
        return 'Initializing';
      case LVCState.sleep:
        return 'Sleep';
      case LVCState.error:
        return 'Error';
      case LVCState.powerUpHVCheck:
        return 'Power-up HV check';
      case LVCState.powerUpPrimaryLV:
        return 'Power-up primary LV';
      case LVCState.powerUpPrimaryLVDelay:
        return 'Power-up primary LV delay';
      case LVCState.lvVoltageCheck:
        return 'LV voltage check';
      case LVCState.enableLVState:
        return 'Enable LV';
      case LVCState.sextupleConvDelay:
        return '6 Converter delay';
      case LVCState.sextupleConv:
        return '6 Converter';
      case LVCState.quintupleConvDelay:
        return '5 Converter delay';
      case LVCState.quintupleConv:
        return '5 Converters';
      case LVCState.quadrupleConvDelay:
        return '4 Converter delay';
      case LVCState.quadrupleConv:
        return '4 Converters';
      case LVCState.tripleConvDelay:
        return '3 Converter delay';
      case LVCState.tripleConv:
        return '3 Converters';
      case LVCState.doubleConvDelay:
        return '2 Converter delay';
      case LVCState.doubleConv:
        return '2 Converters';
      case LVCState.singleConvDelay:
        return '1 Converter delay';
      case LVCState.singleConv:
        return '1 Converter';
    }
  }
}

class _VehicleStateEnumDef extends EnumDef<VehicleState> {
  _VehicleStateEnumDef()
      : super(UnderlyingType.u8, [
          VehicleState.standby,
          VehicleState.demo,
          VehicleState.auto,
          VehicleState.drive,
          VehicleState.wsc,
          VehicleState.ess,
          VehicleState.externalCharging
        ]);
}

extension _VehicleStateName on VehicleState {
  String get name {
    switch (this) {
      case VehicleState.standby:
        return 'Standby';
      case VehicleState.demo:
        return 'Demo';
      case VehicleState.auto:
        return 'Auto';
      case VehicleState.drive:
        return 'Drive';
      case VehicleState.wsc:
        return 'WSC';
      case VehicleState.ess:
        return 'ESS';
      case VehicleState.externalCharging:
        return 'External Charging';
    }
  }
}
