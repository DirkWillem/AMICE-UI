import 'package:amice/service/tools/decoder.dart';

enum ChCState {
  unknown,
  off,
  starting,
  restarting,
  ready,
  charging,
  releasing,
  error,
  recovered,
  disabled,
  acRecovery,
  cooldown
}

enum ChCError {
  none,
  chargerFaultFlag,
  chargerTimeout,
  relayNotClosing,
  relayWelded,
  busVoltageTimeout,
  restartErrorTimeout
}

class MainsChargingState {
  final ChCState state;
  final ChCError error;

  MainsChargingState({ this.state, this.error });

  factory MainsChargingState.decode(Decoder d) {
    return MainsChargingState(
      state: d.big.decodeEnum(_ChCStateEnumDef(), 0),
      error: d.big.decodeEnum(_ChCErrorEnumDef(), 1),
    );
  }
}

class ChCData {
  final MainsChargingState state;

  ChCData({ this.state });

  ChCData update({ MainsChargingState newState }) {
    return ChCData(
      state: newState ?? state
    );
  }
}

class _ChCStateEnumDef extends EnumDef<ChCState> {
  _ChCStateEnumDef()
      : super(UnderlyingType.u8, [
          ChCState.unknown,
          ChCState.off,
          ChCState.starting,
          ChCState.restarting,
          ChCState.ready,
          ChCState.charging,
          ChCState.releasing,
          ChCState.error,
          ChCState.error,
          ChCState.recovered,
          ChCState.disabled,
          ChCState.acRecovery,
          ChCState.cooldown
        ]);
}

class _ChCErrorEnumDef extends EnumDef<ChCError> {
  _ChCErrorEnumDef()
      : super(UnderlyingType.u8, [
          ChCError.none,
          ChCError.chargerFaultFlag,
          ChCError.chargerTimeout,
          ChCError.relayNotClosing,
          ChCError.relayWelded,
          ChCError.busVoltageTimeout,
          ChCError.restartErrorTimeout,
        ]);
}

extension ChCStateName on ChCState {
  String get name {
    switch (this) {
      case ChCState.unknown:
        return 'Unknown';
      case ChCState.off:
        return 'Off';
      case ChCState.starting:
        return 'Starting';
      case ChCState.restarting:
        return 'Restarting';
      case ChCState.ready:
        return 'Ready';
      case ChCState.charging:
        return 'Charging';
      case ChCState.releasing:
        return 'Releasing';
      case ChCState.error:
        return 'Error';
      case ChCState.recovered:
        return 'Recovered';
      case ChCState.disabled:
        return 'Disabled';
      case ChCState.acRecovery:
        return 'AC Recovery';
      case ChCState.cooldown:
        return 'Cooldown';
    }

    return 'Unknown';
  }
}

extension ChCErrorName on ChCError {
  String get shortName {
    switch(this) {

      case ChCError.none:
        return 'None';
      case ChCError.chargerFaultFlag:
        return 'Ch. fault';
      case ChCError.chargerTimeout:
        return 'Ch. TO';
      case ChCError.relayNotClosing:
        return 'Relay N.C.';
      case ChCError.relayWelded:
        return 'Relay N.O.';
      case ChCError.busVoltageTimeout:
        return 'Vbus TO';
      case ChCError.restartErrorTimeout:
        return 'Restart TO';
    }

    return 'Unknown';
  }
}