# mic_stream: 0.3.0

[Flutter Plugin]
Provides a tool to get the microphone input as 8 or 16 bit PCM Stream

## About mic_stream:

As Flutter still lacks some functionality, this plugin aims to provide the possibility to easily get an audio stream from the microphone, using a simple java implementation [=> Android only]

## How to use:

### Permissions

Make sure you have microphone recording permissions enabled for your project.
To do so, add this line to the AndroidManifest.xml:

`<uses-permission android:name="android.permission.RECORD_AUDIO"/>`

The plugin provides one class:

`Microphone <T> ({options})`

`{options}` are as described on the [Android page](https://developer.android.com/reference/android/media/AudioRecord#AudioRecord(int,%20int,%20int,%20int,%20int).
Use the provided enums instead of raw integers.

`T` is a generic type describing what type of stream you get, i.e., the stream will be of type `Stream <T>`.
It must be either `List <int>` or `int`; due to dart's dynamic typing system, supporting more is unreasonable.
`int` is the preferable choice, `List <int>` is the more raw variant supported for legacy reasons.

Call `.stream` on it to get a single-subscription stream or `.asBroadcast` to get a broadcast stream.
While someone listens to either of these streams, audio is being recorded;
stopping a subscription will cancel the recording.

NOTE: The stream will listen indefinitely if not cancelled otherwise

#### Example:

```
// Create a new stream
Microphone <int> mic = Microphone <int> (sampleRate: 44100);

// Start listening to the stream
StreamSubscription <int> listener = mic.stream.listen((samples) => print(samples));
```
...
```
// Cancel the subscription
listener.cancel()
```

### Legacy

To support backwards compatibility, the old function
```microphone({options})```
will be continued but its implementation is changed to use a static Microphone object instead.

## Flutter

About Flutter Plugins:
https://flutter.io/developing-packages/

Flutter Documentation:
https://flutter.io/docs
