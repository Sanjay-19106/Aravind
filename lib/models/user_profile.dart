class UserProfile {
  String name;
  String alterEgo;
  String rank;
  int level;
  int currentExp;
  int maxExpPerLevel;
  int streakDays;
  DateTime joinedDate;
  int totalCompletedQuests;
  int totalAccumulatedExp;
  String buffs;

  UserProfile({
    this.name = 'Sanjay',
    this.alterEgo = 'Aravind',
    this.rank = 'Rank E',
    this.level = 0,
    this.currentExp = 0,
    this.maxExpPerLevel = 1000,
    this.streakDays = 0,
    DateTime? joinedDate,
    this.totalCompletedQuests = 0,
    this.totalAccumulatedExp = 0,
    this.buffs = 'None Dormant',
  }) : joinedDate = joinedDate ?? DateTime.now();

  double get expProgressRatio =>
      (currentExp / maxExpPerLevel).clamp(0.0, 1.0);

  String get tierName {
    if (level < 5) return 'Inception Tier';
    if (level < 15) return 'Awakened Novice Tier';
    if (level < 30) return 'Ascendant Tier';
    if (level < 50) return 'Shadow Monarch Tier';
    return 'Absolute Sovereign Tier';
  }

  String get rankDescription {
    switch (rank) {
      case 'Rank E':
        return 'Unranked Novice';
      case 'Rank D':
        return 'Disciplined Apprentice';
      case 'Rank C':
        return 'Hardened Operator';
      case 'Rank B':
        return 'Relentless Executioner';
      case 'Rank A':
        return 'Elite Ascendant';
      case 'Rank S':
        return 'Optimal Alter Ego';
      default:
        return 'Novice';
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'alterEgo': alterEgo,
        'rank': rank,
        'level': level,
        'currentExp': currentExp,
        'maxExpPerLevel': maxExpPerLevel,
        'streakDays': streakDays,
        'joinedDate': joinedDate.toIso8601String(),
        'totalCompletedQuests': totalCompletedQuests,
        'totalAccumulatedExp': totalAccumulatedExp,
        'buffs': buffs,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] ?? 'Sanjay',
        alterEgo: json['alterEgo'] ?? 'Aravind',
        rank: json['rank'] ?? 'Rank E',
        level: json['level'] ?? 0,
        currentExp: json['currentExp'] ?? 0,
        maxExpPerLevel: json['maxExpPerLevel'] ?? 1000,
        streakDays: json['streakDays'] ?? 0,
        joinedDate: json['joinedDate'] != null
            ? DateTime.parse(json['joinedDate'])
            : DateTime.now(),
        totalCompletedQuests: json['totalCompletedQuests'] ?? 0,
        totalAccumulatedExp: json['totalAccumulatedExp'] ?? 0,
        buffs: json['buffs'] ?? 'None Dormant',
      );
}
