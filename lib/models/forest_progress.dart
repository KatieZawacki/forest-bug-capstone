class ForestProgress {
  final int? id;
  final int totalTrees;
  final int treesCultivated;
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
