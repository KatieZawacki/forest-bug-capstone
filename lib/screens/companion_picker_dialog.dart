import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import 'dart:math';

class CompanionPickerDialog extends StatelessWidget {
  final List<Map<String, String>> companions = [
    {
      'type': 'Cat',
      'name': 'Cat 1',
      'image': 'assets/images/CAT 1.png',
      'state': 'sit',
    },
    {
      'type': 'Cat',
      'name': 'Cat 2',
      'image': 'assets/images/CAT 2.png',
      'state': 'sit',
    },
  ];

  CompanionPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick your companion'),
      content: SizedBox(
        width: 400,
        height: 350,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: companions.map((companion) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      debugPrint(
                        'CompanionPickerDialog: Companion tapped: \\${companion['name']} \\${companion['state']}',
                      );
                      final pet = Pet(
                        id: Random().nextInt(1000000).toString(),
                        name: companion['name']!,
                        type: companion['type']!,
                        level: 1,
                        imagePath: companion['image']!,
                        state: companion['state']!,
                      );
                      await context.read<PetProvider>().addPet(pet);
                      debugPrint(
                        'CompanionPickerDialog: Pet added, popping dialog',
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        companion['image']!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.pets, size: 100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    companion['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Removed state label
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
