import 'package:flutter/services.dart';
class NativeSecurityService {
  static const _channel = MethodChannel('com.example.sentinelx/security');
  Future<bool> enableDeviceAdmin() async => await _channel.invokeMethod<bool>('enableDeviceAdmin') ?? false;
  Future<bool> isDeviceAdminEnabled() async => await _channel.invokeMethod<bool>('isDeviceAdminEnabled') ?? false;
  Future<int> getFailedAttempts() async => await _channel.invokeMethod<int>('getFailedAttempts') ?? 0;
  Future<void> resetFailedAttempts() => _channel.invokeMethod('resetFailedAttempts');
  Future<void> startAlarm() => _channel.invokeMethod('startAlarm');
  Future<void> stopAlarm() => _channel.invokeMethod('stopAlarm');
  Future<bool> hasPendingCapture() async => await _channel.invokeMethod<bool>('hasPendingCapture') ?? false;
  Future<void> clearPendingCapture() => _channel.invokeMethod('clearPendingCapture');
  Future<void> shareInstalledApk() => _channel.invokeMethod('shareInstalledApk');
}
