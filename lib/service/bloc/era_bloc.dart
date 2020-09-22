import 'dart:async';

import 'package:amice/service/client/era_client.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/service/tools/decoder.dart';
import 'package:rxdart/rxdart.dart';

class EraBloc {
  final _bmsSubject = BehaviorSubject<BMSData>();
  final _client = EraClient();

  final _ticker = Stream.periodic(Duration(milliseconds: 500)).asBroadcastStream();
  StreamSubscription _batterySubscription;
  StreamSubscription _cellDataSubscription;

  Stream<BMSData> get bms => _bmsSubject.asBroadcastStream();

  static EraBloc _instance;

  factory EraBloc.getInstance() {
    if (_instance == null) {
      _instance = EraBloc._privateConstructor();
    }
    return _instance;
  }

  EraBloc._privateConstructor();

  void dispose() {
    _bmsSubject.close();
  }

  Future getBatteryInfo() async {
    final msgs = await _client.getData('era/batt/info');
    final decoders = msgs.map((msg) => Decoder(msg.data)).toList();

    final old = _bmsSubject.value ?? BMSData();

    _bmsSubject.add(old.update(
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
  }

  Future getBatteryCellData() async {
    final data = await _client.getRawData('era/batt/cells');
    final old = _bmsSubject.value ?? BMSData();

    _bmsSubject.add(old.update(
      newCellData: CellData.decode(Decoder(data)),
    ));
  }

  void fetchBatteryInfoPeriodic() {
    if (_batterySubscription == null) {
      _batterySubscription = _ticker.listen((_) {
        getBatteryInfo();
      });
    }
  }

  void fetchBatteryCellDataPeriodic() {
    if (_cellDataSubscription == null) {
      _cellDataSubscription = _ticker.listen((_) {
        getBatteryCellData();
      });
    }
  }

  void cancelPeriodicBatteryInfo() {
    _batterySubscription.cancel();
    _batterySubscription = null;
  }

  void cancelPeriodicCellData() {
    _cellDataSubscription.cancel();
    _cellDataSubscription = null;
  }
}
