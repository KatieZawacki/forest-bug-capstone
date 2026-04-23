import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../providers/pet_provider.dart';
import 'companion_picker_dialog.dart';

class CottageScreen extends StatefulWidget {
  const CottageScreen({super.key});

  @override
  State<CottageScreen> createState() => _CottageScreenState();
}

class _CottageScreenState extends State<CottageScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('CottageScreen: initState called');
    _checkPickedCompanion();
  }

  Future<void> _checkPickedCompanion() async {
    debugPrint('CottageScreen: _checkPickedCompanion called');
    final prefs = await SharedPreferences.getInstance();
    final picked = prefs.getBool('picked_companion') ?? false;
    debugPrint('CottageScreen: picked_companion = \\$picked');
    if (!picked && mounted) {
      await Future.delayed(Duration.zero); // Ensure context is ready
      debugPrint('CottageScreen: showing CompanionPickerDialog');
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CompanionPickerDialog(),
      );
      debugPrint('CottageScreen: dialog closed');
      await prefs.setBool('picked_companion', true);
      if (mounted) setState(() {});
    }
  }

  Future<void> _resetPetSelection() async {
    debugPrint('CottageScreen: _resetPetSelection called');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('picked_companion');
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final pets = List.of(petProvider.pets);
    for (final pet in pets) {
      await petProvider.removePet(pet.id);
    }
    setState(() {});
    // Show the companion picker dialog after reset
    if (mounted) {
      debugPrint('CottageScreen: showing CompanionPickerDialog (reset)');
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CompanionPickerDialog(),
      );
      debugPrint('CottageScreen: dialog closed (reset)');
      await prefs.setBool('picked_companion', true);
    }
  }

  // List of possible states and their corresponding images for each pet type
  final Map<String, Map<String, String>> petStateImages = {
    'Cat 1': {
      'sit': 'assets/images/CAT 1.png',
      'stage1': 'assets/images/CAT 1 STAGE 1.png',
      'stage2': 'assets/images/CAT 1 STAGE 2.png',
    },
    'Cat 2': {'sit': 'assets/images/CAT 2.png'},
    // Add more pets here
  };

  // 45% chance to change pet state when leaving cottage
  void _maybeRandomizePetState() {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    if (petProvider.pets.isNotEmpty) {
      final pet = petProvider.pets.first;
      final states = petStateImages[pet.name]?.keys.toList();
      if (states != null && states.isNotEmpty) {
        final rand = (DateTime.now().microsecondsSinceEpoch % 100) / 100.0;
        if (rand < 0.45) {
          states.shuffle();
          final newState = states.first;
          if (pet.state != newState) {
            pet.state = newState;
            pet.save();
          }
        }
      }
    }
  }

  // Ensure state change triggers on pop (go back)
  @override
  void deactivate() {
    if (!mounted) {
      // Only randomize if widget is being removed from the tree (i.e., user navigates away)
      _maybeRandomizePetState();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('CottageScreen: build START');
    final petProvider = Provider.of<PetProvider>(context);
    debugPrint('CottageScreen: got petProvider, pets length = \\${petProvider.pets.length}');
    final pet = petProvider.pets.isNotEmpty ? petProvider.pets.first : null;
    debugPrint('CottageScreen: build END');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cottage'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/COTTAGE FLOOR 1.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
            ),
          ),
          // Main content column (centered)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
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
                    const SizedBox(width: 20),
                    // Debug button to reset pet selection
                    ElevatedButton(
                      onPressed: _resetPetSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reset Pet Selection'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bed and pet in bottom right
          Positioned(
            right: 32,
            bottom: 32,
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/PET BED 1.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.bed, size: 100),
                  ),
                  if (pet != null)
                    Builder(
                      builder: (context) {
                        // Pick image and position based on state
                        final state = pet.state;
                        final image =
                            petStateImages[pet.name]?[state] ?? pet.imagePath;
                        Alignment alignment = Alignment.center;
                        Offset offset = Offset(0, -55); // Default for "sit"
                        if (state == 'stage1') {
                          alignment = Alignment.centerLeft;
                          offset = Offset(-60, 0); // Left side (stage1)
                        } else if (state == 'stage2') {
                          alignment = Alignment.topCenter;
                          offset = Offset(0, 30); // Upper center (stage2)
                        }
                        return Positioned.fill(
                          child: Align(
                            alignment: alignment,
                            child: Transform.translate(
                              offset: offset,
                              child: Image.asset(
                                image,
                                width: 300,
                                height: 300,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 100),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
