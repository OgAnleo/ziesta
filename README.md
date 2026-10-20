# Ziesta

A sleep timer for Android that **pauses the audio of other apps** (YouTube, Twitch...)
after the time you choose, so you never wake up with a video still playing.

![Main screen](docs/screenshots/main.png)
![Countdown](docs/screenshots/countdown.png)
![Settings](docs/screenshots/settings.png)

## Features

- Pick the time with a wheel (1-180 minutes) or one of the quick buttons: 10, 20, 30 and 60 minutes.
- Works with the screen off and with the app closed.
- Notification one minute before the audio is paused.
- Countdown that survives closing the app.
- Settings: default duration and light/dark theme (dark by default).
- Spanish and English.

## How it works

Flutter can't control other apps' audio by itself, so the project combines two layers:

- **Dart / Flutter**: UI, state (Riverpod), settings and storage (`shared_preferences`).
- **Kotlin (Android)**, reached through a `MethodChannel`:
  - `AlarmManager` schedules an exact alarm that fires even in Doze mode.
  - A `BroadcastReceiver` requests **audio focus** and sends a **media pause key event**,
    which makes players such as YouTube and Twitch pause.
  - A second alarm posts the warning notification one minute earlier.

The countdown on screen is only a display: the real timer belongs to the system,
so it keeps working if the app is killed.

## Install

Download the latest APK from the [Releases](../../releases) page and open it on your phone
(you may need to allow installing apps from your browser).

Requires Android 8.0 or newer. On first use, Ziesta asks for:

- **Alarms & reminders** (exact alarms), to pause at the right time.
- **Notifications**, for the one-minute warning.

## Build from source

```
flutter pub get
flutter gen-l10n
flutter run
```

Run the checks with `dart format .`, `flutter analyze` and `flutter test`.
To build a signed release you need your own keystore and an `android/key.properties` file
(not included in the repository).

## Project structure

```
lib/
  core/        shared code (native channel, preferences)
  features/
    timer/     timer screen, state and countdown
    settings/  settings screen and state
  l10n/        translations (.arb)
android/app/src/main/kotlin/   alarm, audio and notification code
test/                          unit and widget tests
```

## Known limitations

- Restarting the phone cancels the pending alarm.
- Tested with the YouTube and Twitch apps; other players may ignore audio focus
  and media keys.
