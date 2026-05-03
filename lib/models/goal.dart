import 'package:hive/hive.dart';
part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool isCompleted;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final int durationDays; // Total duration of the goal in days
  @HiveField(6)
  final String frequency; // e.g., 'daily', 'weekly', etc.

  Goal({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    required this.durationDays,
    required this.frequency,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'durationDays': durationDays,
      'frequency': frequency,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      durationDays: map['durationDays'],
      frequency: map['frequency'],
    );
  }

  /// Returns butterfly rarity string based on durationDays
  String getButterflyRarity() {
    if (durationDays <= 7) {
      return 'common';
    } else if (durationDays <= 31) {
      return 'uncommon';
    } else if (durationDays <= 92) { // ~3 months
      return 'rare';
    } else if (durationDays <= 183) { // ~6 months
      return 'ultra rare';
    } else {
      return 'legendary';
    }
  }

  /// Returns the current butterfly stage based on elapsed time
  String getCurrentButterflyStage(DateTime now) {
    if (isCompleted) return 'butterfly';
    final elapsed = now.difference(createdAt).inDays;
    if (durationDays <= 1) {
      if (elapsed == 0) return 'egg';
      if (elapsed == 1) return 'caterpillar';
      return 'pupa';
    }
    // For longer goals, split duration into 3 stages
    final stageLength = (durationDays / 3).ceil();
    if (elapsed < stageLength) {
      return 'egg';
    } else if (elapsed < 2 * stageLength) {
      return 'caterpillar';
    } else {
      return 'pupa';
    }
  }
}
