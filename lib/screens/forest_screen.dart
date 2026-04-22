import 'package:flutter/material.dart';

class ForestScreen extends StatelessWidget {
  const ForestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forest'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Forest background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/forest background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Large bare tree image slightly above bottom center, double size
          Positioned(
            left: 0,
            right: 0,
            bottom: 20, // move down slightly
            top: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/bare tree.png',
                fit: BoxFit.fitHeight,
                width: 1200,
              ),
            ),
          ),
          // Bare tree 2 image (left side, large)
          Positioned(
            left: -200,
            bottom: 20,
            top: 0,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                'assets/images/bare tree 2.png',
                fit: BoxFit.fitHeight,
                width: 1200,
              ),
            ),
          ),
          // Pine tree image (right side, same size as other trees)
          Positioned(
            right: -200,
            bottom: 20,
            top: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/PINE TREE.png',
                fit: BoxFit.fitHeight,
                width: 1200,
              ),
            ),
          ),

          // Seed image (bottom 3% of the screen)
          Positioned(
            left: 200,
            bottom: MediaQuery.of(context).size.height * 0.03,
            child: Image.asset(
              'assets/images/SEED.png',
              width: 80,
              height: 80,
            ),
          ),

          // Text at the bottom, overlapping image if needed
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black.withAlpha((0.5 * 255).toInt()),
                child: const Text(
                  'The trees are strong but bare',
                  style: TextStyle(fontSize: 22, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
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
        ],
      ),
    );
  }
}
