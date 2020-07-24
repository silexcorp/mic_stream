import 'dart:async';

import 'package:flutter/services.dart';

import 'package:mic_stream/mic_stream.dart';

const AudioSource _DEFAULT_AUDIO_SOURCE = AudioSource.DEFAULT;
const ChannelConfig _DEFAULT_CHANNELS_CONFIG = ChannelConfig.CHANNEL_IN_MONO;
const AudioFormat _DEFAULT_AUDIO_FORMAT = AudioFormat.ENCODING_PCM_8BIT;
const int _DEFAULT_SAMPLE_RATE = 16000;

const int _MIN_SAMPLE_RATE = 1;
const int _MAX_SAMPLE_RATE = 100000;

const EventChannel _microphoneEventChannel =
        EventChannel('aaron.code.com/mic_stream');

class Microphone <T> {
    Microphone({
        AudioSource audioSource: _DEFAULT_AUDIO_SOURCE,
        int sampleRate: _DEFAULT_SAMPLE_RATE,
        ChannelConfig channelConfig: _DEFAULT_CHANNELS_CONFIG,
        AudioFormat audioFormat: _DEFAULT_AUDIO_FORMAT
    }) {
        if (sampleRate < _MIN_SAMPLE_RATE || sampleRate > _MAX_SAMPLE_RATE)
            throw (RangeError.range(sampleRate, _MIN_SAMPLE_RATE, _MAX_SAMPLE_RATE));

        _stream = _cast(_squash(_microphoneEventChannel.receiveBroadcastStream([
            audioSource.index,
            sampleRate,
            channelConfig == ChannelConfig.CHANNEL_IN_MONO ? 16 : 12,
            audioFormat == AudioFormat.ENCODING_PCM_8BIT ? 3 : 2
        ]), audioFormat), T.toString());
    }

    Stream <T> _stream;

    Stream <T> get stream => _stream;
    Stream <T> get asBroadcast => _stream.asBroadcastStream();

    Stream <dynamic> _cast (Stream <List <int>> data, String type) async* {
        if (!(await permissionStatus)) throw (PlatformException);

        if (type == "List<int>")
            yield* data;
        if (type == "int")
            yield* data.expand((element) => element);
        throw FormatException("mic_stream: The generic type must be either List<int> or int");
    }

    Stream <List <int>> _squash (Stream <List <int>> data, AudioFormat audioFormat) async* {
        yield* data.map(_squashList);
    }

    List<int> _squashList (List<int> byteSamples) {
        List<int> shortSamples = List();
        bool isFirstElement = true;
        int first;
        for (var sample in byteSamples) {
            if (isFirstElement)
                first = sample;
            else
                shortSamples.add(_squashPair(first, sample));
            isFirstElement = !isFirstElement;
        }
        return shortSamples;
    }

    int _squashPair (int first, int second) {
        return first * 256 + second - 32767;
    }
}
