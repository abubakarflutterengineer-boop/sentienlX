import 'dart:io';
import 'package:get/get.dart';
import '../constants/app_strings.dart';
import '../models/security_event.dart';
import '../repositories/security_repository.dart';
import '../services/native_security_service.dart';
import '../services/photo_service.dart';

class SecurityController extends GetxController {
  final SecurityRepository repository;
  final NativeSecurityService nativeSecurityService;
  final PhotoService photoService;
  SecurityController({required this.repository,required this.nativeSecurityService,required this.photoService});
  final securityEnabled=true.obs;
  final deviceAdminEnabled=false.obs;
  final failedAttempts=0.obs;
  final alarmEnabled=true.obs;
  final pendingCapture=false.obs;
  final processing=false.obs;
  final photos=<String>[].obs;
  final events=<SecurityEvent>[].obs;

  @override void onInit(){super.onInit(); load();}
  Future<void> load() async { securityEnabled.value=await repository.getEnabled(); deviceAdminEnabled.value=await nativeSecurityService.isDeviceAdminEnabled(); failedAttempts.value=await nativeSecurityService.getFailedAttempts(); events.assignAll(await repository.getEvents()); photos.assignAll(events.map((e)=>e.imagePath).where((p)=>p.isNotEmpty)); pendingCapture.value=await nativeSecurityService.hasPendingCapture(); }
  Future<void> enableAdmin() async { await nativeSecurityService.enableDeviceAdmin(); deviceAdminEnabled.value=await nativeSecurityService.isDeviceAdminEnabled(); }
  Future<void> setSecurity(bool v) async {securityEnabled.value=v; await repository.setEnabled(v); if(v) await enableAdmin();}
  Future<void> testSecurity() async { if(processing.value)return; processing.value=true; try { failedAttempts.value++; if(failedAttempts.value>=AppStrings.threshold && failedAttempts.value%AppStrings.threshold==0) await handleThreshold(); } finally {processing.value=false;} }
  Future<void> handleThreshold() async { if(!securityEnabled.value)return; pendingCapture.value=true; await nativeSecurityService.startAlarm(); }
  Future<void> capturePendingEvidence() async { if(!pendingCapture.value)return; final file=await photoService.capture(); if(file!=null){photos.insert(0,file.path); final event=SecurityEvent(time:DateTime.now(),failedAttempts:failedAttempts.value,capturePending:false,imagePath:file.path); events.insert(0,event); await repository.saveEvent(event); await nativeSecurityService.clearPendingCapture(); pendingCapture.value=false;} }
  Future<void> deletePhoto(String path) async { final f=File(path); await photoService.delete(f); photos.remove(path); final target=events.firstWhereOrNull((e)=>e.imagePath==path); if(target!=null){events.remove(target);await repository.deleteEvent(target);} }
  Future<void> stopAlarm()=>nativeSecurityService.stopAlarm();
  Future<void> resetAttempts() async {await nativeSecurityService.resetFailedAttempts();failedAttempts.value=0;}
  Future<void> shareApk()=>nativeSecurityService.shareInstalledApk();
}
