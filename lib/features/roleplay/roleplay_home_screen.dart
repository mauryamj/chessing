import 'package:flutter/material.dart';

class RoleplayHomeScreen extends StatelessWidget {
  const RoleplayHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coaching & Roleplay')),
      body: const Center(
        child: Text('AI coaching personas and roleplay (Coming in Phase 3)'),
      ),
    );
  }
}
