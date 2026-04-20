import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';
import '../models/goal.dart';
import '../models/check_in.dart';
import '../models/bug_stage.dart';
import '../models/forest_progress.dart';

// Database provider
final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

// Goals
final goalsProvider = FutureProvider<List<Goal>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getGoals();
});

// Check-ins
final checkInsProvider = FutureProvider<List<CheckIn>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getCheckIns();
});

// Bug Stage
final bugStageProvider = FutureProvider<BugStage?>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getLatestBugStage();
});

// Forest Progress
final forestProgressProvider = FutureProvider<ForestProgress?>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getForestProgress();
});

// Add goal notifier
final addGoalProvider = FutureProvider.family<void, Goal>((ref, goal) async {
  final db = ref.watch(databaseProvider);
  await db.insertGoal(goal);
  // Invalidate goals to refresh the list
  final _ = ref.refresh(goalsProvider);
});

// Add check-in notifier
final addCheckInProvider = FutureProvider.family<void, CheckIn>((ref, checkIn) async {
  final db = ref.watch(databaseProvider);
  await db.insertCheckIn(checkIn);
  // Invalidate check-ins to refresh the list
  final _ = ref.refresh(checkInsProvider);
});

// Update bug stage notifier
final updateBugStageProvider = FutureProvider.family<void, BugStage>((ref, bugStage) async {
  final db = ref.watch(databaseProvider);
  if (bugStage.id != null) {
    await db.updateBugStage(bugStage);
  } else {
    await db.insertBugStage(bugStage);
  }
  // Invalidate bug stage to refresh
  final _ = ref.refresh(bugStageProvider);
});

// Update forest progress notifier
final updateForestProgressProvider = FutureProvider.family<void, ForestProgress>((ref, progress) async {
  final db = ref.watch(databaseProvider);
  if (progress.id != null) {
    await db.updateForestProgress(progress);
  } else {
    await db.insertForestProgress(progress);
  }
  // Invalidate forest progress to refresh
  final _ = ref.refresh(forestProgressProvider);
});
