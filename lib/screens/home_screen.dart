import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/storage_providers.dart';
import '../models/goal.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);
    final bugStageAsync = ref.watch(bugStageProvider);
    final forestProgressAsync = ref.watch(forestProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forest Bug'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final box = await Hive.openBox<Goal>('goals');
                    await box.clear();
                    ref.invalidate(goalsProvider);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All goals reset!')),
                    );
                  },
                  child: const Text('Reset Goals (Debug Only)'),
                ),
              ),
            // Pets Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pets');
                    },
                    icon: const Icon(Icons.pets),
                    label: const Text('View Pets'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Active Goal Section
            const Text(
              'Active Goal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            goalsAsync.when(
              data: (goals) {
                if (goals.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'No goals yet. What is something you would like to achieve?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  );
                }
                // Show up to 3 active goals
                final activeGoals = goals.take(3).toList();
                return Column(
                  children: [
                    for (final activeGoal in activeGoals)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeGoal.title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(activeGoal.description),
                              const SizedBox(height: 12),
                              Checkbox(
                                value: activeGoal.isCompleted,
                                onChanged: (value) async {
                                  if (value == null) return;
                                  final db = ref.read(databaseProvider);
                                  final updatedGoal = Goal(
                                    id: activeGoal.id,
                                    title: activeGoal.title,
                                    description: activeGoal.description,
                                    isCompleted: value,
                                    createdAt: activeGoal.createdAt,
                                    durationDays: activeGoal.durationDays,
                                  );
                                  await db.updateGoal(activeGoal.key as int, updatedGoal);
                                  // ignore: unused_result
                                  ref.refresh(goalsProvider);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),

            // Bug Growth Section
            const Text(
              'Bug Growth',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            bugStageAsync.when(
              data: (bugStage) {
                final stage = bugStage?.stage ?? 'Egg 🥚';
                final progress = bugStage?.progressPoints ?? 0;
                Widget? eggProgressWidget;
                if (stage.contains('Egg')) {
                  // Show up to 3 eggs, one per goal
                  final goals = goalsAsync.value ?? [];
                  final eggCount = goals.length.clamp(0, 3);
                  // Each egg hatches at 50 points
                  final hatchedEggs = ((progress / 50).floor()).clamp(0, eggCount);
                  eggProgressWidget = Column(
                    children: [
                      Text(
                        'Eggs: $eggCount',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          eggCount,
                          (i) => Text(
                            i < hatchedEggs ? '🐣' : '🥚',
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (eggProgressWidget != null) ...[
                          eggProgressWidget,
                        ],
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (progress % 100) / 100,
                            minHeight: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text('Progress: $progress points'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),

            // Forest Progress Section
            const Text(
              'Forest Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            forestProgressAsync.when(
              data: (forestProgress) {
                final bloomed = forestProgress?.bloomedTrees ?? 0;
                final total = forestProgress?.totalTrees ?? 8;
                // Show 8 trees, bloomed = green, unbloomed = gray
                final treeRow = List.generate(
                  total,
                  (i) => Text(
                    i < bloomed ? '🌳' : '🌲',
                    style: const TextStyle(fontSize: 32),
                  ),
                );
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: treeRow,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Bloomed: $bloomed / $total',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: total == 0 ? 0 : bloomed / total,
                            minHeight: 12,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (forestProgress != null)
                          Center(
                            child: Text(
                              'Cycle resets: ${forestProgress.lastResetDate.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: goalsAsync.value != null && goalsAsync.value!.length >= 3
                        ? null
                        : () {
                            Navigator.pushNamed(context, '/goal-setup');
                          },
                    icon: const Icon(Icons.add),
                    label: const Text('New Goal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/check-in');
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Check-In'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cottage');
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Go to Cottage'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
