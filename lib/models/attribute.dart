class Attribute {
  final String code; // STR, INT, WIL, CHA, FOC
  final String name; // Strength, Intellect, Willpower, Charisma, Focus
  int currentValue;
  final int maxValue;
  final String description;
  final String impact;

  Attribute({
    required this.code,
    required this.name,
    this.currentValue = 0,
    this.maxValue = 100,
    required this.description,
    required this.impact,
  });

  double get progressRatio => (currentValue / maxValue).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'currentValue': currentValue,
        'maxValue': maxValue,
        'description': description,
        'impact': impact,
      };

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        code: json['code'],
        name: json['name'],
        currentValue: json['currentValue'] ?? 0,
        maxValue: json['maxValue'] ?? 100,
        description: json['description'] ?? '',
        impact: json['impact'] ?? '',
      );

  static List<Attribute> defaultAttributes() => [
        Attribute(
          code: 'STR',
          name: 'Strength',
          currentValue: 0,
          description: 'Physical fortitude, metabolic efficiency, and biological raw energy.',
          impact: 'Eliminates lethargy and enforces somatic dominance.',
        ),
        Attribute(
          code: 'INT',
          name: 'Intellect',
          currentValue: 0,
          description: 'Cognitive processing, deep software architecture, and abstract synthesis.',
          impact: 'Transforms complex chaotic problems into clean deterministic solutions.',
        ),
        Attribute(
          code: 'WIL',
          name: 'Willpower',
          currentValue: 0,
          description: 'Resistance against dopamine traps, passivity, and digital sedation.',
          impact: 'The primary armor against mental gravity.',
        ),
        Attribute(
          code: 'CHA',
          name: 'Charisma',
          currentValue: 0,
          description: 'Articulate vocal delivery, authoritative presence, and clear interpersonal leverage.',
          impact: 'Direct transmission of conviction without hesitation.',
        ),
        Attribute(
          code: 'FOC',
          name: 'Focus',
          currentValue: 0,
          description: 'Attention density, temporal planning, and mental clarity.',
          impact: 'Eliminates brain fog through strict execution of daily priorities.',
        ),
      ];
}
