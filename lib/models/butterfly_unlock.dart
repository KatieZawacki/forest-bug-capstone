class ButterflyUnlock {
  final int? id;
  final String imagePath;
  final DateTime unlockedAt;
  final int goalDurationDays; // Duration of the goal in days
  final bool isLegendary;

  ButterflyUnlock({
    this.id,
    required this.imagePath,
    required this.unlockedAt,
    required this.goalDurationDays,
    this.isLegendary = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'unlockedAt': unlockedAt.toIso8601String(),
      'goalDurationDays': goalDurationDays,
      'isLegendary': isLegendary ? 1 : 0,
    };
  }

  factory ButterflyUnlock.fromMap(Map<String, dynamic> map) {
    return ButterflyUnlock(
      id: map['id'],
      imagePath: map['imagePath'],
      unlockedAt: DateTime.parse(map['unlockedAt']),
      goalDurationDays: map['goalDurationDays'],
      isLegendary: map['isLegendary'] == 1,
    );
  }
}
