import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/storage_providers.dart';

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
                          'No goals yet. Create one to get started!',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  );
                }
                final activeGoal = goals.first;
                return Card(
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
                          onChanged: (value) {
                            // TODO: Mark goal as complete
                          },
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
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            stage,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
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
                final cultivated = forestProgress?.treesCultivated ?? 0;
                final total = forestProgress?.totalTrees ?? 10;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '🌲' * cultivated,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Trees: $cultivated / $total',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: cultivated / total,
                            minHeight: 12,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
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
                    onPressed: () {
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
