import 'package:amice/service/tools/decoder.dart';

import 'common.dart';

enum BMSState { ess, startup, precharge, active }

enum BMSCoolingLimit { charging, discharging }

enum BMSError {
  none,
  cellUV,
  cellOV,
  batUT,
  batOT,
  pcbOT,
  estop,
  hvilError,
  oc,
  ivtocs,
  satFault,
  satInternalFault,
  satPCBOT,
  negContAuxMismatch,
  posContAuxMismatch,
  negContECMismatch,
  posContECMismatch,
  imdStartupKl31Fault,
  imdStartupDevErr,
  imdStartupTimeout,
  imdKl31Fault,
  imdDevErr,
  imdNoData,
  imdInvalidData,
  imdNOK,
  satStartupTimeout,
  satCommLoss,
  ivtStartupTimeout,
  ivtCommLoss,
  contError,
  prechargeTimeout,
  lvcWakeLow,
  batHVUV,
  uvProtectionDischLimExceeded,
  uvProtectionChgLimitExceeded,
  permanentUVProtection
}

enum IMDState { off, starting, startupDelay, operational, error }
enum IMDMeasurement {
  normal,
  uv,
  sst,
  devErr,
  kl31Fault,
  override,
  invalid,
  noData
}

class GlobalState {
  final BMSState state;
  final IMDState imdState;
  final BMSCoolingLimit coolingLimit;
  final OnOff coolingState;
  final OnOff battfrontState;
  final OnOff canControllerState;
  final BMSError error;

  GlobalState({this.state,
    this.imdState,
    this.coolingLimit,
    this.coolingState,
    this.battfrontState,
    this.canControllerState,
    this.error});

  factory GlobalState.decode(Decoder d) {
    return GlobalState(
      state: d.big.decodeEnum(_StateEnumDef(), 0),
      imdState: d.big.decodeEnum(_IMDStateEnumDef(), 1),
      coolingLimit: d.big.decodeEnum(_CoolingLimitEnumDef(), 2),
      coolingState: d.big.decodeEnum(OnOffEnumDef(), 3),
      battfrontState: d.big.decodeEnum(OnOffEnumDef(), 4),
      canControllerState: d.big.decodeEnum(OnOffEnumDef(), 5),
      error: d.big.decodeEnum(_BMSErrorEnumDef(), 6),
    );
  }
}

class MinMaxCellV {
  final int minCellV;
  final int maxCellV;
  final int minCellNum;
  final int maxCellNum;
  final int maxNonAdjBalCellV;

  MinMaxCellV({this.minCellV,
    this.maxCellV,
    this.minCellNum,
    this.maxCellNum,
    this.maxNonAdjBalCellV});

  factory MinMaxCellV.decode(Decoder d) {
    return MinMaxCellV(
      minCellV: d.big.decodeU16(0),
      maxCellV: d.big.decodeU16(2),
      minCellNum: d.decodeU8(3),
      maxCellNum: d.decodeU8(4),
      maxNonAdjBalCellV: d.big.decodeU16(5),
    );
  }
}

class MinMaxCellT {
  final int minCellT;
  final int maxCellT;
  final int minCellNum;
  final int maxCellNum;

  MinMaxCellT({this.minCellT, this.maxCellT, this.minCellNum, this.maxCellNum});

  factory MinMaxCellT.decode(Decoder d) {
    return MinMaxCellT(
      minCellT: d.big.decodeS16(0),
      maxCellT: d.big.decodeS16(2),
      minCellNum: d.decodeU8(3),
      maxCellNum: d.decodeU8(4),
    );
  }
}

class IMDStatus {
  final int insulationValue;
  final int frequency;
  final IMDMeasurement state;

  IMDStatus({ this.insulationValue, this.frequency, this.state });

  factory IMDStatus.decode(Decoder d) {
    return IMDStatus(
        insulationValue: d.big.decodeU32(0),
        frequency: d.big.decodeU16(4),
        state: d.big.decodeEnum(_IMDMeasurementEnumDef(), 6),
    );
  }
}

class BatteryCurrent {
  final double current;

  BatteryCurrent({this.current});

  factory BatteryCurrent.decode(Decoder d) {
    return BatteryCurrent(
      current: d.decodeF32(0),
    );
  }
}

class BatteryPower {
  final double power;

  BatteryPower({this.power});

  factory BatteryPower.decode(Decoder d) {
    return BatteryPower(
      power: d.decodeF32(0),
    );
  }
}

class BatteryCondition {
  final double soc;
  final double soh;

  BatteryCondition({this.soc, this.soh});

  factory BatteryCondition.decode(Decoder d) {
    return BatteryCondition(
      soc: d.decodeF32(0),
      soh: d.decodeF32(4),
    );
  }
}

class BatteryHVMeasurements {
  final double vBat;
  final double vBus;

  BatteryHVMeasurements({this.vBat, this.vBus});

  factory BatteryHVMeasurements.decode(Decoder d) {
    return BatteryHVMeasurements(
      vBat: d.decodeF32(0),
      vBus: d.decodeF32(4),
    );
  }
}

class CellData {
  final List<int> sat1V;
  final List<int> sat2V;
  final List<int> sat3V;

  final List<int> sat1T;
  final List<int> sat2T;
  final List<int> sat3T;

  CellData({ this.sat1V, this.sat2V, this.sat3V, this.sat1T, this.sat2T, this.sat3T });

  factory CellData.decode(Decoder d) {
    return CellData(
      sat1V: List.generate(12, (i) => d.big.decodeU16(i*2)),
      sat2V: List.generate(12, (i) => d.big.decodeU16(24+i*2)),
      sat3V: List.generate(12, (i) => d.big.decodeU16(48+i*3)),
      sat1T: List.generate(6, (i) => d.decodeS8(72+i)),
      sat2T: List.generate(6, (i) => d.decodeS8(80+i)),
      sat3T: List.generate(6, (i) => d.decodeS8(88+i)),
    );
  }
}

class BMSData {
  final ControllerVersion version;
  final GlobalState state;
  final MinMaxCellV cellV;
  final MinMaxCellT cellT;
  final IMDStatus imdStatus;
  final BatteryCurrent current;
  final BatteryPower power;
  final BatteryCondition condition;
  final BatteryHVMeasurements hvMeasurements;
  final CellData cellData;

  BMSData({this.version,
    this.state,
    this.cellV,
    this.cellT,
    this.imdStatus,
    this.current,
    this.power,
    this.condition,
    this.hvMeasurements,
    this.cellData,});

  BMSData update({ControllerVersion newVersion,
    GlobalState newState,
    MinMaxCellV newCellV,
    MinMaxCellT newCellT,
    IMDStatus newImdStatus,
    BatteryCurrent newCurrent,
    BatteryPower newPower,
    BatteryCondition newCondition,
    BatteryHVMeasurements newHVMeasurements,
    CellData newCellData}) {
    return BMSData(
      version: newVersion ?? version,
      state: newState ?? state,
      cellV: newCellV ?? cellV,
      cellT: newCellT ?? cellT,
      imdStatus: newImdStatus ?? imdStatus,
      current: newCurrent ?? current,
      power: newPower ?? power,
      condition: newCondition ?? condition,
      hvMeasurements: newHVMeasurements ?? hvMeasurements,
      cellData: newCellData ?? cellData,
    );
  }
}

class _StateEnumDef extends EnumDef<BMSState> {
  _StateEnumDef()
      : super(UnderlyingType.u8, [
    BMSState.ess,
    BMSState.startup,
    BMSState.precharge,
    BMSState.active
  ]);
}

extension BMSStateName on BMSState {
  String get name {
    switch (this) {
      case BMSState.ess: return 'ESS';
      case BMSState.startup: return 'Startup';
      case BMSState.precharge: return 'Pre-charge';
      case BMSState.active: return 'Active';
    }
    return 'Unknown';
  }
}

class _CoolingLimitEnumDef extends EnumDef<BMSCoolingLimit> {
  _CoolingLimitEnumDef()
      : super(UnderlyingType.u8,
      [BMSCoolingLimit.charging, BMSCoolingLimit.discharging]);
}

class _IMDStateEnumDef extends EnumDef<IMDState> {
  _IMDStateEnumDef()
      : super(UnderlyingType.u8, [
    IMDState.off,
    IMDState.starting,
    IMDState.startupDelay,
    IMDState.operational,
    IMDState.error
  ]);
}

class _IMDMeasurementEnumDef extends EnumDef<IMDMeasurement> {
  _IMDMeasurementEnumDef()
      : super(UnderlyingType.u8, [
    IMDMeasurement.normal,
    IMDMeasurement.uv,
    IMDMeasurement.sst,
    IMDMeasurement.devErr,
    IMDMeasurement.kl31Fault,
    IMDMeasurement.override,
    IMDMeasurement.invalid,
    IMDMeasurement.noData
  ]);
}

class _BMSErrorEnumDef extends EnumDef<BMSError> {
  _BMSErrorEnumDef()
      : super(UnderlyingType.u8, [
    BMSError.none,
    BMSError.cellUV,
    BMSError.cellOV,
    BMSError.batUT,
    BMSError.batOT,
    BMSError.pcbOT,
    BMSError.estop,
    BMSError.hvilError,
    BMSError.oc,
    BMSError.ivtocs,
    BMSError.satFault,
    BMSError.satInternalFault,
    BMSError.satPCBOT,
    BMSError.negContAuxMismatch,
    BMSError.posContAuxMismatch,
    BMSError.negContECMismatch,
    BMSError.posContECMismatch,
    BMSError.imdStartupKl31Fault,
    BMSError.imdStartupDevErr,
    BMSError.imdStartupTimeout,
    BMSError.imdKl31Fault,
    BMSError.imdDevErr,
    BMSError.imdNoData,
    BMSError.imdInvalidData,
    BMSError.imdNOK,
    BMSError.satStartupTimeout,
    BMSError.satCommLoss,
    BMSError.ivtStartupTimeout,
    BMSError.ivtCommLoss,
    BMSError.contError,
    BMSError.prechargeTimeout,
    BMSError.lvcWakeLow,
    BMSError.batHVUV,
    BMSError.uvProtectionDischLimExceeded,
    BMSError.uvProtectionChgLimitExceeded,
    BMSError.permanentUVProtection
  ]);
}

extension BMSErrorName on BMSError {
  String get shortName {
    switch (this) {
      case BMSError.none:
        return 'None';
      case BMSError.cellUV:
        return 'Cell UV';
      case BMSError.cellOV:
        return 'Cell OV';
      case BMSError.batUT:
        return 'Cell UT';
      case BMSError.batOT:
        return 'Cell OT';
      case BMSError.pcbOT:
        return 'PCB OT';
      case BMSError.estop:
        return 'E-stop';
      case BMSError.hvilError:
        return 'HVIL';
      case BMSError.oc:
        return 'OC';
      case BMSError.ivtocs:
        return 'IVTOCS';
      case BMSError.satFault:
        return 'Sat fault';
      case BMSError.satInternalFault:
      case BMSError.satPCBOT:
        return 'Sat OT';
      case BMSError.negContAuxMismatch:
      case BMSError.posContAuxMismatch:
      case BMSError.negContECMismatch:
      case BMSError.posContECMismatch:
        return 'Cont fault';
      case BMSError.imdStartupKl31Fault:
      case BMSError.imdStartupDevErr:
      case BMSError.imdStartupTimeout:
      case BMSError.imdKl31Fault:
      case BMSError.imdDevErr:
      case BMSError.imdNoData:
      case BMSError.imdInvalidData:
        return 'IMD fault';
      case BMSError.imdNOK:
        return 'IMD not OK';
      case BMSError.satStartupTimeout:
      case BMSError.satCommLoss:
        return 'Sat fault';
      case BMSError.ivtStartupTimeout:
      case BMSError.ivtCommLoss:
        return 'IVT fault';
      case BMSError.contError:
        return 'Cont fault';
      case BMSError.prechargeTimeout:
        return 'Pre-charge TO';
      case BMSError.lvcWakeLow:
        return 'LVC Low';
      case BMSError.batHVUV:
        return 'HV UV';
      case BMSError.uvProtectionDischLimExceeded:
      case BMSError.uvProtectionChgLimitExceeded:
      case BMSError.permanentUVProtection:
        return 'UV Prot';
    }
  }
}