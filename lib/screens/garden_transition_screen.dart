          // Butterfly 3 GIF (third dirt pile) - placed in Stack children
import 'package:flutter/material.dart';
import 'forest_screen.dart';

class GardenTransitionScreen extends StatefulWidget {
  const GardenTransitionScreen({super.key});

  @override
  State<GardenTransitionScreen> createState() => _GardenTransitionScreenState();
}

class _GardenTransitionScreenState extends State<GardenTransitionScreen> {
  // ...existing code...
  // Each pile can be: empty, sprout, or a flower image
  // We'll use a list of objects to track state for each pile
  // Example state: {"state": "empty"}, {"state": "sprout", "plantedAt": DateTime}, {"state": "flower", "plantedAt": DateTime, "image": "assets/images/FLOWER 1.png"}
  // On first use, each pile starts with a weed
  List<Map<String, dynamic>> dirtPiles = List.generate(8, (_) => {"state": "weed"});
    // Helper to update weeds for empty piles left for 2+ days
    void updateWeedsForEmptyPiles() {
      final now = DateTime.now();
      setState(() {
        for (int i = 0; i < dirtPiles.length; i++) {
          final pile = dirtPiles[i];
          if (pile["state"] == "empty" && pile["emptiedAt"] != null) {
            final emptiedAt = pile["emptiedAt"] as DateTime;
            if (now.difference(emptiedAt).inDays >= 2) {
              dirtPiles[i] = {"state": "weed"};
            }
          }
        }
      });
    }
  int seedCount = 0; // Number of seeds in inventory

  // Map flower image filename to rarity
  final Map<String, String> flowerImageRarity = {
    'assets/images/FLOWER 1.png': 'rare',
    'assets/images/FLOWER 2.png': 'rare',
    'assets/images/FLOWER 3.png': 'rare',
    'assets/images/FLOWER 4.png': 'ultra rare',
    'assets/images/FLOWER 5.png': 'rare',
    'assets/images/FLOWER 6.png': 'ultra rare',
    'assets/images/FLOWER 7.png': 'ultra rare',
    'assets/images/FLOWER 8.png': 'rare',
  };

  // All flower images
  final List<String> allFlowerImages = [
    'assets/images/FLOWER 1.png',
    'assets/images/FLOWER 2.png',
    'assets/images/FLOWER 3.png',
    'assets/images/FLOWER 4.png',
    'assets/images/FLOWER 5.png',
    'assets/images/FLOWER 6.png',
    'assets/images/FLOWER 7.png',
    'assets/images/FLOWER 8.png',
  ];

  // Helper to get flower images by rarity
  List<String> getImagesByRarity(String rarity) =>
      allFlowerImages.where((img) => flowerImageRarity[img] == rarity).toList();

  @override
  Widget build(BuildContext context) {
    final List<Offset> dirtPileRelativePositions = [
      const Offset(0.08, 0.44),
      const Offset(0.22, 0.75),
      const Offset(0.36, 0.44),
      const Offset(0.48, 0.75),
      const Offset(0.61, 0.44),
      const Offset(0.72, 0.75),
      const Offset(0.84, 0.44),
      const Offset(0.92, 0.75),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final now = DateTime.now();
    // Check for weeds on build
    updateWeedsForEmptyPiles();
    return Scaffold(
      appBar: AppBar(
        title: const Text('On the Path'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Seed inventory display (top right)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.spa, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('Seeds: $seedCount', style: const TextStyle(fontSize: 18, color: Colors.green)),
                ],
              ),
            ),
          ),
          // Garden background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/garden background.png',
              fit: BoxFit.cover,
            ),
          ),

          // 8 dirt pile flower spots
          ...List.generate(dirtPileRelativePositions.length, (i) {
            final rel = dirtPileRelativePositions[i];
            final pile = dirtPiles[i];
            Widget? overlayChild;
            // Weed state: show weed image, tap to clear
            if (pile["state"] == "weed") {
              return Positioned(
                left: rel.dx * screenWidth - 150,
                bottom: rel.dy * screenHeight - 150,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      dirtPiles[i] = {"state": "empty", "emptiedAt": DateTime.now()};
                    });
                  },
                  child: Image.asset(
                    'assets/images/WEED.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }
            // Empty state: show dirt pile, allow planting if user has seeds
            if (pile["state"] == "empty") {
              return Positioned(
                left: rel.dx * screenWidth - 60,
                bottom: rel.dy * screenHeight - 60,
                child: GestureDetector(
                  onTap: seedCount > 0
                      ? () {
                          final rand = (DateTime.now().millisecondsSinceEpoch + i) % 100;
                          String rarity;
                          if (rand < 60) {
                            rarity = 'common';
                          } else if (rand < 90) {
                            rarity = 'rare';
                          } else {
                            rarity = 'ultra rare';
                          }
                          final options = getImagesByRarity(rarity);
                          final image = options.isNotEmpty ? options[rand % options.length] : allFlowerImages[rand % allFlowerImages.length];
                          setState(() {
                            dirtPiles[i] = {
                              "state": "sprout",
                              "plantedAt": DateTime.now(),
                              "image": image
                            };
                            seedCount = seedCount - 1;
                          });
                        }
                      : null,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(BorderSide.none),
                    ),
                    child: seedCount > 0
                        ? const Center(child: Icon(Icons.spa, color: Colors.green, size: 40))
                        : null,
                  ),
                ),
              );
            }
            // Sprout state
            if (pile["state"] == "sprout") {
              final plantedAt = pile["plantedAt"] as DateTime;
              if (now.difference(plantedAt).inDays >= 1) {
                setState(() {
                  dirtPiles[i] = {
                    "state": "flower",
                    "plantedAt": plantedAt,
                    "image": pile["image"]
                  };
                });
                return const SizedBox.shrink();
              } else {
                overlayChild = Image.asset(
                  'assets/images/SPROUT.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                );
              }
            }
            // Flower state
            if (pile["state"] == "flower") {
              final plantedAt = pile["plantedAt"] as DateTime;
              if (now.difference(plantedAt).inDays >= 6) {
                setState(() {
                  dirtPiles[i] = {"state": "empty", "emptiedAt": DateTime.now()};
                });
                return const SizedBox.shrink();
              } else {
                overlayChild = Image.asset(
                  pile["image"],
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                );
              }
            }
            if (overlayChild == null) return const SizedBox.shrink();
            // If sprout, position it slightly higher than flower
            if (pile["state"] == "sprout") {
              return Positioned(
                left: rel.dx * screenWidth - 150,
                bottom: rel.dy * screenHeight - 80,
                child: overlayChild,
              );
            }
            return Positioned(
              left: rel.dx * screenWidth - 150,
              bottom: rel.dy * screenHeight - 150,
              child: overlayChild,
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
                  onPressed: () async {
                    // Go to forest screen and wait for result
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForestScreen(),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        seedCount = seedCount + 1;
                      });
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Keep Going'),
                ),
              ],
            ),
          ),
          // Butterfly GIF (top left) - moved to top layer
          // Butterfly GIF (moved to first dirt pile)
          Positioned(
            left: dirtPileRelativePositions[0].dx * screenWidth - 150,
            bottom: dirtPileRelativePositions[0].dy * screenHeight - 150,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/BUTTERFLY 1 GIF.gif',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Butterfly 2 GIF (second dirt pile)
          Positioned(
            left: dirtPileRelativePositions[1].dx * screenWidth - 150,
            bottom: dirtPileRelativePositions[1].dy * screenHeight - 150,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/BUTTERFLY 2 GIF.gif',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
              // Butterfly 3 GIF (third dirt pile, always shown on its pile)
              Positioned(
                left: dirtPileRelativePositions[2].dx * screenWidth - 150,
                bottom: dirtPileRelativePositions[2].dy * screenHeight - 150,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/BUTTERFLY 3 GIF.gif',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Butterfly 4 GIF (fourth dirt pile, not already occupied)
              Positioned(
                left: dirtPileRelativePositions[3].dx * screenWidth - 150,
                bottom: dirtPileRelativePositions[3].dy * screenHeight - 150,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/BUTTERFLY 4 GIF.gif',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Butterfly 5 GIF (fifth dirt pile, not already occupied)
              Positioned(
                left: dirtPileRelativePositions[4].dx * screenWidth - 150,
                bottom: dirtPileRelativePositions[4].dy * screenHeight - 150,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/BUTTERFLY 5 GIF.gif',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Butterfly 6 GIF (sixth dirt pile, not already occupied)
              Positioned(
                left: dirtPileRelativePositions[5].dx * screenWidth - 150,
                bottom: dirtPileRelativePositions[5].dy * screenHeight - 150,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/BUTTERFLY 6 GIF.gif',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Butterfly 7 GIF (seventh dirt pile, not already occupied)
              Positioned(
                left: dirtPileRelativePositions[6].dx * screenWidth - 150,
                bottom: dirtPileRelativePositions[6].dy * screenHeight - 150,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/BUTTERFLY 7 GIF.gif',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
