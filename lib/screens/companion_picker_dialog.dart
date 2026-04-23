import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import 'dart:math';

class CompanionPickerDialog extends StatelessWidget {
  final List<Map<String, String>> companions = [
    {
      'type': 'Cat',
      'name': 'Katy Cat',
      'image': 'assets/images/KATY CAT SIT.png',
    },
  ];

  CompanionPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick your companion'),
      content: SizedBox(
        width: 300,
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          children: companions.map((companion) {
            return Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  final pet = Pet(
                    id: Random().nextInt(1000000).toString(),
                    name: companion['name']!,
                    type: companion['type']!,
                    level: 1,
                    imagePath: companion['image']!,
                  );
                  await context.read<PetProvider>().addPet(pet);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Column(
                  children: [
                    Image.asset(
                      companion['image']!,
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 80),
                    ),
                    const SizedBox(height: 8),
                    Text(companion['name']!),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
