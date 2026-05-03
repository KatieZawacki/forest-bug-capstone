import 'package:hive/hive.dart';
part 'forest_progress.g.dart';

@HiveType(typeId: 4)
class ForestProgress extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int totalTrees; // always 8
  @HiveField(2)
  final int bloomedTrees; // 0-8
  @HiveField(3)
  final DateTime lastResetDate;
  @HiveField(4)
  final int bloomCycleLength; // days in a cycle

  ForestProgress({
    this.id,
    this.totalTrees = 8,
    required this.bloomedTrees,
    required this.lastResetDate,
    this.bloomCycleLength = 8,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalTrees': totalTrees,
      'bloomedTrees': bloomedTrees,
      'lastResetDate': lastResetDate.toIso8601String(),
      'bloomCycleLength': bloomCycleLength,
    };
  }

  factory ForestProgress.fromMap(Map<String, dynamic> map) {
    return ForestProgress(
      id: map['id'],
      totalTrees: map['totalTrees'] ?? 8,
      bloomedTrees: map['bloomedTrees'],
      lastResetDate: DateTime.parse(map['lastResetDate']),
      bloomCycleLength: map['bloomCycleLength'] ?? 8,
    );
  }
}
