import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetListScreen extends StatelessWidget {
  final List<Pet> pets;

  const PetListScreen({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Pets')),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return ListTile(
            leading: Image.asset(pet.imagePath, width: 40, height: 40),
            title: Text(pet.name),
            subtitle: Text('Type: \'${pet.type}\', Level: \'${pet.level}\''),
          );
        },
      ),
    );
  }
}
