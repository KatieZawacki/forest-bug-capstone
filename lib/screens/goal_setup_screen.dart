import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/goal.dart';
import '../providers/storage_providers.dart';

class GoalSetupScreen extends ConsumerStatefulWidget {
  const GoalSetupScreen({super.key});

  @override
  ConsumerState<GoalSetupScreen> createState() => _GoalSetupScreenState();
}

class _GoalSetupScreenState extends ConsumerState<GoalSetupScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _frequency = 'daily'; // daily, weekly, monthly
  int _durationDays = 30;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitGoal() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final goal = Goal(
      title: _titleController.text,
      description: '${_descriptionController.text} ($_frequency, $_durationDays days)',
      createdAt: DateTime.now(),
    );

    final db = ref.read(databaseProvider);
    await db.insertGoal(goal);

    final _ = ref.refresh(goalsProvider);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal created successfully!')),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Goal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goal Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g., Read 30 minutes daily',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Why is this goal important?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Frequency',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _frequency,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _frequency = value);
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Duration (Days)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _durationDays.toDouble(),
              min: 7,
              max: 365,
              divisions: 35,
              label: '$_durationDays days',
              onChanged: (value) {
                setState(() => _durationDays = value.toInt());
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitGoal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Create Goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
