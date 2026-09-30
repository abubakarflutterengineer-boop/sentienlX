import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareText() => SharePlus.instance.share(
    ShareParams(text: 'SentinelX - Your Phone. Your Security. Your Sentinel.'),
  );
}
