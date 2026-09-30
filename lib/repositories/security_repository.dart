import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/security_event.dart';
class SecurityRepository {
  static const _events = 'events';
  static const _enabled = 'enabled';
  Future<SharedPreferences> get _p async => SharedPreferences.getInstance();
  Future<bool> getEnabled() async => (await _p).getBool(_enabled) ?? true;
  Future<void> setEnabled(bool v) async => (await _p).setBool(_enabled, v);
  Future<List<SecurityEvent>> getEvents() async => ((await _p).getStringList(_events) ?? []).map((e) => SecurityEvent.fromMap(jsonDecode(e))).toList();
  Future<void> saveEvent(SecurityEvent e) async { final p=await _p; final list=await getEvents(); list.insert(0,e); await p.setStringList(_events,list.take(100).map((x)=>jsonEncode(x.toMap())).toList()); }
  Future<void> deleteEvent(SecurityEvent e) async { final p=await _p; final list=await getEvents(); list.removeWhere((x)=>x.time==e.time && x.imagePath==e.imagePath); await p.setStringList(_events,list.map((x)=>jsonEncode(x.toMap())).toList()); }
}
