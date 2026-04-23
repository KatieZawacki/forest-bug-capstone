import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/pet.dart';
import 'screens/home_screen.dart';
import 'screens/goal_setup_screen.dart';
import 'screens/check_in_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/cottage_screen.dart';
// import 'screens/garden_screen.dart';
import 'screens/forest_screen.dart';
import 'screens/garden_transition_screen.dart';
import 'screens/pet_list_screen_route.dart';
import 'package:provider/provider.dart';
import 'providers/pet_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());
  await Hive.openBox<Pet>('pets');
  runApp(
    ChangeNotifierProvider(
      create: (_) => PetProvider(),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forest Bug',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/goal-setup': (context) => const GoalSetupScreen(),
        '/check-in': (context) => const CheckInScreen(),
        '/cottage': (context) => const CottageScreen(),
        // '/garden': (context) => const GardenScreen(),
        '/forest': (context) => const ForestScreen(),
        '/garden-transition': (context) => const GardenTransitionScreen(),
        '/pets': (context) => const PetListScreenRoute(),
      },
    );
  }
}
