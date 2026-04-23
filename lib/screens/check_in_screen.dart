import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/check_in.dart';
import '../providers/storage_providers.dart';
import '../services/bug_growth_service.dart';
import '../services/forest_growth_service.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  late TextEditingController _notesController;
  bool _completedToday = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitCheckIn() async {
    if (_notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a note')),
      );
      return;
    }

    final checkIn = CheckIn(
      notes: _notesController.text,
      timestamp: DateTime.now(),
    );

    final db = ref.read(databaseProvider);
    await db.insertCheckIn(checkIn);

    // Update bug stage
    int pointsToAdd = _completedToday ? 25 : 10; // More points if goal completed
    await BugGrowthService.updateBugStage(db, pointsToAdd: pointsToAdd);

    // Update forest progress
    await ForestGrowthService.updateForestProgress(db);

    // ignore: unused_result
    ref.refresh(checkInsProvider);
    // ignore: unused_result
    ref.refresh(bugStageProvider);
    // ignore: unused_result
    ref.refresh(forestProgressProvider);

    if (!mounted) return;

    // Show encouraging message
    String message = _getEncouragingMessage();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  String _getEncouragingMessage() {
    final messages = [
      'Amazing! You\'re growing your forest! 🌱',
      'Great progress! Your bug is evolving! 🦋',
      'You\'re on fire today! Keep it up! 🔥',
      'One step closer to your goal! 💪',
      'Fantastic work! Your discipline is inspiring! ✨',
      'You\'re building a beautiful forest! 🌲',
    ];
    final randomIndex = DateTime.now().millisecond % messages.length;
    return messages[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-In'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How did you do today?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Did you complete your goal?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Yes, I completed my goal!'),
              value: _completedToday,
              onChanged: (value) {
                setState(() => _completedToday = value ?? false);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'How did it feel? Any challenges or wins?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitCheckIn,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text('Submit Check-In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
