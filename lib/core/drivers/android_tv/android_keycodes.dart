import '../../enums/remote_command.dart';

/// Maps [RemoteCommand] to Android `KeyEvent` key codes.
/// Values from `android.view.KeyEvent`.
int remoteCommandToAndroidKeyCode(RemoteCommand command) {
  return switch (command) {
    RemoteCommand.power => 26, // KEYCODE_POWER
    RemoteCommand.volumeUp => 24, // KEYCODE_VOLUME_UP
    RemoteCommand.volumeDown => 25, // KEYCODE_VOLUME_DOWN
    RemoteCommand.mute => 164, // KEYCODE_VOLUME_MUTE
    RemoteCommand.home => 3, // KEYCODE_HOME
    RemoteCommand.back => 4, // KEYCODE_BACK
    RemoteCommand.menu => 82, // KEYCODE_MENU
    RemoteCommand.up => 19, // KEYCODE_DPAD_UP
    RemoteCommand.down => 20, // KEYCODE_DPAD_DOWN
    RemoteCommand.left => 21, // KEYCODE_DPAD_LEFT
    RemoteCommand.right => 22, // KEYCODE_DPAD_RIGHT
    RemoteCommand.ok => 23, // KEYCODE_DPAD_CENTER
    RemoteCommand.play => 126, // KEYCODE_MEDIA_PLAY
    RemoteCommand.pause => 127, // KEYCODE_MEDIA_PAUSE
    RemoteCommand.stop => 86, // KEYCODE_MEDIA_STOP
    RemoteCommand.next => 87, // KEYCODE_MEDIA_NEXT
    RemoteCommand.previous => 88, // KEYCODE_MEDIA_PREVIOUS
    RemoteCommand.channelUp => 166, // KEYCODE_CHANNEL_UP
    RemoteCommand.channelDown => 167, // KEYCODE_CHANNEL_DOWN
    RemoteCommand.fastForward => 90, // KEYCODE_MEDIA_FAST_FORWARD
    RemoteCommand.rewind => 89, // KEYCODE_MEDIA_REWIND
    RemoteCommand.voice => 499, // KEYCODE_VOICE_ASSIST
  };
}

/// Maps a Unicode code point to an Android key code.
/// Returns null for unsupported characters.
int? charCodeToAndroidKeyCode(int char) {
  if (char >= 0x30 && char <= 0x39) return char - 0x30 + 7; // KEYCODE_0..9
  if (char >= 0x41 && char <= 0x5a) return char - 0x41 + 29; // KEYCODE_A..Z
  if (char >= 0x61 && char <= 0x7a) return char - 0x61 + 29; // lowercase A..Z
  return switch (char) {
    0x20 => 62, // SPACE -> KEYCODE_SPACE
    0x2e => 56, // . -> KEYCODE_PERIOD
    0x2c => 55, // , -> KEYCODE_COMMA
    0x21 => 75, // ! -> KEYCODE_PLUS (shifted 1)
    _ => null,
  };
}
