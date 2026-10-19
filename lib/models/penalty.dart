class PenaltyConfig {
  String penaltyText;
  bool isPledgeActive;
  int breachCount;
  bool isUnderPenalty;
  DateTime? penaltyTriggeredDate;

  PenaltyConfig({
    this.penaltyText = '100 pushups & 12h screen limit',
    this.isPledgeActive = true,
    this.breachCount = 0,
    this.isUnderPenalty = false,
    this.penaltyTriggeredDate,
  });

  Map<String, dynamic> toJson() => {
        'penaltyText': penaltyText,
        'isPledgeActive': isPledgeActive,
        'breachCount': breachCount,
        'isUnderPenalty': isUnderPenalty,
        'penaltyTriggeredDate': penaltyTriggeredDate?.toIso8601String(),
      };

  factory PenaltyConfig.fromJson(Map<String, dynamic> json) => PenaltyConfig(
        penaltyText: json['penaltyText'] ?? '100 pushups & 12h screen limit',
        isPledgeActive: json['isPledgeActive'] ?? true,
        breachCount: json['breachCount'] ?? 0,
        isUnderPenalty: json['isUnderPenalty'] ?? false,
        penaltyTriggeredDate: json['penaltyTriggeredDate'] != null
            ? DateTime.parse(json['penaltyTriggeredDate'])
            : null,
      );
}
