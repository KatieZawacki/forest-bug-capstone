import '../models/bug_stage.dart';
import 'database_helper.dart';

class BugGrowthService {
  static const int pointsPerCheckIn = 10;
  static const int pointsPerGoalCompletion = 25;

  static Future<void> updateBugStage(
    DatabaseHelper db, {
    required int pointsToAdd,
  }) async {
    var bugStage = await db.getLatestBugStage();

    bugStage ??= BugStage(
        stage: 'Caterpillar 🐛',
        progressPoints: 0,
        updatedAt: DateTime.now(),
      );

    // Add points
    int newPoints = bugStage.progressPoints + pointsToAdd;
    String newStage = _getStageByPoints(newPoints);

    final updatedBugStage = BugStage(
      id: bugStage.id,
      stage: newStage,
      progressPoints: newPoints,
      updatedAt: DateTime.now(),
    );

    if (bugStage.id == null) {
      await db.insertBugStage(updatedBugStage);
    } else {
      await db.updateBugStage(updatedBugStage);
    }
  }

  static String _getStageByPoints(int points) {
    if (points < 50) {
      return 'Egg 🥚';
    } else if (points < 100) {
      return 'Caterpillar 🐛';
    } else if (points < 200) {
      return 'Cocoon 🤎';
    } else {
      return 'Butterfly 🦋';
    }
  }
}
