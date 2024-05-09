abstract interface class SettingsGateway {
  Future<bool> setRestTime(Duration duration);
  Future<Duration> getRestTime();
}