import 'dart:async';

import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/button_menu.dart';
import 'package:audio_stories/pages/record_page/repository/record_repository.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

class RecordPage extends StatefulWidget {
  static const routName = '/record';

  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final RecordRepository _recorder = RecordRepository();
  String _recorderTxt = '00:00:00';
  bool _isRecorder = false;
  bool _isPlayer = false;
  bool _isPlay = false;

  @override
  void initState() {
    super.initState();
    _recorder
      ..openSession()
      ..openTheRecorder().then((value) {
        _recorder.record(() {
          setState(() {});
        });
      });

    startTimer();
    _isPlay = true;
  }

  @override
  void dispose() {
    _recorder.close();

    super.dispose();
  }

  void startTimer() async {
    StreamSubscription _recorderSubscription =
        _recorder.onProgress!.listen((e) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          e.duration.inMilliseconds,
          isUtc: true);
      String txt = DateFormat('HH:mm:ss', 'en_GB').format(date);

      setState(() {
        _recorderTxt = txt.substring(0, 8);
      });
    });
    // _recorderSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String icon = _isPlay ? AppIcons.pauseRecord : AppIcons.playRecord;

    Widget child = Column(
      children: [
        const Spacer(
          flex: 8,
        ),
        Text(_recorderTxt),
        Expanded(
          flex: 3,
          child: BlocBuilder<BlocIndex, int>(
            builder: (context, index) => GestureDetector(
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
                if (!_isRecorder) {
                  _stopRecord();
                  context.read<BlocIndex>().add(
                    ColorPlay(),
                  );
                } else {
                  _isPlayer ? _stopPlay() : _play();
                }
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );

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
              child: child,
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
    _isRecorder = true;
    _isPlay = false;
  }

  void _play() {
    _recorder.play(() {
      setState(() {});
      _isPlayer = false;
      _isPlay = false;
    });

    _isPlayer = true;
    _isPlay = true;
  }

  void _stopPlay() {
    _recorder.stopPlayer(() {
      setState(() {});
    });
    _isPlayer = false;
    _isPlay = false;
  }
}
