import 'package:flutter/material.dart';


class GardenTransitionScreen extends StatefulWidget {
  const GardenTransitionScreen({super.key});

  @override
  State<GardenTransitionScreen> createState() => _GardenTransitionScreenState();
}

class _GardenTransitionScreenState extends State<GardenTransitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On the Path'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/train/trainWindow.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Colors.white.withOpacity(0.7),
                  child: const Text(
                    "You can't help but notice the garden.",
                    style: TextStyle(fontSize: 22, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forest');
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Keep Going'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
