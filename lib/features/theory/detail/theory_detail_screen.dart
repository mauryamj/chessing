import 'package:flutter/material.dart';

class TheoryDetailScreen extends StatelessWidget {
  final String theoryId;
  const TheoryDetailScreen({super.key, required this.theoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Theory: $theoryId')),
      body: Center(
        child: Text('Detail for theory line: $theoryId'),
      ),
    );
  }
}
