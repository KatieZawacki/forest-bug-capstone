import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/goal_setup_screen.dart';
import 'screens/check_in_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/cottage_screen.dart';
// import 'screens/garden_screen.dart';
import 'screens/forest_screen.dart';
import 'screens/garden_transition_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
      },
    );
  }
}
