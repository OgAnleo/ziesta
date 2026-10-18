import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ziesta')),
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: const Text('Iniciar')),
      ),
    );
  }
}
