import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class TestPage extends StatefulWidget {
  static const routName = '/test';

  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // FlutterSoundRecorder? _recordingSession;
  // final recordingPlayer = AssetsAudioPlayer();
  // String? pathToAudio;
  // bool _playAudio = false;
  // String _timerText = '00:00:00';
  //
  // @override
  // void initState() {
  //   super.initState();
  //   initializer();
  // }
  //
  // void initializer() async {
  //   pathToAudio = 'temp.aac';
  //   _recordingSession = FlutterSoundRecorder();
  //   await _recordingSession!.openAudioSession(
  //     focus: AudioFocus.requestFocusAndStopOthers,
  //     category: SessionCategory.playAndRecord,
  //     mode: SessionMode.modeDefault,
  //     //device: AudioDevice.speaker
  //   );
  //   await _recordingSession!
  //       .setSubscriptionDuration(Duration(milliseconds: 10));
  //   // await initializeDateFormatting();
  //   await Permission.microphone.request();
  //   await Permission.storage.request();
  //   await Permission.manageExternalStorage.request();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black87,
  //     appBar: AppBar(title: Text('Audio Recording and Playing')),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           SizedBox(
  //             height: 40,
  //           ),
  //           Container(
  //             child: Center(
  //               child: Text(
  //                 _timerText,
  //                 style: TextStyle(fontSize: 70, color: Colors.red),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               createElevatedButton(
  //                 icon: Icons.mic,
  //                 iconColor: Colors.red,
  //                 onPressFunc: startRecording,
  //               ),
  //               SizedBox(
  //                 width: 30,
  //               ),
  //               createElevatedButton(
  //                 icon: Icons.stop,
  //                 iconColor: Colors.red,
  //                 onPressFunc: stopRecording,
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           ElevatedButton.icon(
  //             style:
  //                 ElevatedButton.styleFrom(elevation: 9.0, primary: Colors.red),
  //             onPressed: () {
  //               setState(() {
  //                 _playAudio = !_playAudio;
  //               });
  //               if (_playAudio) playFunc();
  //               if (!_playAudio) stopPlayFunc();
  //             },
  //             icon: _playAudio
  //                 ? Icon(
  //                     Icons.stop,
  //                   )
  //                 : Icon(Icons.play_arrow),
  //             label: _playAudio
  //                 ? Text(
  //                     "Stop",
  //                     style: TextStyle(
  //                       fontSize: 28,
  //                     ),
  //                   )
  //                 : Text(
  //                     "Play",
  //                     style: TextStyle(
  //                       fontSize: 28,
  //                     ),
  //                   ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // ElevatedButton createElevatedButton(
  //     {required IconData icon,
  //     required Color iconColor,
  //     required Function() onPressFunc}) {
  //   return ElevatedButton.icon(
  //     style: ElevatedButton.styleFrom(
  //       padding: EdgeInsets.all(6.0),
  //       side: BorderSide(
  //         color: Colors.red,
  //         width: 4.0,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       primary: Colors.white,
  //       elevation: 9.0,
  //     ),
  //     onPressed: onPressFunc,
  //     icon: Icon(
  //       icon,
  //       color: iconColor,
  //       size: 38.0,
  //     ),
  //     label: Text(''),
  //   );
  // }
  //
  // Future<void> startRecording() async {
  //   Directory directory = Directory(path.dirname(pathToAudio!));
  //   if (!directory.existsSync()) {
  //     directory.createSync();
  //   }
  //   _recordingSession!.openAudioSession();
  //   await _recordingSession!.startRecorder(
  //     toFile: pathToAudio,
  //     codec: Codec.aacMP4,
  //   );
  //   StreamSubscription _recorderSubscription =
  //       _recordingSession!.onProgress!.listen((e) {
  //     var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
  //         isUtc: true);
  //     var timeText = DateTime.now().microsecond.toString();
  //     setState(() {
  //       _timerText = timeText.substring(0, 8);
  //     });
  //   });
  //   _recorderSubscription.cancel();
  // }
  //
  // Future<String?> stopRecording() async {
  //   _recordingSession!.closeAudioSession();
  //   return await _recordingSession!.stopRecorder();
  // }
  //
  // Future<void> playFunc() async {
  //   recordingPlayer.open(
  //     Audio.file(pathToAudio!),
  //     autoStart: true,
  //     showNotification: true,
  //   );
  // }
  //
  // Future<void> stopPlayFunc() async {
  //   recordingPlayer.stop();
  // }

final Codec _codec = Codec.aacMP4;
String _mPath = '/sdcard/Download/temp.aac';
FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
bool _mPlayerIsInited = false;
bool _mRecorderIsInited = false;
bool _mPlaybackReady = false;

@override
void initState() {
  _mPlayer!.openAudioSession().then((value) {
    setState(() {
      _mPlayerIsInited = true;
    });
  });

  openTheRecorder().then((value) {
    setState(() {
      _mRecorderIsInited = true;
    });
  });
  super.initState();
}

@override
void dispose() {
  _mPlayer!.closeAudioSession();
  _mPlayer = null;

  _mRecorder!.closeAudioSession();
  _mRecorder = null;
  super.dispose();
}

Future<void> openTheRecorder() async {
  _mPath = 'temp.aac';
  _mRecorder = FlutterSoundRecorder();
    await _mRecorder!.openAudioSession(
      focus: AudioFocus.requestFocusAndStopOthers,
      category: SessionCategory.playAndRecord,
      mode: SessionMode.modeDefault,
      //device: AudioDevice.speaker
    );
    await _mRecorder!
        .setSubscriptionDuration(const Duration(milliseconds: 10));
    // await initializeDateFormatting();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  final status = await Permission.microphone.request();
  if (status != PermissionStatus.granted) {
    throw RecordingPermissionException('Microphone permission not granted');
  }
  // await Permission.storage.request();
  // await Permission.manageExternalStorage.request();
  // await _mRecorder!.startRecorder();
  // if (!await _mRecorder!.isEncoderSupported(_codec)) {
  //   _codec = Codec.opusWebM;
  //   _mPath = 'test.aac';
  //   if (!await _mRecorder!.isEncoderSupported(_codec)) {
  //     _mRecorderIsInited = true;
  //     return;
  //   }
  // }
  // final session = await AudioSession.instance;
  // await session.configure(AudioSessionConfiguration(
  //   avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
  //   avAudioSessionCategoryOptions:
  //       AVAudioSessionCategoryOptions.allowBluetooth |
  //           AVAudioSessionCategoryOptions.defaultToSpeaker,
  //   avAudioSessionMode: AVAudioSessionMode.spokenAudio,
  //   avAudioSessionRouteSharingPolicy:
  //       AVAudioSessionRouteSharingPolicy.defaultPolicy,
  //   avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
  //   androidAudioAttributes: const AndroidAudioAttributes(
  //     contentType: AndroidAudioContentType.speech,
  //     flags: AndroidAudioFlags.none,
  //     usage: AndroidAudioUsage.voiceCommunication,
  //   ),
  //   androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
  //   androidWillPauseWhenDucked: true,
  // ));

  _mRecorderIsInited = true;
}

void record() {
  Directory directory = Directory(path.dirname(_mPath));
    if (!directory.existsSync()) {
      directory.createSync();
    }
  _mRecorder!
      .startRecorder(
    toFile: _mPath,
    codec: _codec,

  )
      .then((value) {
    setState(() {});
  });
}

void stopRecorder() async {
  await _mRecorder!.stopRecorder().then((value) {
    setState(() {
      //var url = value;
      _mPlaybackReady = true;
    });
  });
}

void play() {
  assert(_mPlayerIsInited &&
      _mPlaybackReady &&
      _mRecorder!.isStopped &&
      _mPlayer!.isStopped);
  _mPlayer!
      .startPlayer(
          fromURI: _mPath,
          //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
          whenFinished: () {
            setState(() {});
          })
      .then((value) {
    setState(() {});
  });
}

void stopPlayer() {
  _mPlayer!.stopPlayer().then((value) {
    setState(() {});
  });
}

Function()? getRecorderFn() {
  if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
    return null;
  }
  return _mRecorder!.isStopped ? record : stopRecorder;
}

Function()? getPlaybackFn() {
  if (!_mPlayerIsInited || !_mPlaybackReady || !_mRecorder!.isStopped) {
    return null;
  }
  return _mPlayer!.isStopped ? play : stopPlayer;
}

@override
Widget build(BuildContext context) {
  Widget makeBody() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(3),
          height: 80,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF0E6),
            border: Border.all(
              color: Colors.indigo,
              width: 3,
            ),
          ),
          child: Row(children: [
            ElevatedButton(
              onPressed: getRecorderFn(),
              //color: Colors.white,
              //disabledColor: Colors.grey,
              child: Text(_mRecorder!.isRecording ? 'Stop' : 'Record'),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(_mRecorder!.isRecording
                ? 'Recording in progress'
                : 'Recorder is stopped'),
          ]),
        ),
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(3),
          height: 80,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF0E6),
            border: Border.all(
              color: Colors.indigo,
              width: 3,
            ),
          ),
          child: Row(children: [
            ElevatedButton(
              onPressed: getPlaybackFn(),
              //color: Colors.white,
              //disabledColor: Colors.grey,
              child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Play'),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(_mPlayer!.isPlaying
                ? 'Playback in progress'
                : 'Player is stopped'),
          ]),
        ),
      ],
    );
  }

  return Scaffold(
    backgroundColor: Colors.blue,
    appBar: AppBar(
      title: const Text('Simple Recorder'),
    ),
    body: makeBody(),
  );
}
}
