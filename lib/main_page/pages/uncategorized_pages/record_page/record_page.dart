import 'dart:async';
import 'dart:math';

import 'package:audio_stories/main_page/pages/uncategorized_pages/record_page/repository/record_repository.dart';
import 'package:audio_stories/main_page/widgets/uncategorized/sound_stream.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../../utils/local_db.dart';
import '../../../main_page.dart';
import '../../../resources/thumb_shape.dart';
import '../../../widgets/buttons/button_menu.dart';
import '../../sounds_contain_pages/home_page/home_page.dart';

class RecordPage extends StatefulWidget {
  static const routName = '/record';

  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final RecordRepository _recorder = RecordRepository();
  NoiseMeter _noiseReading = NoiseMeter();
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _playerSubscription;
  StreamSubscription? _recordSub;
  int _length = -1;

  String _recorderTxt = '00:00:00';
  String _playTxt = '00:00';
  String _playTxtChange = '00:00';
  String _title = 'Аудиозапись';

  bool _isRecorded = false;
  bool _isPlay = false;
  bool _isPause = false;
  bool _onChanged = false;
  bool _loading = false;

  double _val = 0.0;
  double _time = 0.0;
  double _sliderCurrentPosition = 0.0;
  double _maxDuration = 1.0;
  double _db = 0.0;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    _recorder.openSession().then((value) {
      _recorder.record(() {
        setState(() {});
      });
    });
    _openTheRecorder();
    _noise();
    _isPlay = true;
  }

  Future _openTheRecorder() async {
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
    _recordSub?.cancel();
    _playerSubscription?.cancel();
    super.dispose();
  }

  void _refreshTimer(double value) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
    String txt = DateFormat('mm:ss', 'en_GB').format(date);
    _playTxtChange = txt.substring(0, 5);
  }

  void _noise() {
    _recordSub = _noiseReading.noiseStream.listen((e) {
      setState(() {
        _db = e.maxDecibel;
      });
    });
  }

  void _valuePlayer() {
    _playerSubscription = _recorder.onProgressP!.listen((e) {
      _maxDuration = e.duration.inMilliseconds.toDouble();
      if (_maxDuration <= 0) _maxDuration = 0.0;

      _sliderCurrentPosition =
          min(e.position.inMilliseconds.toDouble(), _maxDuration);
      if (_sliderCurrentPosition < 0.0) {
        _sliderCurrentPosition = 0.0;
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

  Future<void> _create(AsyncSnapshot snapshot) async {
    if (_length == -1) {
      _title = 'Аудиозапись ${snapshot.data.docs.length + 1}';
      _length = snapshot.data.docs.length;
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {});
      });
    }
  }

  Future<void> _back15() async {
    _sliderCurrentPosition = _sliderCurrentPosition - 15000.0;
    if (_sliderCurrentPosition < 0.0) {
      _sliderCurrentPosition = 0.0;
    }
    _refreshTimer(_sliderCurrentPosition);
    await _seek(_sliderCurrentPosition.toInt());
    setState(() {});
  }

  void _playButton() {
    if (_isPlay) _isPause ? _resumePlay() : _pausePlay();
    if (!_isPlay) _play();
    _refreshTimer(_sliderCurrentPosition);
    setState(() {});
  }

  Future<void> _forward15() async {
    _sliderCurrentPosition += 15000.0;
    if (_sliderCurrentPosition > _maxDuration) {
      _sliderCurrentPosition = _maxDuration - 300;
    }
    _refreshTimer(_sliderCurrentPosition);
    await _seek(_sliderCurrentPosition.toInt());
    setState(() {});
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
            child: _AmplitudeRecords(
              db: _db,
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

    Widget childPlay = SoundStream(
      create: _create,
      child: Column(
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
                          _title,
                        )
                        .then(
                          (value) => GlobalRepo.showSnackBar(
                            context: context,
                            title: 'Файл сохранен.'
                                '\nDownload/$_title.aac',
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
                    if (FirebaseAuth.instance.currentUser == null) {
                      GlobalRepo.showSnackBar(
                        context: context,
                        title: 'Для сохранения аудио нужно зарегистрироваться',
                      );
                    } else {
                      _save(
                        context,
                        _length,
                      );
                    }
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
              _title,
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
                    value: _onChanged ? _val : _sliderCurrentPosition,
                    min: 0.0,
                    max: _maxDuration,
                    thumbShape: ThumbShape(
                      color: Colors.black,
                    ),
                    activeColor: Colors.black,
                    inactiveColor: Colors.black,
                    onChanged: (value) {
                      if (_isPause) {
                        _sliderCurrentPosition = value;
                      } else {
                        _val = value;
                      }
                      _refreshTimer(value);
                      _onChanged = true;
                    },
                    onChangeEnd: (value) async {
                      await _seek(value.toInt());
                      _val = _sliderCurrentPosition;
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
                        _onChanged || _isPause ? _playTxtChange : _playTxt,
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
                  onPressed: () => _back15(),
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
                  onTap: () => _playButton(),
                ),
                const SizedBox(
                  width: 50.0,
                ),
                IconButton(
                  onPressed: () => _forward15(),
                  icon: Image.asset(
                    AppIcons.forward15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Stack(
      children: [
        Column(
          children: const [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppImages.up,
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
                right: 10.0,
              ),
              child: _isRecorded ? childPlay : childRecord,
            ),
          ),
        ),
        Visibility(
          visible: _loading,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  void _stopRecord() {
    _recorder.stopRecord(() {
      setState(() {});
    });
    _recordSub?.cancel();

    _isRecorded = true;
    _isPlay = false;
  }

  void _play() async {
    await _recorder.play(() {
      setState(() {});
      _isPlay = false;
      _sliderCurrentPosition = _maxDuration;
    });
    _valuePlayer();
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

  Future<void> _seek(int ms) async {
    await _recorder.seek(ms);
    setState(() {});
  }

  Future<void> _save(
    BuildContext context,
    int? length,
  ) async {
    int? memory;
    final DocumentReference document =
        FirebaseFirestore.instance.collection('users').doc(LocalDB.uid);
    await document.get().then<dynamic>((
      DocumentSnapshot snapshot,
    ) async {
      dynamic data = snapshot.data;
      memory = data()['totalMemory'];
      memory ??= 0;
    });

    length ??= 0;

    _loading = true;
    setState(() {});

    await _recorder
        .uploadSound(
      'Аудиозапись ${length + 1}',
      _time,
      Timestamp.now(),
      memory!,
      MainPage.globalKey.currentContext!,
    )
        .then(
      (value) {
        context.read<BlocIndex>().add(
              ColorHome(),
            );
        MainPage.globalKey.currentState!.pushReplacementNamed(
          HomePage.routName,
        );
      },
    );
  }
}

class _AmplitudeRecords extends StatefulWidget {
  const _AmplitudeRecords({
    Key? key,
    required this.db,
  }) : super(key: key);
  final double db;

  @override
  State<_AmplitudeRecords> createState() => _AmplitudeRecordsState();
}

class _AmplitudeRecordsState extends State<_AmplitudeRecords> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timerAmplitude;
  final List _listAmplitude = [];

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    _getAmplitude();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timerAmplitude!.cancel();
    super.dispose();
  }

  void _getAmplitude() {
    _timerAmplitude = Timer.periodic(
      const Duration(milliseconds: 80),
      (_) {
        double _dcb = widget.db / 3;
        if (_dcb < 10) {
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

  @override
  Widget build(BuildContext context) {
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
}
