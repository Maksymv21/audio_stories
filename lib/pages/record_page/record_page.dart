import 'dart:async';
import 'dart:math';

import 'package:audio_stories/pages/home_pages/home_page/home_page.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import 'package:audio_stories/pages/main_pages/resources/thumb_shape.dart';
import 'package:audio_stories/pages/main_pages/widgets/button_menu.dart';
import 'package:audio_stories/pages/record_page/repository/record_repository.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../utils/local_db.dart';
import '../main_pages/main_page/main_page.dart';

class RecordPage extends StatefulWidget {
  static const routName = '/record';

  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final RecordRepository _recorder = RecordRepository();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _recorderSubscription;
  String _recorderTxt = '00:00:00';
  String _playTxt = '00:00';
  String _playTxtChange = '00:00';
  double _time = 0.0;
  bool _isRecorded = false;
  bool _isPlay = false;
  bool _isPause = false;
  bool _onChanged = false;
  double val = 0.0;

  @override
  void initState() {
    super.initState();
    _recorder.openSession().then((value) {
      _recorder.record(() {
        setState(() {});
      });
    });
    openTheRecorder();
    //startTimer();
    noise();
    _getAmplitude();
    _isPlay = true;
  }

  Future openTheRecorder() async {
    // await _recorder.recorder!.openAudioSession(
    //   focus: AudioFocus.requestFocusAndStopOthers,
    //   category: SessionCategory.playAndRecord,
    //   mode: SessionMode.modeDefault,
    // );

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

  @override
  void dispose() {
    _recorder.close();
    _recorderSubscription?.cancel();
    recordSub?.cancel();
    _playerSubscription?.cancel();
    _timerAmplitude!.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // void startTimer() {
  //   _recorderSubscription = _recorder.onProgress!.listen((e) {
  //     DateTime date = DateTime.fromMillisecondsSinceEpoch(
  //         e.duration.inMilliseconds,
  //         isUtc: true);
  //     String txt = DateFormat('HH:mm:ss', 'en_GB').format(date);
  //     setState(() {
  //       _recorderTxt = txt.substring(0, 8);
  //       _time = e.duration.inSeconds.toDouble();
  //     });
  //   });
  // }

  void refreshTimer(double value) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
    String txt = DateFormat('mm:ss', 'en_GB').format(date);
    _playTxtChange = txt.substring(0, 5);
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
            child: _amplitudeRecords(),
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
                        MainPage.globalKey.currentState!
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
            final String title =
                'Аудиозапись ${snapshot.data?.docs.length + 1}';
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
                        onPressed: () {
                          _recorder.share();
                        },
                        icon: Image.asset(
                          AppIcons.upload,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _recorder
                              .download(
                                title,
                              )
                              .then(
                                (value) => GlobalRepo.showSnackBar(
                                  context: context,
                                  title: 'Файл сохранен.'
                                      '\nDownload/$title.aac',
                                ),
                              );
                        },
                        icon: Image.asset(
                          AppIcons.download,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          MainPage.globalKey.currentState!
                              .pushReplacementNamed(HomePage.routName);
                          context.read<BlocIndex>().add(
                                ColorHome(),
                              );
                        },
                        icon: Image.asset(
                          AppIcons.delete,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          _save(
                            context,
                            snapshot.data?.docs.length,
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
                    title,
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
                      Transform.scale(
                        scaleY: 0.8,
                        child: SfSlider(
                          value: _onChanged ? val : sliderCurrentPosition,
                          min: 0.0,
                          max: maxDuration,
                          thumbShape: ThumbShape(
                            color: Colors.black,
                          ),
                          activeColor: Colors.black,
                          inactiveColor: Colors.black,
                          onChanged: (value) {
                            if (_isPause) {
                              sliderCurrentPosition = value;
                            } else {
                              val = value;
                            }
                            refreshTimer(value);
                            _onChanged = true;
                          },
                          onChangeEnd: (value) async {
                            await seek(value.toInt());
                            val = sliderCurrentPosition;
                            _onChanged = false;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _onChanged || _isPause
                                  ? _playTxtChange
                                  : _playTxt,
                            ),
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
                          if (sliderCurrentPosition < 0.0) {
                            sliderCurrentPosition = 0.0;
                          }
                          refreshTimer(sliderCurrentPosition);
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
                          refreshTimer(sliderCurrentPosition);
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
                          refreshTimer(sliderCurrentPosition);
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
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.active,
              ),
            );
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
                  alignment: AlignmentDirectional(-1.1, -0.95),
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
            width: MediaQuery.of(context).size.width * 0.96,
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

  List _listAmplitude = [];

  Widget _amplitudeRecords() {
    List _list = _listAmplitude.reversed.toList();
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        controller: _scrollController,
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                height: _list[index] * 3,
                width: 2,
                color: Colors.black,
              ),
              SizedBox(
                width: 7,
                height: 2.5,
                child: Container(
                  color: Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Timer? _timerAmplitude;

  void _getAmplitude() {
    _timerAmplitude = Timer.periodic(
      const Duration(milliseconds: 80),
      (_) {
        double _dcb = db / 3;
        if (_dcb < 8.5) {
          _dcb = 1;
        }

        if (_listAmplitude.length > 38) {
          _listAmplitude.removeAt(0);
        }

        _listAmplitude.add(_dcb);
        setState(() {});
      },
    );
  }

  void _stopRecord() {
    _recorder.stopRecord(() {
      setState(() {});
    });
    recordSub?.cancel();

    _timerAmplitude!.cancel();

    _isRecorded = true;
    _isPlay = false;
  }

  void _play() async {
    await _recorder.play(() {
      setState(() {});
      _isPlay = false;
      sliderCurrentPosition = maxDuration;
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

  Future<void> _save(
    BuildContext context,
    int length,
  ) async {
    int? memory;
    final DocumentReference document =
        FirebaseFirestore.instance.collection('users').doc(LocalDB.uid);
    await document.get().then<dynamic>((
      DocumentSnapshot snapshot,
    ) async {
      dynamic data = snapshot.data;
      memory = data()['totalMemory'];
    });

    _recorder.uploadSound(
      'Аудиозапись ${length + 1}',
      _time,
      Timestamp.now(),
      memory!,
      MainPage.globalKey.currentContext!,
    );
    context.read<BlocIndex>().add(
          ColorHome(),
        );
    MainPage.globalKey.currentState!.pushReplacementNamed(
      HomePage.routName,
    );
  }
}
