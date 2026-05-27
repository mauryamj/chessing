import 'package:flutter/material.dart';

class MatchLogScreen extends StatelessWidget {
  const MatchLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match History')),
      body: const Center(
        child: Text('Match logs and history charts (Coming in Phase 4)'),
      ),
    );
  }
}
