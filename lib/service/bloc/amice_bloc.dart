import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amice/service/client/api_client.dart';
import 'package:amice/service/models/system.dart';
import 'package:rxdart/rxdart.dart';

class AmiceBloc {
  final _systemStatusSubject = BehaviorSubject<SystemStatus>();
  final _client = ApiClient();

  final _fetchSubject = BehaviorSubject<bool>();
  StreamSubscription _fetchSubscription;
  
  Stream<SystemStatus> get systemStatus => _systemStatusSubject.stream;

  static AmiceBloc _instance;

  factory AmiceBloc.getInstance() {
    if (_instance == null) {
      _instance = AmiceBloc._privateConstructor();
    }
    return _instance;
  }

  AmiceBloc._privateConstructor() {
    _fetchSubscription = _fetchSubject.delay(Duration(seconds: 1)).listen((_) {
      _getStatus();
    });
    _getStatus();
  }

  void dispose() {
    _systemStatusSubject.close();
    _fetchSubject.close();
    _fetchSubscription.cancel();
  }

  Future _getStatus() async {
    try {
      var res = await _client.get("bus/status");
      if (res.statusCode != 200) {
        _systemStatusSubject.add(SystemStatus.disconnected("Unexpected HTTP ${res.statusCode}"));
      } else {
        var data = jsonDecode(res.body);
        _systemStatusSubject.add(SystemStatus.connected(BusStatus.fromJson(data)));
      }
    } on SocketException catch (e) {
      _systemStatusSubject.add(SystemStatus.disconnected("An error occurred in the connection to AMICE [${e.toString()}]"));
    } on TimeoutException catch (e) {
      _systemStatusSubject.add(SystemStatus.disconnected("Connection with AMICE timed out; there may be no AMICE on the specified IP address"));
    }

    _fetchSubject.add(true);
  }
}