import 'package:flutter/material.dart';

class EventsCP extends StatelessWidget {
  const EventsCP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: const Center(
        child: Text(
          'Events Proposal Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
