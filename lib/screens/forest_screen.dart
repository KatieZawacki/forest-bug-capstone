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
          // Large bare tree image bottom center
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/bare tree.png',
                fit: BoxFit.fitHeight,
                width: 600,
              ),
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
                color: Colors.black.withOpacity(0.5),
                child: const Text(
                  'The trees are strong but bare',
                  style: TextStyle(fontSize: 22, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
