import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import 'pet_list_screen.dart';

class PetListScreenRoute extends StatelessWidget {
  const PetListScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final pets = context.watch<PetProvider>().pets;
    return PetListScreen(pets: pets);
  }
}
