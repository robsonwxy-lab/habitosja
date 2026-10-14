class Habit {
  final String id;
  final String name;
  final String emoji;
  final String category;
  final int hour;
  final int minute;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.hour,
    required this.minute,
    required this.createdAt,
    this.completedDates = const [],
  });

  Habit copyWith({
    String? id,
    String? name,
    String? emoji,
    String? category,
    int? hour,
    int? minute,
    DateTime? createdAt,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'category': category,
      'hour': hour,
      'minute': minute,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '🚀',
      category: json['category'] as String? ?? 'Geral',
      hour: json['hour'] as int? ?? 8,
      minute: json['minute'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((e) => DateTime.tryParse(e.toString()) ?? DateTime.now())
              .toList() ??
          [],
    );
  }
}
