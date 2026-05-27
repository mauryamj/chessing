import 'package:flutter/material.dart';

class TheoryLibraryScreen extends StatelessWidget {
  const TheoryLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theory Library')),
      body: const Center(
        child: Text('Theory library and concepts catalog (Coming in Phase 3)'),
      ),
    );
  }
}
