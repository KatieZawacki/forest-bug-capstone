import 'package:flutter/material.dart';

class CottageWallScreen extends StatelessWidget {
  const CottageWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cottage Wall'),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Text(
          'You are looking at the wall! (Add your wall content here)',
          style: TextStyle(fontSize: 24, color: Colors.brown[700]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
