import 'dart:async';
import 'dart:math';

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
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
  String _recorderTxt = '00:00:00';
  String _playTxt = '00:00';
  double _time = 0.0;
  bool _isRecorded = false;
  bool _isPlay = false;
  bool _isPause = false;

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
    _playerSubscription?.cancel();
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
  double db = 0.0;

  void noise() {
    recordSub = noiseReading.noiseStream.listen((e) {
      setState(() {
        db = e.maxDecibel;
      });
    });
  }

  StreamSubscription? _playerSubscription;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  void valuePlayer() {
    _playerSubscription = _recorder.onProgressP!.listen((e) {
      maxDuration = e.duration.inMilliseconds.toDouble();
      if (maxDuration <= 0) maxDuration = 0.0;

      sliderCurrentPosition =
          min(e.position.inMilliseconds.toDouble(), maxDuration);
      if (sliderCurrentPosition < 0.0) {
        sliderCurrentPosition = 0.0;
      }
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          e.position.inMilliseconds,
          isUtc: true);
      String txt = DateFormat('mm:ss', 'en_GB').format(date);
      setState(() {
        _playTxt = txt.substring(0, 5);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String icon = AppIcons.playRecord;
    if (_isPlay) {
      icon = _isPlay && _isPause ? AppIcons.playRecord : AppIcons.pauseRecord;
    } else {
      icon = AppIcons.playRecord;
    }

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
                            DateTime.now(),
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
                  flex: 4,
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
                const Spacer(),
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      SfSlider(
                        value: min(sliderCurrentPosition, maxDuration),
                        min: 0.0,
                        max: maxDuration,
                        thumbShape: _SfThumbShape(),
                        activeColor: Colors.black,
                       inactiveColor: Colors.black,
                        onChanged: (value) async {
                          sliderCurrentPosition = value;
                          await seek(value.toInt());
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_playTxt),
                            Text(
                              _recorderTxt.substring(3, 8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          sliderCurrentPosition =
                              sliderCurrentPosition - 15000.0;
                          if (sliderCurrentPosition < 0) {
                            sliderCurrentPosition = 0.0;
                          }
                          await seek(sliderCurrentPosition.toInt());
                          setState(() {});
                        },
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
                          if (_isPlay) _isPause ? _resumePlay() : _pausePlay();
                          if (!_isPlay) _play();
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        width: 50.0,
                      ),
                      IconButton(
                        onPressed: () async {
                          sliderCurrentPosition += 15000.0;
                          if (sliderCurrentPosition > maxDuration) {
                            sliderCurrentPosition = maxDuration - 300;
                          }
                          await seek(sliderCurrentPosition.toInt());
                          setState(() {});
                        },
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

  void _play() async {
    await _recorder.play(() {
      setState(() {});
      _isPlay = false;
    });
    valuePlayer();
    setState(() {});
    _isPlay = true;
  }

  void _pausePlay() {
    _recorder.pausePlayer(() {
      setState(() {});
    });
    _isPause = true;
  }

  void _resumePlay() {
    _recorder.resumePlayer(() {
      setState(() {});
    });
    _isPause = false;
  }

  Future<void> seek(int ms) async {
    await _recorder.seek(ms);
    setState(() {});
  }
}

class _SfThumbShape extends SfThumbShape {
  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
      required RenderBox? child,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required SfThumb? thumb}) {
    final Path path = Path();

    path.addOval(Rect.fromLTRB(
        center.dx - 10, center.dy - 7, center.dx + 10, center.dy + 7));

    path.close();
    context.canvas.drawPath(path, Paint());
  }
}

