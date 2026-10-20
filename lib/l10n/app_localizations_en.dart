// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ziesta';

  @override
  String get startTimer => 'Start';

  @override
  String get cancel => 'Cancel';

  @override
  String minutesButton(int minutes) {
    return '$minutes min';
  }

  @override
  String get minutesUnit => 'min';

  @override
  String get permissionTitle => 'Permission required';

  @override
  String get permissionMessage => 'To pause the audio at the exact time, Ziesta needs the \"Alarms & reminders\" permission. Turn it on in the screen that will open and tap Start again.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';
}
