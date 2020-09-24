class BusSystemStatus {
  final bool isEra;

  BusSystemStatus({ this.isEra });

  factory BusSystemStatus.fromJson(Map<String, dynamic> json) {
    return BusSystemStatus(
      isEra: json["isEra"],
    );
  }
}

class BusStatus {
  final int messageFrequency;
  final int busLoad;
  final BusSystemStatus systemStatus;

  BusStatus({ this.messageFrequency, this.busLoad, this.systemStatus });

  factory BusStatus.fromJson(Map<String, dynamic> json) {
    return BusStatus(
      messageFrequency: json["msgFrequency"],
      busLoad: json["busLoad"],
      systemStatus: BusSystemStatus.fromJson(json["system"]),
    );
  }
}

class SystemStatus {
  final BusStatus busStatus;
  final String error;
  final bool isConnected;
  final bool isRefreshing;

  SystemStatus.connected(BusStatus status)
    : busStatus = status, isConnected = true, error = null, isRefreshing = false;

  SystemStatus.disconnected(String error)
    : busStatus = null, isConnected = false, error = error, isRefreshing = false;

  SystemStatus.refreshing(SystemStatus old)
    : busStatus = old.busStatus, isConnected = old.isConnected, error = old.error, isRefreshing = true;
}