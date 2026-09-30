import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/security_controller.dart';
import '../services/share_service.dart';
import '../widgets/app_qr_card.dart';
import '../widgets/icon_box.dart';
import '../widgets/primary_button.dart';
import '../widgets/security_card.dart';

class HomeScreen extends GetView<SecurityController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SentinelX',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<ShareService>().shareText();
            },
            icon: const Icon(Icons.share_rounded),
          ),
          IconButton(
            onPressed: controller.shareApk,
            icon: const Icon(Icons.file_download_outlined),
          ),
        ],
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _buildSecurityCard(),

            const SizedBox(height: 14),

            _buildAdminCard(),

            const SizedBox(height: 14),

            _buildFailedAttemptsCard(),

            const SizedBox(height: 14),

            if (controller.pendingCapture.value) _buildPendingCaptureCard(),

            if (controller.pendingCapture.value) const SizedBox(height: 14),

            const AppQrCard(),

            const SizedBox(height: 14),

            PrimaryButton(
              text: 'TEST SECURITY',
              icon: Icons.security_rounded,
              onPressed: controller.testSecurity,
            ),

            const SizedBox(height: 14),

            PrimaryButton(
              text: 'SHARE INSTALLED APK',
              icon: Icons.share_rounded,
              onPressed: controller.shareApk,
            ),

            const SizedBox(height: 20),

            const Text(
              'Evidence Photos',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 10),

            _buildEvidencePhotos(),
          ],
        );
      }),
    );
  }

  Widget _buildSecurityCard() {
    return SecurityCard(
      child: Row(
        children: [
          const IconBox(icon: Icons.shield_rounded, color: AppColors.primary),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SECURITY ACTIVE',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                SizedBox(height: 4),
                Text(
                  'Device security monitoring',
                  style: TextStyle(color: AppColors.secondaryText),
                ),
              ],
            ),
          ),

          Switch.adaptive(
            value: controller.securityEnabled.value,
            onChanged: controller.setSecurity,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard() {
    final bool adminEnabled = controller.deviceAdminEnabled.value;

    return SecurityCard(
      child: Column(
        children: [
          Row(
            children: [
              const IconBox(
                icon: Icons.admin_panel_settings_rounded,
                color: AppColors.cyan,
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Text(
                  'Device Administrator',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),

              Text(
                adminEnabled ? 'ACTIVE' : 'OFF',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: adminEnabled ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          PrimaryButton(
            text: adminEnabled ? 'ADMIN ACTIVE' : 'ENABLE ADMIN',
            icon: Icons.security,
            onPressed: adminEnabled ? null : controller.enableAdmin,
          ),
        ],
      ),
    );
  }

  Widget _buildFailedAttemptsCard() {
    return SecurityCard(
      child: Column(
        children: [
          Row(
            children: [
              const IconBox(icon: Icons.lock_outline, color: AppColors.warning),

              const SizedBox(width: 14),

              const Expanded(
                child: Text(
                  'Failed Attempts',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),

              Text(
                '${controller.failedAttempts.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Every 3 consecutive supported credential failures '
            'creates a pending security capture event. '
            'The app then asks the device user to open '
            'SentinelX and take the evidence photo.',
            style: TextStyle(color: AppColors.secondaryText, height: 1.45),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              TextButton(
                onPressed: controller.resetAttempts,
                child: const Text('Reset'),
              ),

              const Spacer(),

              TextButton(
                onPressed: controller.stopAlarm,
                child: const Text('Stop Alarm'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCaptureCard() {
    return SecurityCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security Event Requires Evidence',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 8),

          const Text(
            'Android does not allow a normal app to secretly '
            'open the camera from the lock screen. Open '
            'SentinelX and use the button below to capture '
            'the person who attempted the unlock.',
            style: TextStyle(color: AppColors.secondaryText, height: 1.45),
          ),

          const SizedBox(height: 14),

          PrimaryButton(
            text: 'CAPTURE EVIDENCE PHOTO',
            icon: Icons.camera_alt_rounded,
            onPressed: controller.capturePendingEvidence,
          ),
        ],
      ),
    );
  }

  Widget _buildEvidencePhotos() {
    if (controller.photos.isEmpty) {
      return const SecurityCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'No photos saved yet',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
        ),
      );
    }

    return Column(
      children: controller.photos.map((path) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPhotoCard(path),
        );
      }).toList(),
    );
  }

  Widget _buildPhotoCard(String path) {
    return SecurityCard(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              File(path),
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 190,
                  child: Center(child: Icon(Icons.broken_image, size: 40)),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                controller.deletePhoto(path);
              },
              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              label: const Text(
                'Delete Photo',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
