import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../resources/app_icons.dart';
import '../../repositories/player_repository.dart';
import '../../resources/thumb_shape.dart';

//ignore: must_be_immutable
class PlayerContainer extends StatefulWidget {
  PlayerContainer({
    Key? key,
    required this.url,
    required this.title,
    required this.id,
    this.onPressed,
    this.whenComplete,
  }) : super(key: key);

  String title;
  String url;
  String id;
  void Function()? onPressed;
  void Function()? whenComplete;

  @override
  State<PlayerContainer> createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer> {
  final PlayerRepository _player = PlayerRepository();
  bool _onChanged = false;
  bool _isPause = false;
  bool _isPlay = false;
  bool _isFinish = false;
  double val = 0.0;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  String _playTxt = '00:00';
  String _playTxtChange = '00:00';
  String _length = '00:00';

  StreamSubscription? _playerSubscription;

  @override
  void initState() {
    super.initState();
    _player.openSession().then((value) {
      setState(() {});
    }).whenComplete(
      () => _play(widget.url),
    );
    _isPlay = true;
  }

  @override
  void dispose() {
    _playerSubscription?.cancel();
    _player.close();
    super.dispose();
  }

  void _valuePlayer() {
    _playerSubscription = _player.onProgress!.listen((e) {
      maxDuration = e.duration.inMilliseconds.toDouble();
      if (maxDuration <= 0) maxDuration = 0.0;

      DateTime _date = DateTime.fromMillisecondsSinceEpoch(
        maxDuration.toInt(),
      );
      _length = DateFormat('mm:ss', 'en_GB').format(_date);

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

      if (maxDuration - sliderCurrentPosition <= 50.0 && !_isFinish) {
        if (widget.whenComplete != null) {
          widget.whenComplete!();
          _isFinish = true;
        }
      }
    });
  }

  void _refreshTimer(double value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      value.toInt(),
      isUtc: true,
    );
    String txt = DateFormat('mm:ss', 'en_GB').format(date);
    _playTxtChange = txt.substring(0, 5);
  }

  void _playButton() {
    if (_isPlay) _isPause ? _resumePlay() : _pausePlay();
    if (!_isPlay) _play(widget.url);
    _refreshTimer(sliderCurrentPosition);
    setState(() {});
  }

  void _onChangedSlider(double value) {
    if (_isPause) {
      sliderCurrentPosition = value;
    } else {
      val = value;
    }
    _refreshTimer(value);
    _onChanged = true;
  }

  Future<void> _onChangedEndSlider(double value) async {
    await seek(value.toInt());
    val = sliderCurrentPosition;
    _onChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    String icon = AppIcons.playRecord;
    if (_isPlay) {
      icon = _isPlay && _isPause ? AppIcons.playRecord : AppIcons.pauseRecord;
    } else {
      icon = AppIcons.playRecord;
    }
    final double _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width * 0.95,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xff8C84E2),
            Color(0xff6C689F),
          ],
        ),
        borderRadius: BorderRadius.circular(41.0),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 13.0,
                ),
                child: GestureDetector(
                  child: ColorFiltered(
                    child: Image.asset(
                      icon,
                      width: 55.0,
                      height: 55.0,
                    ),
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcATop,
                    ),
                  ),
                  onTap: () => _playButton(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 19.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(
                        0.0,
                        -0.5,
                      ),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 10.0,
                      ),
                      child: Transform.scale(
                        scaleY: 0.6,
                        scaleX: _width * 0.0038,
                        child: SfSliderTheme(
                          data: SfSliderThemeData(
                            thumbColor: Colors.white,
                          ),
                          child: SfSlider(
                            value: _onChanged ? val : sliderCurrentPosition,
                            min: 0.0,
                            max: maxDuration,
                            thumbShape: ThumbShape(
                              color: Colors.white,
                            ),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            onChanged: (value) => _onChangedSlider(value),
                            onChangeEnd: (value) => _onChangedEndSlider(value),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.6),
                      child: Text(
                        _onChanged || _isPause ? _playTxtChange : _playTxt,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.6),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 175.0),
                        child: Text(
                          _length.substring(0, 5),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: IconButton(
                  onPressed: widget.onPressed,
                  icon: const Icon(
                    Icons.keyboard_arrow_up,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
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

    setState(() {
      _valuePlayer();
    });
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
