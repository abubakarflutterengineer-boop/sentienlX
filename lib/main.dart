import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'controllers/security_controller.dart';
import 'repositories/security_repository.dart';
import 'services/native_security_service.dart';
import 'services/photo_service.dart';
import 'services/share_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(SecurityRepository(), permanent: true);
  Get.put(NativeSecurityService(), permanent: true);
  Get.put(PhotoService(), permanent: true);
  Get.put(ShareService(), permanent: true);
  Get.put(SecurityController(
    repository: Get.find(),
    nativeSecurityService: Get.find(),
    photoService: Get.find(),
  ), permanent: true);
  runApp(const SentinelXApp());
}
