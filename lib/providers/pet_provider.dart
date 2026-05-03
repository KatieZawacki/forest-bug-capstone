import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetProvider extends ChangeNotifier {
  List<Pet> _pets = [];
  final Box<Pet> _petBox = Hive.box<Pet>('pets');
  String? _activePetId;

  PetProvider() {
    debugPrint('PetProvider: constructor called');
    _loadPets();
    _loadActivePetId();
  }

  List<Pet> get pets => _pets;
  String? get activePetId => _activePetId;
  Pet? get activePet {
    try {
      return _pets.firstWhere((p) => p.id == _activePetId);
    } catch (_) {
      return _pets.isNotEmpty ? _pets.first : null;
    }
  }

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
    if (_activePetId == id) {
      await setActivePet(_pets.isNotEmpty ? _pets.first.id : null);
    }
  }

  Future<void> _loadActivePetId() async {
    final prefs = await SharedPreferences.getInstance();
    _activePetId = prefs.getString('activePetId');
    notifyListeners();
  }

  Future<void> setActivePet(String? petId) async {
    final prefs = await SharedPreferences.getInstance();
    _activePetId = petId;
    if (petId != null) {
      await prefs.setString('activePetId', petId);
    } else {
      await prefs.remove('activePetId');
    }
    notifyListeners();
  }

  Future<void> incrementActivePetLevelPoint() async {
    final pet = activePet;
    if (pet != null) {
      pet.levelPoints += 1;
      if (pet.levelPoints >= 30) {
        pet.level += 1;
        pet.levelPoints = 0;
      }
      await pet.save();
      _loadPets();
    }
  }

  Future<void> resetActivePet() async {
    final pet = activePet;
    if (pet != null) {
      pet.level = 1;
      pet.levelPoints = 0;
      pet.friendship = 0;
      await pet.save();
      _loadPets();
    }
  }
}
