import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'companion_picker_dialog.dart';
import '../providers/pet_provider.dart';

class CottageScreen extends StatefulWidget {
  const CottageScreen({super.key});

  @override
  State<CottageScreen> createState() => _CottageScreenState();
}

class _CottageScreenState extends State<CottageScreen> {
  bool _checkedFirstVisit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showCompanionPickerIfFirstVisit();
  }

  Future<void> _showCompanionPickerIfFirstVisit() async {
    if (_checkedFirstVisit) return;
    _checkedFirstVisit = true;
    final prefs = await SharedPreferences.getInstance();
    final picked = prefs.getBool('picked_companion') ?? false;
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    if (!picked && petProvider.pets.isEmpty) {
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CompanionPickerDialog(),
      );
      await prefs.setBool('picked_companion', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cottage'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 120, color: Colors.brown[400]),
            const SizedBox(height: 32),
            const Text(
              'It already feels like home.',
              style: TextStyle(fontSize: 22, color: Colors.brown),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/goal-setup');
                  },
                  child: const Text('Make a Goal'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/garden-transition');
                  },
                  child: const Text('Explore the Forest'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
