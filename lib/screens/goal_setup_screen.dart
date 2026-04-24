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
  late TextEditingController _whyController;
  int _durationDays = 1;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _whyController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _whyController.dispose();
    super.dispose();
  }

  void _submitGoal() async {
    if (_titleController.text.isEmpty || _whyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final goal = Goal(
      title: _titleController.text,
      description: 'Why: ${_whyController.text}\nDuration: $_durationDays days',
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/make a goal.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SizedBox.expand(
                child: Column(
                  children: [
                    const Spacer(flex: 8),
                    SingleChildScrollView(
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
                            'Why would this goal be important for you to complete?',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _whyController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Explain your motivation...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Duration',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<int>(
                            value: _durationDays,
                            isExpanded: true,
                            items: [
                              for (final days in [1, 2, 3, 4, 5, 6, 7, 14, 21, 28, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 365])
                                DropdownMenuItem(
                                  value: days,
                                  child: Text(_durationLabel(days)),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _durationDays = value);
                              }
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
                    // No bottom spacer
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

  String _durationLabel(int days) {
    if (days == 1) return '1 day';
    if (days < 7) return '$days days';
    if (days == 7) return '1 week';
    if (days % 7 == 0 && days < 28) return '${days ~/ 7} weeks';
    if (days == 28) return '4 weeks (about 1 month)';
    if (days == 30) return '1 month';
    if (days == 60) return '2 months';
    if (days == 90) return '3 months';
    if (days == 120) return '4 months';
    if (days == 150) return '5 months';
    if (days == 180) return '6 months';
    if (days == 210) return '7 months';
    if (days == 240) return '8 months';
    if (days == 270) return '9 months';
    if (days == 300) return '10 months';
    if (days == 330) return '11 months';
    if (days == 365) return '12 months (1 year)';
    return '$days days';
  }
}
