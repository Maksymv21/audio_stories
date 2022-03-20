import 'dart:io';
import 'dart:math';

import 'package:audio_stories/pages/compilation_pages/compilation_create_page/compilation_create_bloc/add_in_compilation_bloc.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_create_page/create_compilation_page.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_bloc/compilation_current_bloc.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_bloc/compilation_current_state.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../resources/app_color.dart';
import '../../../resources/app_icons.dart';
import '../../../utils/local_db.dart';
import '../../../widgets/background.dart';
import '../../main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import '../../main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import '../../main_pages/main_page/main_page.dart';
import '../../main_pages/widgets/player_container.dart';
import '../../main_pages/widgets/popup_menu_sound_container.dart';
import '../../main_pages/widgets/sound_container.dart';
import '../../play_page/play_page.dart';
import '../compilation_create_page/compilation_create_bloc/add_in_compilation_event.dart';
import '../compilation_page/compilation_bloc/compilation_bloc.dart';
import '../compilation_page/compilation_bloc/compilation_event.dart';
import '../compilation_page/compilation_page.dart';

class CurrentCompilationPage extends StatefulWidget {
  static const routName = '/currentCompilation';

  const CurrentCompilationPage({Key? key}) : super(key: key);

  @override
  State<CurrentCompilationPage> createState() => _CurrentCompilationPageState();
}

class _CurrentCompilationPageState extends State<CurrentCompilationPage> {
  List<bool> current = [];
  List<String> listTitle = [];
  List<String> listUrl = [];
  List<double> listTime = [];
  double _bottom = 0.0;
  Widget _player = const Text('');
  bool _readMore = false;
  bool _playAll = false;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return BlocBuilder<CompilationCurrentBloc, CompilationCurrentState>(
        builder: (context, state) {
      if (state is OnCurrentCompilation) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Background(
                    image: AppIcons.upGreen,
                    height: 325.0,
                    child: Align(
                      alignment: const AlignmentDirectional(-1.1, -0.9),
                      child: IconButton(
                        onPressed: () {
                          MainPage.globalKey.currentState!
                              .pushReplacementNamed(CompilationPage.routName);
                        },
                        icon: Image.asset(AppIcons.back),
                        iconSize: 60.0,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            Align(
              alignment: const AlignmentDirectional(0.95, -0.95),
              child: _popupMenu(state),
            ),
            Column(
              children: [
                const Spacer(
                  flex: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: _width * 0.05,
                    bottom: _height * 0.01,
                  ),
                  child: Row(
                    children: [
                      Text(
                        state.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                _imageContainer(_width, _height, state),
                Expanded(
                  flex: _readMore ? 3 : 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: _width * 0.07,
                      right: _width * 0.07,
                    ),
                    child: Column(
                      children: [
                        Flexible(
                          child: _readMore
                              ? ListView(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  children: [
                                    Text(
                                      state.text,
                                    ),
                                  ],
                                )
                              : Text(
                                  state.text,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                _readMore
                    ? const SizedBox()
                    : Expanded(
                        child: TextButton(
                          child: const Text(
                            'Подробнее',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _readMore = true;
                            });
                          },
                        ),
                      ),
                Expanded(
                  flex: _readMore ? 3 : 4,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: _bottom),
                    child: _soundList(state.listId, state.id),
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: _player,
            ),
          ],
        );
      } else {
        return const Center(
          child: Text('Произошла ошибка'),
        );
      }
    });
  }

  Widget _imageContainer(
    double width,
    double height,
    OnCurrentCompilation state,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: [
          Container(
            width: width * 0.9,
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: Image.network(state.url).image,
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
            width: width * 0.9,
            height: height * 0.3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xff454545),
                ],
                stops: [0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(-0.85, -0.9),
                  child: Text(
                    _convertDate(state.date),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.85, 0.9),
                  child: Text(
                    '${state.listId.length} аудио'
                    '\n0 часов',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.85, 0.85),
                  child: Stack(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.7),
                          minimumSize: const Size(168.0, 46.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {
                          if (!current.contains(true)) {
                            setState(() {
                              _playAll = !_playAll;
                              _player = _next(
                                index: 0,
                                listUrl: listUrl,
                                listTitle: listTitle,
                                listId: state.listId,
                              );
                            });
                          } else {
                            setState(() {
                              _playAll = !_playAll;
                              _player = const Text('');
                              _bottom = 10.0;
                              for (int i = 0; i < current.length; i++) {
                                current[i] = false;
                              }
                            });
                          }
                        },
                        child: Align(
                          widthFactor: 0.6,
                          heightFactor: 0.0,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            _playAll ? 'Остановить' : 'Запустить все',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontFamily: 'TTNormsL',
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: ColorFiltered(
                          child: IconButton(
                            onPressed: () {
                              if (!current.contains(true)) {
                                setState(() {
                                  _playAll = !_playAll;
                                  _player = _next(
                                    index: 0,
                                    listUrl: listUrl,
                                    listTitle: listTitle,
                                    listId: state.listId,
                                  );
                                });
                              } else {
                                setState(() {
                                  _playAll = !_playAll;
                                  _player = const Text('');
                                  _bottom = 10.0;
                                  for (int i = 0; i < current.length; i++) {
                                    current[i] = false;
                                  }
                                });
                              }
                            },
                            icon: Image.asset(
                              _playAll ? AppIcons.pauseRecord : AppIcons.play,
                            ),
                          ),
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcATop,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _soundList(List listId, String id) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('sounds')
          .where('deleted', isEqualTo: false)
          .orderBy(
            'date',
            descending: true,
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _createLists(snapshot, listId.length);

          if (listTitle.isEmpty) {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              for (int j = 0; j < listId.length; j++) {
                if (snapshot.data.docs[i].id == listId[j]) {
                  listTitle.add(snapshot.data.docs[i]['title']);
                  listUrl.add(snapshot.data.docs[i]['song']);
                  listTime.add(snapshot.data.docs[i]['time']);
                }
              }
            }
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: listId.length,
            itemBuilder: (context, index) {
              for (int i = 0; i < snapshot.data.docs.length; i++) {
                if (snapshot.data.docs[i].id == listId[index]) {
                  listTitle[index] = snapshot.data.docs[i]['title'];
                }
              }
              Color color =
                  current[index] ? const Color(0xffF1B488) : AppColor.active;

              return Column(
                children: [
                  SoundContainer(
                    color: color,
                    title: listTitle[index],
                    time: (listTime[index] / 60).toStringAsFixed(1),
                    onTap: () {
                      if (!current[index]) {
                        for (int i = 0; i < listId.length; i++) {
                          current[i] = false;
                        }
                        setState(() {
                          _player = const Text('');
                          _bottom = 90.0;
                        });

                        Future.delayed(const Duration(milliseconds: 50), () {
                          setState(() {
                            current[index] = true;
                            _player = Dismissible(
                              key: const Key(''),
                              direction: DismissDirection.down,
                              onDismissed: (direction) {
                                setState(() {
                                  _player = const Text('');
                                  _bottom = 10.0;
                                  current[index] = false;
                                });
                              },
                              child: PlayerContainer(
                                title: listTitle[index],
                                url: listUrl[index],
                                id: listId[index],
                                onPressed: () {
                                  _toPlayPage(
                                    listUrl[index],
                                    listTitle[index],
                                    listId[index],
                                  );
                                },
                              ),
                            );
                          });
                        });
                      }
                    },
                    buttonRight: Align(
                      alignment: const AlignmentDirectional(0.9, -1.0),
                      child: PopupMenuSoundContainer(
                        size: 30.0,
                        title: listTitle[index],
                        id: listId[index],
                        url: listUrl[index],
                        onDelete: () {
                          listTitle.removeAt(index);
                          listUrl.removeAt(index);
                          listTime.removeAt(index);
                          listId.removeAt(index);
                          Database.deleteSoundInCompilation(
                            {'sounds': listId},
                            id,
                          );
                          current.removeAt(index);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _next({
    required int index,
    required List<String> listTitle,
    required List<String> listUrl,
    required List listId,
  }) {
    final String title = listTitle[index];
    final String url = listUrl[index];
    final String id = listId[index];
    setState(() {
      current[index] = true;
    });

    return Dismissible(
      key: const Key(''),
      direction: DismissDirection.down,
      onDismissed: (direction) {
        setState(() {
          _player = const Text('');
          _bottom = 10.0;
          current[index] = false;
        });
      },
      child: PlayerContainer(
        title: title,
        url: url,
        id: id,
        onPressed: () => _toPlayPage(
          url,
          title,
          id,
        ),
        whenComplete: () {
          if (index + 1 < listId.length) {
            setState(() {
              _player = const Text('');
              current[index] = false;
            });
            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() {
                _player = _next(
                  index: index + 1,
                  listId: listId,
                  listTitle: listTitle,
                  listUrl: listUrl,
                );
              });
            });
          }
        },
      ),
    );
  }

  Widget _popupMenu(OnCurrentCompilation state) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) async {
        if (value == 0) {

          MainPage.globalKey.currentState!
              .pushReplacementNamed(CreateCompilationPage.routName);
          context.read<AddInCompilationBloc>().add(
                ToCreate(
                  listId: state.listId,
                  text: state.text,
                  title: state.title,
                  url: state.url,
                  id: state.id,
                ),
              );
        }
        if (value == 2) {
          Database.deleteCompilation({
            'id': state.id,
            'title': state.title,
            'date': state.date,
          });
          MainPage.globalKey.currentState!
              .pushReplacementNamed(CompilationPage.routName);
          context.read<CompilationBloc>().add(
                ToInitialCompilation(),
              );
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 0,
          child: Text(
            'Редактировать',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            'Выбрать несколько',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            'Удалить подборку',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            'Поделиться',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ],
      child: const Text(
        '...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          letterSpacing: 3.0,
        ),
      ),
    );
  }

  Future<File> urlToFile(String imageUrl) async {
    final Random rng = Random();

    final Directory tempDir = await getTemporaryDirectory();

    final String tempPath = tempDir.path;

    final File file = File(tempPath + (rng.nextInt(100)).toString() + '.png');
    Uri uri = Uri.parse(imageUrl);
    print(uri);
    http.Response response = await http.get(uri);

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  void _createLists(AsyncSnapshot snapshot, int length) {
    if (current.isEmpty) {
      for (int i = 0; i < length; i++) {
        current.add(false);
      }
    }
    if (current.length < length) {
      current = List.from(current.reversed);
      current.add(false);
      current = List.from(current.reversed);
    }
  }

  void _toPlayPage(
    String url,
    String title,
    String id,
  ) {
    setState(() {
      _player = const Text('');
    });
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PlayPage(
          url: url,
          title: title,
          id: id,
          page: CurrentCompilationPage.routName,
        ),
      ),
    );
    context.read<BlocIndex>().add(
          NoColor(),
        );
  }

  String _convertDate(Timestamp date) {
    final String dateTime = date.toDate().toString();
    final String result = dateTime.substring(8, 10) +
        '.' +
        dateTime.substring(5, 7) +
        '.' +
        dateTime.substring(2, 4);
    return result;
  }
}
