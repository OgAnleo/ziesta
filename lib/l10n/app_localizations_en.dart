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
  String get permissionMessage =>
      'To pause the audio at the exact time, Ziesta needs the \"Alarms & reminders\" permission. Turn it on in the screen that will open and tap Start again.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get defaultDuration => 'Default duration';

  @override
  String get extendAmount => 'Extend amount';

  @override
  String get volumeExtend => 'Extend with volume button';

  @override
  String get volumeExtendHint =>
      'During the last minute, press volume up to add more time.';

  @override
  String pausesAt(String time) {
    return 'Pauses at $time';
  }

  @override
  String get menu => 'Menu';

  @override
  String get shareApp => 'Share the app';

  @override
  String get faq => 'FAQ';

  @override
  String get helpTitle => 'Help';

  @override
  String shareMessage(String url) {
    return 'Ziesta is a sleep timer that pauses the audio of other apps. Download it here: $url';
  }

  @override
  String get faq1Q => 'Does it work with the screen off or the app closed?';

  @override
  String get faq1A =>
      'Yes. Android itself manages the timer with an exact alarm, so it keeps running even if you close the app or turn the screen off.';

  @override
  String get faq2Q => 'Why does it need the Alarms & reminders permission?';

  @override
  String get faq2A =>
      'Without it, Android does not allow scheduling an alarm at an exact time and the audio could pause late. It is granted only once from the system settings.';

  @override
  String get faq3Q => 'What is the notification permission for?';

  @override
  String get faq3A =>
      'To show the countdown with the extend and cancel buttons. If you deny it, the timer still works, just without the notification.';

  @override
  String get faq4Q => 'Which apps does it work with?';

  @override
  String get faq4A =>
      'Apps that respond to the Android media controls. It has been tested with the YouTube and Twitch apps; some players may ignore them.';

  @override
  String get faq5Q => 'Why does the volume go down during the last minute?';

  @override
  String get faq5A =>
      'So the audio fades out gradually instead of stopping abruptly. When the time is up, Ziesta pauses the audio and leaves the volume as it was.';

  @override
  String get faq6Q => 'How do I extend or cancel the timer?';

  @override
  String get faq6A =>
      'From the notification, with its extend and cancel buttons, without opening the app. You can also cancel from the main screen.';

  @override
  String get faq7Q => 'What happens if I restart my phone?';

  @override
  String get faq7A =>
      'When the phone restarts, Android clears pending alarms, so the timer is cancelled and you would need to set it again.';

  @override
  String get faq8Q => 'Does Ziesta use the internet or collect data?';

  @override
  String get faq8A =>
      'No. It works offline and does not collect or send any data.';
}
