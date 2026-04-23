import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/pet.dart';

class PetProvider extends ChangeNotifier {
  List<Pet> _pets = [];
  final Box<Pet> _petBox = Hive.box<Pet>('pets');

  PetProvider() {
    _loadPets();
  }

  List<Pet> get pets => _pets;

  void _loadPets() {
    _pets = _petBox.values.toList();
    notifyListeners();
  }

  Future<void> addPet(Pet pet) async {
    await _petBox.put(pet.id, pet);
    _loadPets();
  }

  Future<void> removePet(String id) async {
    await _petBox.delete(id);
    _loadPets();
  }
}
