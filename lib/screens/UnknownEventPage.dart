import 'package:flutter/material.dart';

class UnknownEventPage extends StatelessWidget {
  const UnknownEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Event'),
      ),
      body: const Center(
        child: Text(
          'This event type is not handled yet!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
