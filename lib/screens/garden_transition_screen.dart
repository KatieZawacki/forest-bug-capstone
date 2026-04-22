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
          // FLOWER 3 (bottom far left)
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 3.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // FLOWER 4
          Positioned(
            left: 110,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 4.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // FLOWER 5
          Positioned(
            left: 220,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 5.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // FLOWER 6
          Positioned(
            left: 330,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 6.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // FLOWER 7
          Positioned(
            left: 440,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 7.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // FLOWER 8
          Positioned(
            left: 550,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 8.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // FLOWER 9
          Positioned(
            left: 660,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 9.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // FLOWER 11
          Positioned(
            left: 770,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 11.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // FLOWER 12 (far right)
          Positioned(
            left: 880,
            bottom: 0,
            child: Image.asset(
              'assets/images/FLOWER 12.png',
              width: 180,
              height: 180,
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
                backgroundColor: Colors.black.withAlpha((0.7 * 255).toInt()),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          // FLOWER 2 (moved further down)
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 150,
            bottom: 10,
            child: Image.asset(
              'assets/images/FLOWER 2.png',
              width: 300,
              height: 300,
            ),
          ),
          // Main content (moved to top of stack)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  color: Colors.white.withAlpha((0.7 * 255).toInt()),
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
          // PURPLE FLOWER (bottom center-right)
          Positioned(
            left: MediaQuery.of(context).size.width / 2 + 60,
            bottom: 40,
            child: Image.asset(
              'assets/images/PURPLE FLOWER.png',
              width: 300,
              height: 300,
            ),
          ),
          // PINK FLOWER (bottom left)
          Positioned(
            left: 40,
            bottom: 40,
            child: Image.asset(
              'assets/images/PINK FLOWER.png',
              width: 300,
              height: 300,
            ),
          ),
          // FLOWER (bottom right)
          Positioned(
            right: 40,
            bottom: 40,
            child: Image.asset(
              'assets/images/FLOWER.png',
              width: 300,
              height: 300,
            ),
          ),
          // YELLOW FLOWER (moved slightly to the right)
          Positioned(
            left: 180,
            top: 340,
            child: Image.asset(
              'assets/images/YELLOW FLOWER.png',
              width: 300,
              height: 300,
            ),
          ),
        ],
      ),
    );
  }
}
