# SentinelX

This version is designed around Android's supported device-admin password-failure callbacks.

Important limitation: a normal third-party app cannot secretly open the camera while the phone is on the system lock screen. After every 3 consecutive supported credential failures, SentinelX stores a pending capture event and posts a high-priority notification. The user opens SentinelX and explicitly starts the camera capture. This avoids bypassing Android's lock-screen/background-camera protections.

Every additional 3 failures (6, 9, 12...) creates another pending event. A successful device credential resets the consecutive counter.

Evidence photos are copied to app-private storage and can be deleted from the app.

The Share Installed APK button uses Android FileProvider and the system Sharesheet to share the currently installed APK. The QR is intentionally not a fake Play Store URL; it identifies SentinelX only. Replace it later with a real download URL if desired.

Create a fresh Flutter project, then merge/replace these files and run `flutter pub get` and `flutter run`.
