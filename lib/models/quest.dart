class Quest {
  final String id;
  final String title;
  final String duration;
  final String attributeCode;
  final int attributeGain;
  final int expGain;
  bool isCompleted;
  DateTime? completedAt;
  final bool isCustom;

  Quest({
    required this.id,
    required this.title,
    required this.duration,
    required this.attributeCode,
    required this.attributeGain,
    required this.expGain,
    this.isCompleted = false,
    this.completedAt,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'duration': duration,
        'attributeCode': attributeCode,
        'attributeGain': attributeGain,
        'expGain': expGain,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'isCustom': isCustom,
      };

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
        id: json['id'],
        title: json['title'],
        duration: json['duration'],
        attributeCode: json['attributeCode'],
        attributeGain: json['attributeGain'] ?? 10,
        expGain: json['expGain'] ?? 10,
        isCompleted: json['isCompleted'] ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
        isCustom: json['isCustom'] ?? false,
      );

  static List<Quest> defaultProtocols() => [
        Quest(
          id: 'q_str_1',
          title: 'Morning Physical Training',
          duration: '60 mins',
          attributeCode: 'STR',
          attributeGain: 10,
          expGain: 10,
        ),
        Quest(
          id: 'q_int_1',
          title: 'Deep Work & Code',
          duration: '90 mins focused',
          attributeCode: 'INT',
          attributeGain: 15,
          expGain: 15,
        ),
        Quest(
          id: 'q_wil_1',
          title: 'Distraction-Free Focus',
          duration: 'Zero social media',
          attributeCode: 'WIL',
          attributeGain: 20,
          expGain: 20,
        ),
        Quest(
          id: 'q_cha_1',
          title: 'Vocal & Communication Drills',
          duration: '20 mins speaking',
          attributeCode: 'CHA',
          attributeGain: 10,
          expGain: 10,
        ),
        Quest(
          id: 'q_foc_1',
          title: 'Daily Review & Planning',
          duration: 'Organize tomorrow',
          attributeCode: 'FOC',
          attributeGain: 10,
          expGain: 10,
        ),
      ];
}
