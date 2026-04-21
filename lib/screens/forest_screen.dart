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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 260,
              child: Image.asset(
                'assets/images/bare tree.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'A peaceful forest full of life.',
              style: TextStyle(fontSize: 22, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
