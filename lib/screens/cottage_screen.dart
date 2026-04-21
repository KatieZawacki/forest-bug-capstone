import 'package:flutter/material.dart';

class CottageScreen extends StatelessWidget {
  const CottageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cottage'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 120, color: Colors.brown[400]),
            const SizedBox(height: 32),
            const Text(
              'It already feels like home.',
              style: TextStyle(fontSize: 22, color: Colors.brown),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/goal-setup');
                  },
                  child: const Text('Make a Goal'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/garden-transition');
                  },
                  child: const Text('Explore the Forest'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
