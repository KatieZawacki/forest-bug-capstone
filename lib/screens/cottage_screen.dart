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
    Future<void> _resetPetSelection() async {
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
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CompanionPickerDialog(),
        );
        await prefs.setBool('picked_companion', true);
      }
    }




    // List of possible states and their corresponding images for each pet type
    final Map<String, Map<String, String>> petStateImages = {
      // Example for Katy Cat
      'Katy Cat': {
        'sit': 'assets/images/KATY CAT SIT.png',
        'lay': 'assets/images/KATY CAT LAY.png',
        'stand': 'assets/images/KATY CAT STAND.png',
      },
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
    final petProvider = Provider.of<PetProvider>(context);
    final pet = petProvider.pets.isNotEmpty ? petProvider.pets.first : null;
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
                      child: const Text('Reset Pet Selection'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
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
                  ),
                  if (pet != null)
                    Builder(
                      builder: (context) {
                        // Pick image and position based on state
                        final state = pet.state;
                        final image = petStateImages[pet.name]?[state] ?? pet.imagePath;
                        Alignment alignment = Alignment.center;
                        Offset offset = Offset(0, -55); // Default for "sit"
                        if (state == 'lay') {
                          alignment = Alignment.centerLeft;
                          offset = Offset(-60, 0); // Left side
                        } else if (state == 'stand') {
                          alignment = Alignment.topCenter;
                          offset = Offset(0, 30); // Upper center
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
