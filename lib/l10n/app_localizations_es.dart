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
}
