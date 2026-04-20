class CheckIn {
  final int? id;
  final String notes;
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
