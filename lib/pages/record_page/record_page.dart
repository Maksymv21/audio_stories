import 'dart:async';

import 'package:audio_stories/pages/home_pages/home_page/home_page.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import 'package:audio_stories/pages/main_pages/widgets/button_menu.dart';
import 'package:audio_stories/pages/record_page/repository/record_repository.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:just_audio/just_audio.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/local_db.dart';

class RecordPage extends StatefulWidget {
  static const routName = '/record';

  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final RecordRepository _recorder = RecordRepository();
  StreamSubscription? _recorderSubscription;
  Duration _position = Duration();
  String _recorderTxt = '00:00:00';
  double _time = 0.0;
  bool _isRecorded = false;
  bool _isPlay = false;

  @override
  void initState() {
    super.initState();
    _recorder.openSession().then((value) {
      _recorder.record(() {
        setState(() {});
      });
    });
    openTheRecorder();
    startTimer();
    noise();
    valuePlayer();
    _isPlay = true;
  }

  Future openTheRecorder() async {
    await _recorder.recorder!.openAudioSession(
      focus: AudioFocus.requestFocusAndStopOthers,
      category: SessionCategory.playAndRecord,
      mode: SessionMode.modeDefault,
    );
    await _recorder.recorder!
        .setSubscriptionDuration(const Duration(milliseconds: 10));
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
  }

  @override
  void dispose() {
    _recorder.close();
    _recorderSubscription?.cancel();
    recordSub?.cancel();
    s?.cancel();
    super.dispose();
  }

  void startTimer() {
    _recorderSubscription = _recorder.onProgress!.listen((e) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          e.duration.inMilliseconds,
          isUtc: true);
      String txt = DateFormat('HH:mm:ss', 'en_GB').format(date);
      setState(() {
        _recorderTxt = txt.substring(0, 8);
        _time = e.duration.inSeconds.toDouble();
      });
    });
  }

  NoiseMeter noiseReading = NoiseMeter();
  StreamSubscription? recordSub;
  double db = 10;

  void noise() {
    recordSub = noiseReading.noiseStream.listen((e) {
      setState(() {
        db = e.maxDecibel;
      });
    });
  }

  StreamSubscription? s;
  double val = 0.0;

  void valuePlayer() {
    print('!');
    s = _recorder.onProgressP!.listen((e) {
      setState(() {
        val = e.position.inSeconds.toDouble();
        print(val);
        print('1');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String icon = _isPlay ? AppIcons.pauseRecord : AppIcons.playRecord;

    Widget childRecord = BlocBuilder<BlocIndex, int>(
      builder: (context, state) => Stack(
        children: [
          Center(
            child: Container(
              color: Colors.black,
              width: 5.0,
              height: db < 0 ? -db : db,
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    const Spacer(
                      flex: 7,
                    ),
                    TextButton(
                      onPressed: () {
                        Utils.globalKey.currentState!
                            .pushReplacementNamed(HomePage.routName);
                        context.read<BlocIndex>().add(
                              ColorHome(),
                            );
                      },
                      child: const Text(
                        'Отменить',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Expanded(
                flex: 2,
                child: Text(
                  'Запись',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
              const Spacer(
                flex: 11,
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(_recorderTxt),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          icon,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    _stopRecord();
                    context.read<BlocIndex>().add(
                          ColorPlay(),
                        );

                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Widget childPlay = StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(LocalDB.uid)
            .collection('sounds')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          AppIcons.upload,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          AppIcons.download,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          AppIcons.delete,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          _recorder.uploadSound(
                            'Аудиозапись ${snapshot.data?.docs.length + 1}',
                            _time,
                          );
                          context.read<BlocIndex>().add(
                                ColorHome(),
                              );
                          Utils.globalKey.currentState!.pushReplacementNamed(
                            HomePage.routName,
                          );
                        },
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Аудиозапись ${snapshot.data?.docs.length + 1}',
                    style: const TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Slider(
                    value: val,
                    // min: -10.0,
                    // max: 10.0,
                    onChanged: (double value) {
                      // setState(() {
                      //   val = value;
                      // });
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          AppIcons.back15,
                        ),
                      ),
                      const SizedBox(
                        width: 50.0,
                      ),
                      GestureDetector(
                        child: ClipRRect(
                          child: Image.asset(
                            icon,
                          ),
                        ),
                        onTap: () {
                          _isPlay ? _pausePlay() : _play();
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        width: 50.0,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          AppIcons.forward15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });

    return Stack(
      children: [
        Column(
          children: const [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppIcons.up,
                child: Align(
                  alignment: AlignmentDirectional(-1.1, -0.7),
                  child: ButtonMenu(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        Align(
          alignment: const AlignmentDirectional(0.0, 1.1),
          child: Container(
            width: 380.0,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 13.0,
              ),
              child: _isRecorded ? childPlay : childRecord,
            ),
          ),
        ),
      ],
    );
  }

  void _stopRecord() {
    _recorder.stopRecord(() {
      setState(() {});
    });
    recordSub?.cancel();

    _isRecorded = true;
    _isPlay = false;
  }

  void _play() {
    _recorder.play(() {
      setState(() {
        print('1111');
        valuePlayer();
      });

      _isPlay = false;
    });

    _isPlay = true;
  }

  void _pausePlay() {
    _recorder.pausePlayer(() {
      setState(() {});
    });

    _isPlay = false;
  }

// StreamBuilder<DurationState> _progressBar() {
//   return StreamBuilder<DurationState>(
//     stream: _durationState,
//     builder: (context, snapshot) {
//       final durationState = snapshot.data;
//       final progress = durationState?.progress ?? Duration.zero;
//       final buffered = durationState?.buffered ?? Duration.zero;
//       final total = durationState?.total ?? Duration.zero;
//       return ProgressBar(
//
//       );
//     },
//   );
// }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
