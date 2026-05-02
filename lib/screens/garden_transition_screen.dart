          // Butterfly 3 GIF (third dirt pile) - placed in Stack children
import 'package:flutter/material.dart';
import 'ticker.dart';
import 'dart:math' as math;
import '../models/goal.dart';
import '../services/database_helper.dart';

class GardenTransitionScreen extends StatefulWidget {
  const GardenTransitionScreen({super.key});

  @override
  State<GardenTransitionScreen> createState() => _GardenTransitionScreenState();
}

class _GardenTransitionScreenState extends State<GardenTransitionScreen> {
  // List of active goals
  List<Goal> _goals = [];
  bool _loadingGoals = true;
  final List<Offset> butterflyStagePositions = const [
    Offset(0.08, 0.18), // egg (left)
    Offset(0.5, 0.18),  // caterpillar (center)
    Offset(0.92, 0.18), // pupa (right)
  ];
  // Bee animation state
  late final List<Offset> _dirtPileRelativePositions;
  late final Ticker _beeTicker;
  // For figure 8 path
  double _beeFigure8T = 0.0;

  @override
  void initState() {
    super.initState();
    _dirtPileRelativePositions = [
      const Offset(0.08, 0.44),
      const Offset(0.22, 0.75),
      const Offset(0.36, 0.44),
      const Offset(0.48, 0.75),
      const Offset(0.61, 0.44),
      const Offset(0.72, 0.75),
      const Offset(0.84, 0.44),
      const Offset(0.92, 0.75),
    ];
    _beeTicker = Ticker(_onBeeTick)..start();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    debugPrint('GardenTransitionScreen: _loadGoals called');
    final db = DatabaseHelper();
    debugPrint('GardenTransitionScreen: calling db.getGoals()');
    try {
      // Add a timeout to catch hangs
      final goalsFuture = db.getGoals();
      final goals = await goalsFuture.timeout(const Duration(seconds: 5), onTimeout: () {
        debugPrint('GardenTransitionScreen: db.getGoals() timed out!');
        throw Exception('db.getGoals() timed out');
      });
      debugPrint('GardenTransitionScreen: db.getGoals() returned with \\${goals.length} goals');
      if (mounted) {
        setState(() {
          _goals = goals;
          _loadingGoals = false;
        });
        debugPrint('GardenTransitionScreen: setState called, _loadingGoals=false');
      }
    } catch (e, st) {
      debugPrint('GardenTransitionScreen: ERROR in _loadGoals: \\${e.toString()}');
      debugPrint('GardenTransitionScreen: STACKTRACE: \\${st.toString()}');
      if (mounted) {
        setState(() {
          _goals = [];
          _loadingGoals = false;
        });
      }
    }
  }

  void _onBeeTick(Duration elapsed) {
    if (!mounted) return;
    final double seconds = elapsed.inMilliseconds / 1000.0;
    final double period = 8.0;
    final double t = (seconds % period) / period * 2 * math.pi;
    setState(() {
      _beeFigure8T = t;
    });
  }

  @override
  void dispose() {
    _beeTicker.dispose();
    super.dispose();
  }

  // ...existing code continues...

    // ...existing code...
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
    final dirtPileRelativePositions = _dirtPileRelativePositions;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final now = DateTime.now();
    // Check for weeds on build
    updateWeedsForEmptyPiles();
    // Define butterflyHidden for demo (all visible)
    final List<bool> butterflyHidden = List.filled(8, false);
    if (_loadingGoals) {
      debugPrint('GardenTransitionScreen: still loading goals...');
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    debugPrint('GardenTransitionScreen: build with _goals length = \\${_goals.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('On the Path'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Garden background image (always at the bottom)
          Positioned.fill(
            child: Image.asset(
              'assets/images/garden background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Render a butterfly for each goal
          ..._goals.asMap().entries.map((entry) {
            final i = entry.key;
            final goal = entry.value;
            final stage = goal.getCurrentButterflyStage(now);
            final rarity = goal.getButterflyRarity();
            final pos = Offset(0.08 + i * 0.13, 0.18); // Spread out horizontally
            if (stage == 'butterfly') {
              // Show butterfly GIF based on rarity (example: 1-3=common, 4-5=rare, 6-7=ultra rare, 8=legendary)
              String gifAsset;
              switch (rarity) {
                case 'common':
                  gifAsset = 'assets/images/BUTTERFLY 1 GIF.gif';
                  break;
                case 'uncommon':
                  gifAsset = 'assets/images/BUTTERFLY 2 GIF.gif';
                  break;
                case 'rare':
                  gifAsset = 'assets/images/BUTTERFLY 3 GIF.gif';
                  break;
                case 'ultra rare':
                  gifAsset = 'assets/images/BUTTERFLY 4 GIF.gif';
                  break;
                case 'legendary':
                  gifAsset = 'assets/images/BUTTERFLY 5 GIF.gif';
                  break;
                default:
                  gifAsset = 'assets/images/BUTTERFLY 1 GIF.gif';
              }
              return Positioned(
                left: pos.dx * screenWidth - 150,
                top: pos.dy * screenHeight - 150,
                child: Image.asset(
                  gifAsset,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 70, color: Colors.red),
                ),
              );
            } else {
              String image;
              switch (stage) {
                case "egg":
                  image = 'assets/images/BUTTERFLY EGGS.png';
                  break;
                case "caterpillar":
                  image = 'assets/images/BUTTERFLY CATERPILLAR.png';
                  break;
                case "pupa":
                  image = 'assets/images/BUTTERFLY PUPA.png';
                  break;
                default:
                  image = '';
              }
              Widget imgWidget = Image.asset(
                image,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 70, color: Colors.red),
              );
              // Optionally, add rotation/translation for style
              if (stage == 'egg') {
                imgWidget = Transform.rotate(angle: 0.785398, child: imgWidget);
              } else if (stage == 'caterpillar') {
                imgWidget = Transform.translate(offset: const Offset(-205, -30), child: Transform.rotate(angle: 1.5708, child: imgWidget));
              } else if (stage == 'pupa') {
                imgWidget = Transform.translate(offset: const Offset(-435, -80), child: imgWidget);
              }
              return Positioned(
                left: pos.dx * screenWidth - 150,
                top: pos.dy * screenHeight - 150,
                child: imgWidget,
              );
            }
          }),
          // ...existing code...
          // Seed inventory display (top right)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.8),
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
              ],
            ),
          ),
          // Butterfly GIFs (conditionally rendered based on hidden state)
          if (!butterflyHidden[0])
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
          if (!butterflyHidden[1])
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
          if (!butterflyHidden[2])
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
          if (!butterflyHidden[3])
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
          if (!butterflyHidden[4])
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
          if (!butterflyHidden[5])
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
          if (!butterflyHidden[6])
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

              // Animated Bee GIF hopping from pile to pile (always on top, matches butterfly positions)
              // Bee follows a figure 8 (lemniscate) path
              Builder(
                builder: (context) {
                  // Center of the screen, shifted higher
                  final double cx = screenWidth / 2;
                  final double cy = screenHeight * 0.33;
                  // Radii for the figure 8
                  final double rx = screenWidth * 0.32;
                  final double ry = screenHeight * 0.22;
                  // Lemniscate of Gerono: x = rx * sin(t), y = ry * sin(t) * cos(t)
                  final double x = cx + rx * math.sin(_beeFigure8T);
                  final double y = cy + ry * math.sin(_beeFigure8T) * math.cos(_beeFigure8T);
                  return Positioned(
                    left: x - 50,
                    top: y - 50,
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/images/BEE GIF.gif',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ],
      ),
    );
  }
}
