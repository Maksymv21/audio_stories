import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

var themeNotifier = ValueNotifier<ThemeVariation>(
  const ThemeVariation(Colors.blue, Brightness.light),
);

class ThemeVariation {
  const ThemeVariation(this.color, this.brightness);
  final MaterialColor color;
  final Brightness brightness;
}

class TestPage extends StatefulWidget {
  static const routName = '/test';
  TestPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late AudioPlayer _player;
  final url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
  late Stream<DurationState> _durationState;
  var _isShowingWidgetOutline = false;
  var _labelLocation = TimeLabelLocation.below;
  var _labelType = TimeLabelType.totalTime;
  TextStyle? _labelStyle;
  var _thumbRadius = 10.0;
  var _labelPadding = 0.0;
  var _barHeight = 5.0;
  var _barCapShape = BarCapShape.round;
  Color? _baseBarColor;
  Color? _progressBarColor;
  Color? _bufferedBarColor;
  Color? _thumbColor;
  Color? _thumbGlowColor;
  var _thumbCanPaintOutsideBar = true;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        _player.positionStream,
        _player.playbackEventStream,
            (position, playbackEvent) => DurationState(
          progress: position,
          buffered: playbackEvent.bufferedPosition,
          total: playbackEvent.duration,
        ));
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(url);
    } catch (e) {
      debugPrint('An error occured $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _themeButtons(),
                    _widgetSizeButtons(),
                    const SizedBox(height: 20),
                    const Text(
                      '------- Labels -------',
                      style: TextStyle(fontSize: 20),
                    ),
                    _labelLocationButtons(),
                    _labelTypeButtons(),
                    _labelSizeButtons(),
                    _paddingSizeButtons(),
                    const SizedBox(height: 20),
                    const Text(
                      '------- Bar -------',
                      style: TextStyle(fontSize: 20),
                    ),
                    _barColorButtons(),
                    _barCapShapeButtons(),
                    _barHeightButtons(),
                    _thumbSizeButtons(),
                    _thumbOutsideBarButtons(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: _widgetBorder(),
                child: _progressBar(),
              ),
              const SizedBox(height: 20),
              _playButton(),
            ],
          ),
        ),
      ),
    );
  }

  Wrap _themeButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('light'),
        onPressed: () {
          themeNotifier.value =
          const ThemeVariation(Colors.blue, Brightness.light);
        },
      ),
      OutlinedButton(
        child: const Text('dark'),
        onPressed: () {
          themeNotifier.value =
          const ThemeVariation(Colors.blue, Brightness.dark);
        },
      ),
    ]);
  }

  Wrap _widgetSizeButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('hide widget size'),
        onPressed: () {
          setState(() => _isShowingWidgetOutline = false);
        },
      ),
      OutlinedButton(
        child: const Text('show'),
        onPressed: () {
          setState(() => _isShowingWidgetOutline = true);
        },
      ),
    ]);
  }

  BoxDecoration _widgetBorder() {
    return BoxDecoration(
      border: _isShowingWidgetOutline
          ? Border.all(color: Colors.red)
          : Border.all(color: Colors.transparent),
    );
  }

  Wrap _labelLocationButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('below'),
        onPressed: () {
          setState(() => _labelLocation = TimeLabelLocation.below);
        },
      ),
      OutlinedButton(
        child: const Text('above'),
        onPressed: () {
          setState(() => _labelLocation = TimeLabelLocation.above);
        },
      ),
      OutlinedButton(
        child: const Text('sides'),
        onPressed: () {
          setState(() => _labelLocation = TimeLabelLocation.sides);
        },
      ),
      OutlinedButton(
        child: const Text('none'),
        onPressed: () {
          setState(() => _labelLocation = TimeLabelLocation.none);
        },
      ),
    ]);
  }

  Wrap _labelTypeButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('total time'),
        onPressed: () {
          setState(() => _labelType = TimeLabelType.totalTime);
        },
      ),
      OutlinedButton(
        child: const Text('remaining time'),
        onPressed: () {
          setState(() => _labelType = TimeLabelType.remainingTime);
        },
      ),
    ]);
  }

  Wrap _labelSizeButtons() {
    final fontColor = Theme.of(context).textTheme.bodyText1?.color;
    return Wrap(children: [
      OutlinedButton(
        child: const Text('standard font size'),
        onPressed: () {
          setState(() => _labelStyle = null);
        },
      ),
      OutlinedButton(
        child: const Text('large'),
        onPressed: () {
          setState(
                  () => _labelStyle = TextStyle(fontSize: 40, color: fontColor));
        },
      ),
      OutlinedButton(
        child: const Text('small'),
        onPressed: () {
          setState(
                  () => _labelStyle = TextStyle(fontSize: 8, color: fontColor));
        },
      ),
    ]);
  }

  Wrap _thumbSizeButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('standard thumb radius'),
        onPressed: () {
          setState(() => _thumbRadius = 10);
        },
      ),
      OutlinedButton(
        child: const Text('large'),
        onPressed: () {
          setState(() => _thumbRadius = 20);
        },
      ),
      OutlinedButton(
        child: const Text('small'),
        onPressed: () {
          setState(() => _thumbRadius = 5);
        },
      ),
    ]);
  }

  Wrap _paddingSizeButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('standard padding'),
        onPressed: () {
          setState(() => _labelPadding = 0.0);
        },
      ),
      OutlinedButton(
        child: const Text('10 padding'),
        onPressed: () {
          setState(() => _labelPadding = 10);
        },
      ),
      OutlinedButton(
        child: const Text('-5 padding'),
        onPressed: () {
          setState(() => _labelPadding = -5);
        },
      ),
    ]);
  }

  Wrap _barHeightButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('standard bar height'),
        onPressed: () {
          setState(() => _barHeight = 5.0);
        },
      ),
      OutlinedButton(
        child: const Text('thin'),
        onPressed: () {
          setState(() => _barHeight = 1.0);
        },
      ),
      OutlinedButton(
        child: const Text('thick'),
        onPressed: () {
          setState(() => _barHeight = 20.0);
        },
      ),
    ]);
  }

  Wrap _barCapShapeButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('round caps'),
        onPressed: () {
          setState(() => _barCapShape = BarCapShape.round);
        },
      ),
      OutlinedButton(
        child: const Text('square'),
        onPressed: () {
          setState(() => _barCapShape = BarCapShape.square);
        },
      ),
    ]);
  }

  Wrap _barColorButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('theme colors'),
        onPressed: () {
          setState(() {
            _baseBarColor = null;
            _progressBarColor = null;
            _bufferedBarColor = null;
            _thumbColor = null;
            _thumbGlowColor = null;
          });
        },
      ),
      OutlinedButton(
        child: const Text('custom'),
        onPressed: () {
          setState(() {
            _baseBarColor = Colors.grey.withOpacity(0.2);
            _progressBarColor = Colors.green;
            _bufferedBarColor = Colors.grey.withOpacity(0.2);
            _thumbColor = Colors.purple;
            _thumbGlowColor = Colors.green.withOpacity(0.3);
          });
        },
      ),
    ]);
  }

  Wrap _thumbOutsideBarButtons() {
    return Wrap(children: [
      OutlinedButton(
        child: const Text('thumb can paint outside bar'),
        onPressed: () {
          setState(() => _thumbCanPaintOutsideBar = true);
        },
      ),
      OutlinedButton(
        child: const Text('false'),
        onPressed: () {
          setState(() => _thumbCanPaintOutsideBar = false);
        },
      ),
    ]);
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _durationState,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: (duration) {
            _player.seek(duration);
          },
          onDragUpdate: (details) {
            debugPrint('${details.timeStamp}, ${details.localPosition}');
          },
          barHeight: _barHeight,
          baseBarColor: _baseBarColor,
          progressBarColor: _progressBarColor,
          bufferedBarColor: _bufferedBarColor,
          thumbColor: _thumbColor,
          thumbGlowColor: _thumbGlowColor,
          barCapShape: _barCapShape,
          thumbRadius: _thumbRadius,
          thumbCanPaintOutsideBar: _thumbCanPaintOutsideBar,
          timeLabelLocation: _labelLocation,
          timeLabelType: _labelType,
          timeLabelTextStyle: _labelStyle,
          timeLabelPadding: _labelPadding,
        );
      },
    );
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 32.0,
            height: 32.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 32.0,
            onPressed: _player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 32.0,
            onPressed: _player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 32.0,
            onPressed: () => _player.seek(Duration.zero),
          );
        }
      },
    );
  }
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
