import 'package:flutter/material.dart';
import 'package:ziesta/core/audio_channel.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ziesta')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // aquí tu ElevatedButton de "Iniciar", sin cambios
            ElevatedButton(
              onPressed: () => AudioChannel().pauseMedia(),
              child: const Text('Pausar ahora'),
            ),
          ],
        ),
      ),
    );
  }
}
