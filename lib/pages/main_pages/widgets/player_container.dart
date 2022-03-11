import 'dart:async';
import 'dart:math';

import 'package:audio_stories/pages/main_pages/repositories/player_repository.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../resources/app_icons.dart';
import '../resources/thumb_shape.dart';

//ignore: must_be_immutable
class PlayerContainer extends StatefulWidget {
  Color color;
  String title;
  String url;

  PlayerContainer({
    Key? key,
    required this.color,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<PlayerContainer> createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer> {
  final PlayerRepository _player = PlayerRepository();
  bool _onChanged = false;
  bool _isPause = false;
  bool _isPlay = false;
  double val = 0.0;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  String _playTxt = '00:00';
  String _playTxtChange = '00:00';

  StreamSubscription? _playerSubscription;

  @override
  void initState() {
    super.initState();
    _player.openSession().then((value) {
      setState(() {});
    });
    _play(widget.url);
    _isPlay = true;
  }

  @override
  void dispose() {
    _playerSubscription?.cancel();
    _player.close();
    super.dispose();
  }

  void valuePlayer() {
    _playerSubscription = _player.onProgress!.listen((e) {
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

  void refreshTimer(double value) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
    String txt = DateFormat('mm:ss', 'en_GB').format(date);
    _playTxtChange = txt.substring(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    String icon = AppIcons.playRecord;
    if (_isPlay) {
      icon = _isPlay && _isPause ? AppIcons.playRecord : AppIcons.pauseRecord;
    } else {
      icon = AppIcons.playRecord;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      height: 70.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(41.0),
        border: Border.all(
          color: Colors.grey[400]!,
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                ),
                child: GestureDetector(
                  child: ColorFiltered(
                    child: Image.asset(
                      icon,
                      width: 58.0,
                      height: 58.0,
                    ),
                    colorFilter: ColorFilter.mode(
                      widget.color,
                      BlendMode.srcATop,
                    ),
                  ),
                  onTap: () {
                    if (_isPlay) _isPause ? _resumePlay() : _pausePlay();
                    if (!_isPlay) _play(widget.url);
                    refreshTimer(sliderCurrentPosition);
                    setState(() {});
                  },
                ),
              ),
              Column(
                children: [
                  Text(widget.title),
                  SfSlider(
                    value: _onChanged ? val : sliderCurrentPosition,
                    min: 0.0,
                    max: maxDuration,
                    thumbShape: ThumbShape(),
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> seek(int ms) async {
    await _player.seek(ms);
    setState(() {});
  }

  void _play(String url) async {
    await _player.play(url, () {
      setState(() {});
      _isPlay = false;
      sliderCurrentPosition = maxDuration;
    });
    valuePlayer();
    setState(() {});
    _isPlay = true;
  }

  void _pausePlay() {
    _player.pausePlayer(() {
      setState(() {});
    });
    _isPause = true;
  }

  void _resumePlay() {
    _player.resumePlayer(() {
      setState(() {});
    });
    _isPause = false;
  }
}
