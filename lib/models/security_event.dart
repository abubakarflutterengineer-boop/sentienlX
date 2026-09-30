class SecurityEvent {
  final DateTime time;
  final int failedAttempts;
  final bool capturePending;
  final String imagePath;
  const SecurityEvent({required this.time, required this.failedAttempts, this.capturePending = false, this.imagePath = ''});
  Map<String,dynamic> toMap() => {'time':time.toIso8601String(),'failedAttempts':failedAttempts,'capturePending':capturePending,'imagePath':imagePath};
  factory SecurityEvent.fromMap(Map<String,dynamic> m) => SecurityEvent(time: DateTime.tryParse('${m['time']}') ?? DateTime.now(), failedAttempts: int.tryParse('${m['failedAttempts']}') ?? 0, capturePending: m['capturePending'] == true, imagePath: '${m['imagePath'] ?? ''}');
}
