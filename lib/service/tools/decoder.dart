import 'dart:typed_data';

enum UnderlyingType { u8 }

class EnumDef<T> {
  final List<T> values;
  final UnderlyingType underlyingType;

  EnumDef(this.underlyingType, this.values);

  T decode(int data) {
    return values[data];
  }
}

class Decoder {
  final Uint8List _rawData;

  Decoder(Uint8List data) : _rawData = data;

  EndianDecoder get little => EndianDecoder(_rawData, Endian.little);
  EndianDecoder get big => EndianDecoder(_rawData, Endian.big);

  int decodeS8(int offset) => Int8List.view(_rawData.sublist(offset, offset+1).buffer)[0];
  int decodeU8(int offset) => _rawData[offset];

  double decodeF32(int offset) => Float32List.view(_rawData.sublist(offset, offset+4).buffer)[0];
  double decodeF64(int offset) => Float64List.view(_rawData.sublist(offset, offset+8).buffer)[0];
}

class EndianDecoder extends Decoder {
  final Endian endian;

  EndianDecoder(Uint8List rawData, this.endian) : super(rawData);

  int decodeU16(int offset) => Uint16List.view(_s(_rawData.sublist(offset, offset+2)).buffer)[0];
  int decodeU32(int offset) => Uint32List.view(_s(_rawData.sublist(offset, offset+4)).buffer)[0];
  int decodeU64(int offset) => Uint64List.view(_s(_rawData.sublist(offset, offset+8)).buffer)[0];

  int decodeS16(int offset) => Int16List.view(_s(_rawData.sublist(offset, offset+2)).buffer)[0];
  int decodeS32(int offset) => Int32List.view(_s(_rawData.sublist(offset, offset+4)).buffer)[0];
  int decodeS64(int offset) => Int64List.view(_s(_rawData.sublist(offset, offset+8)).buffer)[0];

  T decodeEnum<T>(EnumDef<T> def, int offset) {
    switch (def.underlyingType) {
      case UnderlyingType.u8:
        return def.decode(decodeU8(offset));
    }
    return def.decode(0);
  }

  Uint8List _s(Uint8List src) {
    if (this.endian == Endian.big) {
      Uint8List dst = Uint8List(src.length);
      for (var i = 0; i < src.length; i++) {
        dst[dst.length-i-1] = src[i];
      }
      return dst;
    }

    return src;
  }


}
