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
      'state': 'sit',
    },
    {
      'type': 'Cat',
      'name': 'Katy Cat',
      'image': 'assets/images/KATY CAT LAY.png',
      'state': 'lay',
    },
    {
      'type': 'Cat',
      'name': 'Katy Cat',
      'image': 'assets/images/KATY CAT STAND.png',
      'state': 'stand',
    },
  ];

  CompanionPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick your companion'),
      content: SizedBox(
        width: 350,
        height: 350,
        child: Center(
          child: GestureDetector(
            onTap: () async {
              // For demo, pick the first state (sit)
              final companion = companions[0];
              final pet = Pet(
                id: Random().nextInt(1000000).toString(),
                name: companion['name']!,
                type: companion['type']!,
                level: 1,
                imagePath: companion['image']!,
                state: companion['state']!,
              );
              await context.read<PetProvider>().addPet(pet);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Image.asset(
              companions[0]['image']!,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 300),
            ),
          ),
        ),
      ),
    );
  }
}
