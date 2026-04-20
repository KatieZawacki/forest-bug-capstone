import '../models/forest_progress.dart';
import 'database_helper.dart';

class ForestGrowthService {
  static const int checkInsPerTree = 5; // 1 tree per 5 check-ins

  static Future<void> updateForestProgress(
    DatabaseHelper db,
  ) async {
    var forestProgress = await db.getForestProgress();

    if (forestProgress == null) {
      // Initialize forest
      forestProgress = ForestProgress(
        totalTrees: 10,
        treesCultivated: 0,
        lastUpdated: DateTime.now(),
      );
      await db.insertForestProgress(forestProgress);
      return;
    }

    // Calculate trees based on check-ins
    final checkIns = await db.getCheckIns();
    int newCultivated = (checkIns.length / checkInsPerTree).floor();
    newCultivated = newCultivated.clamp(0, forestProgress.totalTrees);

    if (newCultivated > forestProgress.treesCultivated) {
      final updatedProgress = ForestProgress(
        id: forestProgress.id,
        totalTrees: forestProgress.totalTrees,
        treesCultivated: newCultivated,
        lastUpdated: DateTime.now(),
      );

      await db.updateForestProgress(updatedProgress);
    }
  }
}
