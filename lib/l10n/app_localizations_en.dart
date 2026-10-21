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
  String get lockOnEnd => 'Lock screen when it ends';

  @override
  String get lockOnEndHint =>
      'Locks the phone after pausing the audio. Android will ask you to turn on Ziesta as a device administrator.';

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
  String get faq2Q => 'Which apps does it work with?';

  @override
  String get faq2A =>
      'Apps that respond to the Android media controls. It has been tested with the YouTube and Twitch apps; some players may ignore them.';

  @override
  String get faq3Q => 'Why does it ask for the Alarms & reminders permission?';

  @override
  String get faq3A =>
      'Without it, Android does not allow scheduling an alarm at an exact time and the audio could pause late. It is granted only once from the system settings.';

  @override
  String get faq4Q => 'What is the notification permission for?';

  @override
  String get faq4A =>
      'To show the countdown with the extend and cancel buttons. If you deny it, the timer still works, just without the notification.';

  @override
  String get faq5Q => 'How do I extend or cancel the timer?';

  @override
  String get faq5A =>
      'From the notification, with its extend and cancel buttons, without opening the app. You can also cancel from the main screen, or extend with the volume button during the last minute.';

  @override
  String get faq6Q => 'Can I change how much time the extend button adds?';

  @override
  String get faq6A =>
      'Yes. In Settings, under Extend amount, you can choose between 1 and 60 minutes. The notification button always shows the chosen amount.';

  @override
  String get faq7Q => 'Why does the volume go down during the last minute?';

  @override
  String get faq7A =>
      'So the audio fades out gradually instead of stopping abruptly. When the time is up, Ziesta pauses the audio and leaves the volume as it was.';

  @override
  String get faq8Q => 'How do I extend the time with the volume button?';

  @override
  String get faq8A =>
      'While the volume is going down in the last minute, press volume up on your phone: the amount chosen in Settings is added and the volume goes back to what you had. You can turn it off in Settings, under Extend with volume button.';

  @override
  String get faq9Q => 'How do I make the phone lock when the timer ends?';

  @override
  String get faq9A =>
      'Turn on Lock screen when it ends in Settings. Android will ask you to turn on Ziesta as a device administrator. When the timer ends, Ziesta pauses the audio and locks the phone.';

  @override
  String get faq10Q => 'Why does Ziesta ask to be a device administrator?';

  @override
  String get faq10A =>
      'Only to be able to lock the screen, and only if you turn that option on. Ziesta uses no other administrator function: it cannot erase data or change your password.';

  @override
  String get faq11Q =>
      'How do I uninstall Ziesta if I turned on the screen lock?';

  @override
  String get faq11A =>
      'While Ziesta is an administrator, Android does not allow uninstalling it. Turn off Lock screen when it ends in Settings, or remove its permission in your phone settings (Security, Device administrators), and then uninstall it normally.';

  @override
  String get faq12Q => 'What happens if I restart my phone?';

  @override
  String get faq12A =>
      'When the phone restarts, Android clears pending alarms, so the timer is cancelled and you would need to set it again.';

  @override
  String get faq13Q => 'Does Ziesta use the internet or collect data?';

  @override
  String get faq13A =>
      'No. It works offline and does not collect or send any data.';
}
