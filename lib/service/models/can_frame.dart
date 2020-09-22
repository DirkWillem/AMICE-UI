import 'dart:typed_data';

class CANFrame {
  final int timestamp;
  final int id;
  Uint8List data;

  CANFrame(this.timestamp, this.id, this.data);
}