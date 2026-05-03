import 'package:hive/hive.dart';
part 'forest_progress.g.dart';

@HiveType(typeId: 4)
class ForestProgress extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int totalTrees;
  @HiveField(2)
  final int treesCultivated;
  @HiveField(3)
  final DateTime lastUpdated;

  ForestProgress({
    this.id,
    required this.totalTrees,
    required this.treesCultivated,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalTrees': totalTrees,
      'treesCultivated': treesCultivated,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory ForestProgress.fromMap(Map<String, dynamic> map) {
    return ForestProgress(
      id: map['id'],
      totalTrees: map['totalTrees'],
      treesCultivated: map['treesCultivated'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}
