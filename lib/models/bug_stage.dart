class BugStage {
  final int? id;
  final String stage; // e.g., "caterpillar", "cocoon", "butterfly"
  final int progressPoints;
  final DateTime updatedAt;

  BugStage({
    this.id,
    required this.stage,
    required this.progressPoints,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stage': stage,
      'progressPoints': progressPoints,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BugStage.fromMap(Map<String, dynamic> map) {
    return BugStage(
      id: map['id'],
      stage: map['stage'],
      progressPoints: map['progressPoints'],
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
