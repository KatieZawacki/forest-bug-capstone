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
    // Example: 8 dirt pile positions
    // Estimated positions for each dirt pile (left, bottom)
    // Use relative positions (percentages of width and height)
    final List<Offset> dirtPileRelativePositions = [
      const Offset(0.08, 0.44), // far left
      const Offset(0.22, 0.75),
      const Offset(0.36, 0.44),
      const Offset(0.48, 0.75),
      const Offset(0.61, 0.44),
      const Offset(0.72, 0.75),
      const Offset(0.84, 0.44),
      const Offset(0.92, 0.75), // far right, moved down and right
    ];

    // Example: List of flower image paths for each pile (null = no flower)
    final List<String?> flowerImages = [
      'assets/images/FLOWER 1.png',
      'assets/images/FLOWER 2.png',
      'assets/images/FLOWER 3.png',
      'assets/images/FLOWER 4.png',
      'assets/images/FLOWER 5.png',
      'assets/images/FLOWER 6.png',
      'assets/images/FLOWER 7.png',
      'assets/images/FLOWER 8.png',
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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

          // 8 dirt pile flower spots
          ...List.generate(dirtPileRelativePositions.length, (i) {
            if (flowerImages[i] == null) return const SizedBox.shrink();
            final rel = dirtPileRelativePositions[i];
            return Positioned(
              left: rel.dx * screenWidth - 150, // center the flower
              bottom: rel.dy * screenHeight - 150, // center the flower
              child: Image.asset(
                flowerImages[i]!,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            );
          }),

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

          // Main content (moved to 10% from the bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: screenHeight * 0.10,
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
                const SizedBox(height: 24),
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
