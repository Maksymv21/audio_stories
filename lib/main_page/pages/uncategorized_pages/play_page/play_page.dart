import 'dart:async';
import 'dart:math';

import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../../resources/app_icons.dart';
import '../../../../utils/local_db.dart';
import '../../../main_page.dart';
import '../../../repositories/player_repository.dart';
import '../../../resources/thumb_shape.dart';
import '../../../widgets/menu/popup_menu_sound_container.dart';
import '../../compilation_pages/compilation_create_page/compilation_search_page.dart';
import '../../compilation_pages/compilation_current_page/compilation_current_page.dart';
import '../../compilation_pages/compilation_page/compilation_page.dart';
import '../../compilation_pages/pick_few_compilation_page/pick_few_compilation_page.dart';
import '../../sounds_contain_pages/audio_page/audio_page.dart';
import '../../sounds_contain_pages/home_page/home_page.dart';

class PlayPageArguments {
  PlayPageArguments({
    required this.title,
    required this.url,
    required this.page,
    required this.id,
  });

  final String title;
  final String url;
  final String page;
  final String id;
}

class PlayPage extends StatefulWidget {
  static const routName = '/play';

  PlayPage({
    Key? key,
    required this.title,
    required this.url,
    required this.page,
    required this.id,
  }) : super(key: key);

  final String title;
  final String url;
  final String page;
  final String id;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final PlayerRepository _player = PlayerRepository();
  List<String?> compilation = [];
  StreamSubscription? _playerSubscription;

  String _title = '';
  String _playTxt = '00:00';
  String _playTxtChange = '00:00';
  String _length = '00:00';

  bool _isPlay = false;
  bool _isPause = false;
  bool _onChanged = false;

  double val = 0.0;
  double maxDuration = 1.0;
  double sliderCurrentPosition = 0.0;

  ImageProvider _image = Image.asset(
    AppImages.headphones,
  ).image;
  String _compTitle = 'Название подборки';

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
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

  void _valuePlayer() {
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

  void _refreshTimer(double value) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
    String txt = DateFormat('mm:ss', 'en_GB').format(date);
    _playTxtChange = txt.substring(0, 5);
  }

  void _back(BuildContext context) {
    if (widget.page == PickFewCompilationPage.routName ||
        widget.page == CurrentCompilationPage.routName) {
      Navigator.of(context).pop();
      context.read<BlocIndex>().add(
            ColorCategory(),
          );
    } else {
      MainPage.globalKey.currentState!.pushReplacementNamed(widget.page);
      context.read<BlocIndex>().add(
            _bloc(widget.page),
          );
    }
  }

  Future<void> _back15() async {
    sliderCurrentPosition = sliderCurrentPosition - 15000.0;
    if (sliderCurrentPosition < 0.0) {
      sliderCurrentPosition = 0.0;
    }
    _refreshTimer(sliderCurrentPosition);
    await _seek(sliderCurrentPosition.toInt());
    setState(() {});
  }

  void _playButton() {
    if (_isPlay) {
      _isPause ? _resumePlay() : _pausePlay();
    }
    if (!_isPlay) _play(widget.url);
    _refreshTimer(sliderCurrentPosition);
    setState(() {});
  }

  Future<void> _forward15() async {
    sliderCurrentPosition += 15000.0;
    if (sliderCurrentPosition > maxDuration) {
      sliderCurrentPosition = maxDuration - 300;
    }
    _refreshTimer(sliderCurrentPosition);
    await _seek(sliderCurrentPosition.toInt());
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

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppImages.up,
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
                          onPressed: () => _back(context),
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
                _SoundStream(
                  id: widget.id,
                  create: _compilation,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          image: DecorationImage(
                            image: _image,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0xff454545),
                            ],
                            stops: [0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _compTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              _title == '' ? widget.title : _title,
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
                      ),
                    ],
                  ),
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
                            _refreshTimer(value);
                            _onChanged = true;
                          },
                          onChangeEnd: (value) async {
                            await _seek(value.toInt());
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
            url: widget.url,
            id: widget.id,
            title: widget.title,
            page: widget.page,
            onRename: (title) {
              _title = title;
            },
            playPage: true,
          ),
        ),
      ],
    );
  }

  Future<void> _seek(int ms) async {
    await _player.seek(ms);
    setState(() {});
  }

  void _play(String url) async {
    await _player.play(url, () {
      setState(() {});
      _isPlay = false;
      sliderCurrentPosition = maxDuration;
    });
    _valuePlayer();
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

  void _compilation(AsyncSnapshot snapshot) {
    if (snapshot.data.data()['compilations'] != null &&
        !snapshot.data.data()['compilations'].isEmpty) {
      final List compilations = snapshot.data.data()['compilations'];
      final DocumentReference documentCompilation = FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('compilations')
          .doc(compilations[compilations.length - 1]);
      documentCompilation.get().then<dynamic>((
        DocumentSnapshot snapshot,
      ) {
        dynamic data = snapshot.data;

        compilation
          ..add(data()['image'])
          ..add(data()['title']);
      });
    }

    _image = compilation.isEmpty
        ? Image.asset(
            AppImages.headphones,
          ).image
        : Image.network(compilation[0]!).image;
    _compTitle = compilation.isEmpty ? 'Название подборки' : compilation[1]!;
  }

  IndexEvent _bloc(String page) {
    IndexEvent event;
    if (page == HomePage.routName) {
      event = ColorHome();
    } else if (page == CompilationPage.routName ||
        page == CompilationSearchPage.routName ||
        page == CurrentCompilationPage.routName ||
        page == PickFewCompilationPage.routName) {
      event = ColorCategory();
    } else if (page == AudioPage.routName) {
      event = ColorAudio();
    } else {
      event = NoColor();
    }
    return event;
  }
}

class _SoundStream extends StatelessWidget {
  const _SoundStream({
    Key? key,
    required this.id,
    required this.create,
    required this.child,
  }) : super(key: key);

  final String id;
  final void Function(AsyncSnapshot) create;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('sounds')
          .doc(id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          create(snapshot);
          return child;
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
    );
  }
}
