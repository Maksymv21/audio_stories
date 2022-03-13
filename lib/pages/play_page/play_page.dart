import 'dart:async';
import 'dart:math';

import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../resources/app_icons.dart';
import '../../utils/local_db.dart';
import '../audio_pages/audio_page/audio_page.dart';
import '../category_pages/category_page/category_page.dart';
import '../home_pages/home_page/home_page.dart';
import '../main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import '../main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import '../main_pages/repositories/player_repository.dart';
import '../main_pages/resources/thumb_shape.dart';
import '../main_pages/widgets/popup_menu_sound_container.dart';

//ignore: must_be_immutable
class PlayPage extends StatefulWidget {
  static const routName = '/play';

  String? url;
  String? id;
  String? title;
  String? page;

  PlayPage({
    Key? key,
    this.url,
    this.id,
    this.title,
    this.page,
  }) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final PlayerRepository _player = PlayerRepository();
  StreamSubscription? _playerSubscription;
  double sliderCurrentPosition = 0.0;
  String _playTxt = '00:00';
  String _playTxtChange = '00:00';
  String _length = '00:00';
  bool _isPlay = false;
  bool _isPause = false;
  bool _onChanged = false;
  double val = 0.0;
  double maxDuration = 1.0;

  @override
  void initState() {
    super.initState();
    _player.openSession().then((value) {
      setState(() {});
    });
    _play(widget.url!);
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

      DateTime _date = DateTime.fromMillisecondsSinceEpoch(maxDuration.toInt());
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

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppIcons.up,
                child: Container(),
              ),
            ),
            const Spacer(),
          ],
        ),
        Align(
          alignment: const AlignmentDirectional(0.0, 1.1),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.96,
            height: MediaQuery.of(context).size.height * 0.86,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          onPressed: () {
                            MainPage.globalKey.currentState!
                                .pushReplacementNamed(widget.page!);
                            context.read<BlocIndex>().add(
                                  _bloc(widget.page!),
                                );
                          },
                          icon: Image.asset(
                            AppIcons.arrowCircle,
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 5,
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(LocalDB.uid)
                      .collection('sounds')
                      .doc(widget.id)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          image: DecorationImage(
                            image: Image.asset(
                              AppIcons.headphones,
                            ).image,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Название подборки',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              snapshot.data?.data()?['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.active,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Transform.scale(
                        scaleY: 0.8,
                        child: SfSlider(
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
                              _length.substring(0, 5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
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
                            if (_isPlay) {
                              _isPause ? _resumePlay() : _pausePlay();
                            }
                            if (!_isPlay) _play(widget.url!);
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
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(0.8, -0.9),
          child: PopupMenuSoundContainer(
            size: 50.0,
            url: widget.url!,
            id: widget.id!,
            title: widget.title!,
            page: widget.page!,
          ),
        ),
      ],
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

  IndexEvent _bloc(String page) {
    IndexEvent event;
    if (page == HomePage.routName) {
      event = ColorHome();
    } else if (page == CategoryPage.routName) {
      event = ColorCategory();
    } else if (page == AudioPage.routName) {
      event = ColorAudio();
    } else {
      event = NoColor();
    }
    return event;
  }
}