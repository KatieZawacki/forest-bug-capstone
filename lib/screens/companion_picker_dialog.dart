import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import 'dart:math';

class CompanionPickerDialog extends StatefulWidget {
  const CompanionPickerDialog({super.key});

  @override
  State<CompanionPickerDialog> createState() => _CompanionPickerDialogState();
}

class _CompanionPickerDialogState extends State<CompanionPickerDialog> {
  String? selectedType;

  final List<Map<String, String>> companions = [
    {
      'type': 'Dog',
      'name': 'Dog 1',
      'image': 'assets/images/DOG 1.png',
      'state': 'sit',
    },
    {
      'type': 'Dog',
      'name': 'Dog 2',
      'image': 'assets/images/DOG 2.png',
      'state': 'sit',
    },
    {
      'type': 'Dog',
      'name': 'Dog 3',
      'image': 'assets/images/DOG 3.png',
      'state': 'sit',
    },
    {
      'type': 'Dog',
      'name': 'Dog 4',
      'image': 'assets/images/DOG 4.png',
      'state': 'sit',
    },
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
    {
      'type': 'Cat',
      'name': 'Cat 3',
      'image': 'assets/images/CAT 3.png',
      'state': 'sit',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(selectedType == null ? 'Pick a companion type' : 'Pick your companion'),
      content: SizedBox(
        width: 1000,
        height: 400,
        child: selectedType == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => selectedType = 'Dog'),
                    child: const Text('Dog', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: 60),
                  ElevatedButton(
                    onPressed: () => setState(() => selectedType = 'Cat'),
                    child: const Text('Cat', style: TextStyle(fontSize: 32)),
                  ),
                ],
              )
            : ListView(
                scrollDirection: Axis.horizontal,
                children: companions
                    .where((c) => c['type'] == selectedType)
                    .map((companion) {
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
                            debugPrint('CompanionPickerDialog: Pet added, popping dialog');
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              companion['image']!,
                              width: 300,
                              height: 300,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 100),
                            ),
                          ),
                        ),
                        // Removed companion name label
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
      actions: selectedType != null
          ? [
              TextButton(
                onPressed: () => setState(() => selectedType = null),
                child: const Text('Back'),
              ),
            ]
          : null,
    );
  }
}
