// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Ziesta';

  @override
  String get startTimer => 'Iniciar';

  @override
  String get cancel => 'Cancelar';

  @override
  String minutesButton(int minutes) {
    return '$minutes min';
  }

  @override
  String get minutesUnit => 'min';

  @override
  String get permissionTitle => 'Permiso necesario';

  @override
  String get permissionMessage =>
      'Para pausar el audio a la hora exacta, Ziesta necesita el permiso «Alarmas y recordatorios». Actívalo en la pantalla que se abrirá y vuelve a pulsar Iniciar.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get defaultDuration => 'Duración por defecto';

  @override
  String pausesAt(String time) {
    return 'Se pausará a las $time';
  }

  @override
  String get menu => 'Menú';

  @override
  String get shareApp => 'Compartir la app';

  @override
  String get faq => 'Preguntas frecuentes';

  @override
  String get helpTitle => 'Ayuda';

  @override
  String shareMessage(String url) {
    return 'Ziesta es un temporizador de sueño que pausa el audio de otras apps. Descárgala aquí: $url';
  }

  @override
  String get faq1Q => '¿Funciona con la pantalla apagada o con la app cerrada?';

  @override
  String get faq1A =>
      'Sí. El temporizador lo gestiona el propio Android con una alarma exacta, así que sigue en marcha aunque cierres la app o apagues la pantalla.';

  @override
  String get faq2Q => '¿Por qué pide el permiso «Alarmas y recordatorios»?';

  @override
  String get faq2A =>
      'Sin él, Android no permite programar una alarma a la hora exacta y el audio podría pausarse con retraso. Se concede una sola vez desde los ajustes del sistema.';

  @override
  String get faq3Q => '¿Para qué sirve el permiso de notificaciones?';

  @override
  String get faq3A =>
      'Para mostrar la cuenta atrás con los botones de ampliar y cancelar. Si lo deniegas, el temporizador funciona igual, pero sin notificación.';

  @override
  String get faq4Q => '¿Con qué apps funciona?';

  @override
  String get faq4A =>
      'Con las que responden a los controles multimedia de Android. Está probado con las apps de YouTube y Twitch; algunos reproductores pueden ignorarlos.';

  @override
  String get faq5Q => '¿Por qué baja el volumen en el último minuto?';

  @override
  String get faq5A =>
      'Para que el audio se apague poco a poco y no de golpe. Al terminar, Ziesta pausa el audio y deja el volumen como estaba.';

  @override
  String get faq6Q => '¿Cómo amplío o cancelo el temporizador?';

  @override
  String get faq6A =>
      'Desde la notificación, con sus botones de ampliar y cancelar, sin abrir la app. También puedes cancelar desde la pantalla principal.';

  @override
  String get faq7Q => '¿Qué pasa si reinicio el móvil?';

  @override
  String get faq7A =>
      'Al reiniciar, Android borra las alarmas pendientes, así que el temporizador se cancela y habría que programarlo de nuevo.';

  @override
  String get faq8Q => '¿Ziesta usa internet o recoge datos?';

  @override
  String get faq8A =>
      'No. Funciona sin conexión y no recoge ni envía ningún dato.';
}
