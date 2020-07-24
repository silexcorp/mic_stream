import 'dart:async';

import 'package:permission/permission.dart';
import 'package:flutter/services.dart';

import 'package:mic_stream/microphone/Microphone.dart';

// In reference to the implementation of the official sensors plugin
// https://github.com/flutter/plugins/tree/master/packages/sensors

enum AudioSource {
  DEFAULT,
  MIC,
  VOICE_UPLINK,
  VOICE_DOWNLINK,
  VOICE_CALL,
  CAMCORDER,
  VOICE_RECOGNITION,
  VOICE_COMMUNICATION,
  REMOTE_SUBMIX,
  UNPROCESSED,
  VOICE_PERFORMANCE
}
enum ChannelConfig { CHANNEL_IN_MONO, CHANNEL_IN_STEREO }
enum AudioFormat { ENCODING_PCM_8BIT, ENCODING_PCM_16BIT }

const AudioSource _DEFAULT_AUDIO_SOURCE = AudioSource.DEFAULT;
const ChannelConfig _DEFAULT_CHANNELS_CONFIG = ChannelConfig.CHANNEL_IN_MONO;
const AudioFormat _DEFAULT_AUDIO_FORMAT = AudioFormat.ENCODING_PCM_8BIT;
const int _DEFAULT_SAMPLE_RATE = 16000;

const int _MIN_SAMPLE_RATE = 1;
const int _MAX_SAMPLE_RATE = 100000;

const EventChannel _microphoneEventChannel =
    EventChannel('aaron.code.com/mic_stream');

Permissions _permission;

// This function manages the permission and ensures you're allowed to record audio
Future<bool> get permissionStatus async {
  _permission =
      (await Permission.getPermissionsStatus([PermissionName.Microphone]))
          .first;
  if (_permission.permissionStatus != PermissionStatus.allow)
    _permission =
        (await Permission.requestPermissions([PermissionName.Microphone]))
            .first;
  return (_permission.permissionStatus == PermissionStatus.allow);
}

Stream<List<int>> microphone({
  AudioSource audioSource: _DEFAULT_AUDIO_SOURCE,
  int sampleRate: _DEFAULT_SAMPLE_RATE,
  ChannelConfig channelConfig: _DEFAULT_CHANNELS_CONFIG,
  AudioFormat audioFormat: _DEFAULT_AUDIO_FORMAT
}) async* {
  yield* Microphone <List <int>> (
      audioSource: audioSource,
      sampleRate: sampleRate,
      channelConfig: channelConfig,
      audioFormat: audioFormat
  ).stream;
}
