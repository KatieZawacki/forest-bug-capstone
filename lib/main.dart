import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/pet.dart';
import 'models/goal.dart';
import 'screens/home_screen.dart';
import 'screens/goal_setup_screen.dart';
import 'screens/check_in_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/cottage_screen.dart';
// import 'screens/garden_screen.dart';
import 'screens/forest_screen.dart';
import 'screens/garden_transition_screen.dart';
import 'screens/pet_list_screen_route.dart';
import 'screens/cottage_wall_screen.dart';
import 'package:provider/provider.dart';
import 'providers/pet_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // --- BEGIN: CLEAR ALL HIVE BOXES (REMOVE AFTER FIRST RUN) ---
  final boxNamesToDelete = [
    'goals',
    'checkIns',
    'bugStages',
    'forestProgress',
    'butterflyUnlocks',
    'pets',
    // add any other box names you use
  ];
  for (var boxName in boxNamesToDelete) {
    try {
      await Hive.deleteBoxFromDisk(boxName);
    } catch (e) {
      // Ignore errors if box doesn't exist
    }
  }
  // --- END: CLEAR ALL HIVE BOXES ---
  Hive.registerAdapter(PetAdapter());
  Hive.registerAdapter(GoalAdapter());

  // Minimal Hive Goal test
  var goalBox = await Hive.openBox<Goal>('goals');
  await goalBox.clear();
  await goalBox.add(Goal(
    title: 'Test',
    description: 'Test',
    createdAt: DateTime.now(),
    durationDays: 1,
  ));
  print('Goal added!');

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
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white, // Text and icon color
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/goal-setup': (context) => const GoalSetupScreen(),
        '/check-in': (context) => const CheckInScreen(),
        '/cottage': (context) => const CottageScreen(),
        '/cottage-wall': (context) => const CottageWallScreen(),
        // '/garden': (context) => const GardenScreen(),
        '/forest': (context) => const ForestScreen(),
        '/garden-transition': (context) => const GardenTransitionScreen(),
        '/pets': (context) => const PetListScreenRoute(),
      },
    );
  }
}
