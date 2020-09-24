import 'dart:typed_data';

import 'package:amice/service/models/can_frame.dart';
import 'package:amice/service/system_config.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<List<CANFrame>> getData(String path) async {
    final response = await http.get('${SystemConfig.getInstance().apiUrl}/data/$path').timeout(Duration(seconds: 1));
    return _decodeFrames(response.bodyBytes);
  }

  Future<http.Response> get(String path) async {
    final response = await http.get('${SystemConfig.getInstance().apiUrl}/$path').timeout(Duration(seconds: 1));
    return response;
  }

  Future<Uint8List> getRawData(String path) async {
    final response = await http.get('${SystemConfig.getInstance().apiUrl}/data/$path').timeout(Duration(seconds: 1));
    return response.bodyBytes;
  }

  List<CANFrame> _decodeFrames(Uint8List data) {
    return List<CANFrame>.generate(data.length ~/ 16, (int i) {
      final msgBytes = data.sublist(16*i);

      return CANFrame(
        Uint32List.view(msgBytes.buffer, 0)[0],
        Uint16List.view(msgBytes.buffer, 4)[0],
        msgBytes.sublist(8),
      );
    });
  }
}