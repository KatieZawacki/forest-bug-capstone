import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/pet.dart';

class PetProvider extends ChangeNotifier {
  List<Pet> _pets = [];
  final Box<Pet> _petBox = Hive.box<Pet>('pets');

  PetProvider() {
    debugPrint('PetProvider: constructor called');
    _loadPets();
  }

  List<Pet> get pets => _pets;

  void _loadPets() {
    debugPrint('PetProvider: _loadPets called');
    _pets = _petBox.values.toList();
    debugPrint('PetProvider: loaded pets length = \\${_pets.length}');
    notifyListeners();
  }

  Future<void> addPet(Pet pet) async {
    debugPrint('PetProvider: addPet called');
    await _petBox.put(pet.id, pet);
    _loadPets();
  }

  Future<void> removePet(String id) async {
    debugPrint('PetProvider: removePet called');
    await _petBox.delete(id);
    _loadPets();
  }
}
