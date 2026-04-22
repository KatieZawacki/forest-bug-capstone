import 'package:flutter/material.dart';

class GardenTransitionScreen extends StatefulWidget {
  const GardenTransitionScreen({super.key});

  @override
  State<GardenTransitionScreen> createState() => _GardenTransitionScreenState();
}

class _GardenTransitionScreenState extends State<GardenTransitionScreen> {
  // ...existing code...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On the Path'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Garden background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/garden background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Go Back button (bottom left)
          Positioned(
            left: 16,
            bottom: 16,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.7),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          // TWO FLOWERS (top left)
          Positioned(
            left: 40,
            top: 40,
            child: Image.asset(
              'assets/images/TWO FLOWERS.png',
              width: 100,
              height: 100,
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  color: Colors.white.withOpacity(0.7),
                  child: const Text(
                    "You can't help but notice the garden. It is filled with weeds, but you see the potential.",
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
          // Tulip sprite overlay (bottom center)
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 75,
            bottom: 40,
            child: Image.asset(
              'assets/images/TULIP.gif',
              width: 150,
              height: 150,
            ),
          ),
          // PINK FLOWER (bottom left)
          Positioned(
            left: 40,
            bottom: 40,
            child: Image.asset(
              'assets/images/PINK FLOWER.png',
              width: 100,
              height: 100,
            ),
          ),
          // FLOWER (bottom right)
          Positioned(
            right: 40,
            bottom: 40,
            child: Image.asset(
              'assets/images/FLOWER.png',
              width: 100,
              height: 100,
            ),
          ),
          // YELLOW FLOWER (top right)
          Positioned(
            right: 40,
            top: 40,
            child: Image.asset(
              'assets/images/YELLOW FLOWER.png',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
