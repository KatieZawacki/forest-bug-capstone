import 'package:hive/hive.dart';
part 'butterfly_unlock.g.dart';

@HiveType(typeId: 5)
class ButterflyUnlock extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String imagePath;
  @HiveField(2)
  final DateTime unlockedAt;
  @HiveField(3)
  final int goalDurationDays; // Duration of the goal in days
  @HiveField(4)
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
