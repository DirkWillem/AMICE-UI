import 'dart:async';

import 'package:amice/service/client/api_client.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/service/tools/decoder.dart';
import 'package:rxdart/rxdart.dart';

class EraBloc {
  // region Public fields

  Stream<BMSData> get bms => _bmsSubject.stream;
  Stream<SSBData> get ssb => _ssbSubject.stream;
  Stream<ChCData> get chc => _chcSubject.stream;
  Stream<LVCData> get lvc => _lvcSubject.stream;

  //endregion
  // region Constructor / dispose

  factory EraBloc.getInstance() {
    if (_instance == null) {
      _instance = EraBloc._privateConstructor();
    }
    return _instance;
  }

  EraBloc._privateConstructor();

  void dispose() {
    _bmsSubject.close();
    _ssbSubject.close();
    _chcSubject.close();
    _lvcSubject.close();
  }

  // endregion
  // region Public methods

  void fetchGlobalInfoPeriodic() {
    if (_globalInfoSubscription == null) {
      _globalInfoSubscription = _ticker.listen((_) {
        _getGlobalInfo();
      });
    }
  }

  void cancelPeriodicGlobalInfo() {
    _globalInfoSubscription.cancel();
    _globalInfoSubscription = null;
  }

  void fetchBatteryInfoPeriodic() {
    if (_batterySubscription == null) {
      _batterySubscription = _ticker.listen((_) {
        _getBatteryInfo();
      });
    }
  }

  void cancelPeriodicBatteryInfo() {
    _batterySubscription.cancel();
    _batterySubscription = null;
  }

  void fetchBatteryCellDataPeriodic() {
    if (_cellDataSubscription == null) {
      _cellDataSubscription = _ticker.listen((_) {
        _getBatteryCellData();
      });
    }
  }

  void cancelPeriodicCellData() {
    _cellDataSubscription.cancel();
    _cellDataSubscription = null;
  }
  
  // endregion
  // region Private fields

  static EraBloc _instance;
  final _client = ApiClient();

  final _bmsSubject = BehaviorSubject<BMSData>();
  final _ssbSubject = BehaviorSubject<SSBData>();
  final _chcSubject = BehaviorSubject<ChCData>();
  final _lvcSubject = BehaviorSubject<LVCData>();

  final _ticker = Stream.periodic(Duration(milliseconds: 500)).asBroadcastStream();

  StreamSubscription _globalInfoSubscription;
  StreamSubscription _batterySubscription;
  StreamSubscription _cellDataSubscription;

  // endregion
  // region Private methods

  Future _getGlobalInfo() async {
    final msgs = await _client.getData('era/global/info');
    final decoders = msgs.map((msg) => Decoder(msg.data)).toList();

    final oldBMS = _bmsSubject.value ?? BMSData();
    _bmsSubject.add(oldBMS.update(
      newState: GlobalState.decode(decoders[7]),
      newCellV: MinMaxCellV.decode(decoders[0]),
      newCellT: MinMaxCellT.decode(decoders[1]),
      newCondition: BatteryCondition.decode(decoders[3]),
      newPower: BatteryPower.decode(decoders[4])
    ));

    final oldSSB = _ssbSubject.value ?? SSBData();
    _ssbSubject.add(oldSSB.update(
      newLightingState: LightingState.decode(decoders[6])
    ));

    final oldChC = _chcSubject.value ?? ChCData();
    _chcSubject.add(oldChC.update(
      newState: MainsChargingState.decode(decoders[5]),
    ));

    final oldLVC = _lvcSubject.value ?? LVCData();
    _lvcSubject.add(oldLVC.update(
      newState: LVCVehicleState.decode(decoders[2]),
    ));
  }

  Future _getBatteryInfo() async {
    final msgs = await _client.getData('era/batt/info');
    final decoders = msgs.map((msg) => Decoder(msg.data)).toList();

    final oldBMS = _bmsSubject.value ?? BMSData();

    _bmsSubject.add(oldBMS.update(
      newVersion: ControllerVersion.decode(decoders[0]),
      newState: GlobalState.decode(decoders[1]),
      newCellV: MinMaxCellV.decode(decoders[2]),
      newCellT: MinMaxCellT.decode(decoders[3]),
      newImdStatus: IMDStatus.decode(decoders[4]),
      newCurrent: BatteryCurrent.decode(decoders[6]),
      newPower: BatteryPower.decode(decoders[7]),
      newCondition: BatteryCondition.decode(decoders[8]),
      newHVMeasurements: BatteryHVMeasurements.decode(decoders[9]),
    ));

    final oldLVC = _lvcSubject.value ?? LVCData();
    _lvcSubject.add(oldLVC.update(
      newState: LVCVehicleState.decode(decoders[5]),
    ));
  }

  Future _getBatteryCellData() async {
    final data = await _client.getRawData('era/batt/cells');
    final old = _bmsSubject.value ?? BMSData();

    _bmsSubject.add(old.update(
      newCellData: CellData.decode(Decoder(data)),
    ));
  }
  
  // endregion
}
