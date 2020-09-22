class BusSystemStatus {
  final bool isEra;

  BusSystemStatus({ this.isEra });
}

class BusStatus {
  final int messageFrequency;
  final int busLoad;
  final BusSystemStatus systemStatus;

  BusStatus({ this.messageFrequency, this.busLoad, this.systemStatus });
}
