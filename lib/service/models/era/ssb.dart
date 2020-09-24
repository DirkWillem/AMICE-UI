import 'package:amice/service/tools/decoder.dart';

enum MainLightingState { off, drl, lb, hb }

class LightingState {
  final MainLightingState state;

  LightingState({ this.state });

  factory LightingState.decode(Decoder d) {
    return LightingState(
      state: d.big.decodeEnum(_MainLightingStateEnumDef(), 0),
    );
  }
}

class SSBData {
  final LightingState lightingState;

  SSBData({ this.lightingState });

  SSBData update({ LightingState newLightingState }) {
    return SSBData(
      lightingState: newLightingState ?? lightingState
    );
  }
}

class _MainLightingStateEnumDef extends EnumDef<MainLightingState> {
  _MainLightingStateEnumDef()
    : super(UnderlyingType.u8, [MainLightingState.off, MainLightingState.drl, MainLightingState.lb, MainLightingState.hb]);
}