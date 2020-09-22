class SystemConfig {
  String apiUrl;

  factory SystemConfig.getInstance() {
    if (_instance == null) {
      _instance = SystemConfig._privateConstructor();
    }
    return _instance;
  }

  SystemConfig._privateConstructor()
    : apiUrl = 'http://192.168.178.54';

  static SystemConfig _instance;
}