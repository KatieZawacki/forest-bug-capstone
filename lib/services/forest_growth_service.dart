import '../models/forest_progress.dart';
import 'database_helper.dart';

class ForestGrowthService {
  static const int totalTrees = 8;
  static const int bloomCycleLength = 8; // days in a cycle

  /// Call this after a check-in or on app open to update forest progress.
  static Future<void> updateForestProgress(DatabaseHelper db) async {
    final progressList = await db.getForestProgress();
    ForestProgress? forestProgress = progressList.isNotEmpty ? progressList.first : null;
    final now = DateTime.now();

    if (forestProgress == null) {
      // Initialize forest
      forestProgress = ForestProgress(
        totalTrees: totalTrees,
        bloomedTrees: 0,
        lastResetDate: now,
        bloomCycleLength: bloomCycleLength,
      );
      await db.insertForestProgress(forestProgress);
      return;
    }

    // Check if we need to reset the cycle
    final lastResetDate = forestProgress.lastResetDate;
    final daysSinceReset = now.difference(lastResetDate).inDays;
    if (daysSinceReset >= bloomCycleLength) {
      // Reset forest
      final resetProgress = ForestProgress(
        id: forestProgress.id,
        totalTrees: totalTrees,
        bloomedTrees: 0,
        lastResetDate: now,
        bloomCycleLength: bloomCycleLength,
      );
      await db.updateForestProgress(forestProgress.key as int, resetProgress);
      return;
    }

    // Get all check-ins since last reset
    final checkIns = await db.getCheckIns();
    final checkInsSinceReset = checkIns.where((c) => c.timestamp.isAfter(lastResetDate)).toList();

    // Count unique days with check-ins since last reset
    final uniqueDays = <String>{};
    for (final checkIn in checkInsSinceReset) {
      final dayStr = DateTime(checkIn.timestamp.year, checkIn.timestamp.month, checkIn.timestamp.day).toIso8601String();
      uniqueDays.add(dayStr);
    }
    final bloomed = uniqueDays.length.clamp(0, totalTrees);

    if (bloomed != forestProgress.bloomedTrees) {
      final updatedProgress = ForestProgress(
        id: forestProgress.id,
        totalTrees: totalTrees,
        bloomedTrees: bloomed,
        lastResetDate: lastResetDate,
        bloomCycleLength: bloomCycleLength,
      );
      await db.updateForestProgress(forestProgress.key as int, updatedProgress);
    }
  }
}
