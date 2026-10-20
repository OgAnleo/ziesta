# Ziesta

App móvil (Flutter/Dart) con temporizador de sueño: pausa el audio/vídeo
(YouTube, Twitch, navegador...) a la hora marcada. Android primero (Samsung SM-A566B).
La v1 es solo el temporizador, pero la estructura debe permitir crecer a una app completa.

## Stack
- Flutter/Dart + Kotlin nativo (canal Kotlin-Dart) para alarma, audio focus y notificaciones
- Sin paquetes externos si se puede hacer simple en Kotlin
- Gestor de estado: Riverpod
- Interfaz en español e inglés (.arb en lib/l10n)
- Paquete Android: com.oscaranleo.ziesta

## Estructura
- lib/main.dart, lib/app.dart: arranque y configuración
- lib/core/audio_channel.dart: canal Dart <-> Kotlin
- lib/features/timer/: timer_notifier.dart (estado/lógica) y timer_screen.dart (UI)
- lib/l10n/: app_es.arb y app_en.arb se editan a mano; app_localizations*.dart son generados, no tocar
- android/app/src/main/kotlin/com/oscaranleo/: MediaPauser.kt
- android/app/src/main/kotlin/com/oscaranleo/ziesta/: MainActivity, TimerScheduler, TimerReceiver, WarningReceiver
- Cada función nueva va en su propia carpeta dentro de lib/features/

## Estado actual
- Hecho: alarma que pausa el audio, persistencia de la hora de fin, cuenta atrás,
  rueda de minutos con presets (10/20/30/60), permiso de alarmas,
  aviso con notificación 1 min antes
- Pendiente: prueba larga de 30 min en el Samsung
- Decidido: NO añadir bloqueo de pantalla al terminar el tiempo (de momento)
- Conocido: audio focus pausa YouTube pero no Twitch

## Comandos
- `flutter run` / `flutter analyze` / `flutter test`

## Cómo trabajar conmigo
- Soy estudiante de DAM; sé Java, casi nada de Dart/Flutter ni Kotlin
- Explica brevemente la sintaxis y conceptos nuevos de Dart y por qué se hace así
- Avanza paso a paso y comprueba cada parte antes de seguir; nada de 200 líneas de golpe
- Cambia solo el código necesario: no reescribas archivos enteros ni repitas lo que ya funciona
- No añadas funcionalidades, dependencias ni refactors que no te pida
- Si falta información imprescindible, pregunta antes de asumir
- Si hago algo mal, dímelo directamente y corrígelo
- Soluciones simples y mantenibles; arquitectura profesional pero sin sobreingeniería
- Lee solo los archivos estrictamente necesarios
- Mensajes de commit de Git en inglés
- Respuestas concisas