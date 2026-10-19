class LogEntry {
  final String id;
  final DateTime timestamp;
  final String title;
  final String description;
  final String type; // INIT, PROTOCOL, QUEST_COMPLETE, PENALTY, ASCENSION
  final int? expEarned;

  LogEntry({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.type,
    this.expEarned,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'title': title,
        'description': description,
        'type': type,
        'expEarned': expEarned,
      };

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
        id: json['id'],
        timestamp: DateTime.parse(json['timestamp']),
        title: json['title'],
        description: json['description'],
        type: json['type'],
        expEarned: json['expEarned'],
      );

  static List<LogEntry> defaultEntries() => [
        LogEntry(
          id: 'log_02',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          title: 'Daily protocols loaded.',
          description: 'Five standard objectives pending execution.',
          type: 'PROTOCOL',
        ),
        LogEntry(
          id: 'log_01',
          timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
          title: 'Account initialized. Ready for first quest.',
          description: 'Profile created with standard cadence baseline.',
          type: 'INIT',
        ),
      ];
}
