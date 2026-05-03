import 'package:hive/hive.dart';
import '../models/goal.dart';
import '../models/check_in.dart';
import '../models/bug_stage.dart';
import '../models/forest_progress.dart';
import '../models/butterfly_unlock.dart';

class DatabaseHelper {
    // Update BugStage
    Future<void> updateBugStage(int key, BugStage bugStage) async {
      final box = await Hive.openBox<BugStage>(bugStagesBox);
      await box.put(key, bugStage);
    }

    // Update ForestProgress
    Future<void> updateForestProgress(int key, ForestProgress progress) async {
      final box = await Hive.openBox<ForestProgress>(forestProgressBox);
      await box.put(key, progress);
    }
  // Hive box names
  static const String goalsBox = 'goals';
  static const String checkInsBox = 'checkIns';
  static const String bugStagesBox = 'bugStages';
  static const String forestProgressBox = 'forestProgress';
  static const String butterflyUnlocksBox = 'butterflyUnlocks';

  // Butterfly Unlocks
  Future<void> insertButterflyUnlock(ButterflyUnlock unlock) async {
    final box = await Hive.openBox<ButterflyUnlock>(butterflyUnlocksBox);
    await box.add(unlock);
  }

  Future<List<ButterflyUnlock>> getButterflyUnlocks() async {
    final box = await Hive.openBox<ButterflyUnlock>(butterflyUnlocksBox);
    return box.values.toList();
  }

  Future<void> deleteButterflyUnlock(int key) async {
    final box = await Hive.openBox<ButterflyUnlock>(butterflyUnlocksBox);
    await box.delete(key);
  }

  // Goals
  Future<void> insertGoal(Goal goal) async {
    final box = await Hive.openBox<Goal>(goalsBox);
    await box.add(goal);
  }

  Future<List<Goal>> getGoals() async {
    final box = await Hive.openBox<Goal>(goalsBox);
    return box.values.toList();
  }

  // CheckIns
  Future<void> insertCheckIn(CheckIn checkIn) async {
    final box = await Hive.openBox<CheckIn>(checkInsBox);
    await box.add(checkIn);
  }

  Future<List<CheckIn>> getCheckIns() async {
    final box = await Hive.openBox<CheckIn>(checkInsBox);
    return box.values.toList();
  }

  // BugStages
  Future<void> insertBugStage(BugStage bugStage) async {
    final box = await Hive.openBox<BugStage>(bugStagesBox);
    await box.add(bugStage);
  }

  Future<List<BugStage>> getBugStages() async {
    final box = await Hive.openBox<BugStage>(bugStagesBox);
    return box.values.toList();
  }

  // ForestProgress
  Future<void> insertForestProgress(ForestProgress progress) async {
    final box = await Hive.openBox<ForestProgress>(forestProgressBox);
    await box.add(progress);
  }

  Future<List<ForestProgress>> getForestProgress() async {
    final box = await Hive.openBox<ForestProgress>(forestProgressBox);
    return box.values.toList();
  }

  // Update Goal
  Future<void> updateGoal(int key, Goal goal) async {
    final box = await Hive.openBox<Goal>(goalsBox);
    await box.put(key, goal);
  }

  Future<void> deleteGoal(int key) async {
    final box = await Hive.openBox<Goal>(goalsBox);
    await box.delete(key);
  }

  // Delete CheckIn
  Future<void> deleteCheckIn(int key) async {
    final box = await Hive.openBox<CheckIn>(checkInsBox);
    await box.delete(key);
  }

  // Get Latest BugStage
  Future<BugStage?> getLatestBugStage() async {
    final box = await Hive.openBox<BugStage>(bugStagesBox);
    if (box.isEmpty) return null;
    // Assuming BugStage has a DateTime field called updatedAt
    final bugStages = box.values.toList();
    bugStages.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return bugStages.first;
  }
}
