import 'package:hive/hive.dart';
part 'check_in.g.dart';

@HiveType(typeId: 2)
class CheckIn extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String notes;
  @HiveField(2)
  final DateTime timestamp;

  CheckIn({
    this.id,
    required this.notes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CheckIn.fromMap(Map<String, dynamic> map) {
    return CheckIn(
      id: map['id'],
      notes: map['notes'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
