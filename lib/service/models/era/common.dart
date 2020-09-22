import 'package:amice/service/tools/decoder.dart';

enum OnOff { none, off, on }

class ControllerVersion {
  final int swMajor;
  final int swMinor;
  final int eslibMajor;
  final int eslibMinor;
  final int cliMajor;
  final int cliMinor;

  ControllerVersion(
      {this.swMajor,
        this.swMinor,
        this.eslibMajor,
        this.eslibMinor,
        this.cliMajor,
        this.cliMinor});

  factory ControllerVersion.decode(Decoder d) {
    return ControllerVersion(
      swMajor: d.decodeU8(0),
      swMinor: d.decodeU8(1),
      eslibMajor: d.decodeU8(2),
      eslibMinor: d.decodeU8(3),
      cliMajor: d.decodeU8(4),
      cliMinor: d.decodeU8(5),
    );
  }
}

class OnOffEnumDef extends EnumDef<OnOff> {
  OnOffEnumDef()
    : super(UnderlyingType.u8, [OnOff.none, OnOff.off, OnOff.on]);
}
