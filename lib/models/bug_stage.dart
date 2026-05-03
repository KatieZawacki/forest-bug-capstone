import 'package:hive/hive.dart';
part 'bug_stage.g.dart';

@HiveType(typeId: 3)
class BugStage extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String stage; // e.g., "caterpillar", "cocoon", "butterfly"
  @HiveField(2)
  final int progressPoints;
  @HiveField(3)
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
