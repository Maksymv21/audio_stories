import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_bloc/compilation_current_bloc.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_bloc/compilation_current_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../compilation_page/compilation_page.dart';

class CurrentCompilationPage extends StatefulWidget {
  static const routName = '/currentCompilation';

  const CurrentCompilationPage({Key? key}) : super(key: key);

  @override
  State<CurrentCompilationPage> createState() => _CurrentCompilationPageState();
}

class _CurrentCompilationPageState extends State<CurrentCompilationPage> {
  List<bool> current = [];
  double _bottom = 0.0;
  Widget _player = const Text('');
  bool _readMore = false;

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
              child: TextButton(
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {},
                child: const Text(
                  '...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    letterSpacing: 3.0,
                  ),
                ),
              ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    width: _width * 0.9,
                    height: _height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        colorFilter: const ColorFilter.srgbToLinearGamma(),
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
                    child: Stack(),
                  ),
                ),
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
                    child: _soundList(state.listId),
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

  Widget _soundList(List listId) {
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

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: listId.length,
            itemBuilder: (context, index) {
              String? title;
              String? url;
              String? id;
              double? time;
              for (int i = 0; i < snapshot.data.docs.length; i++) {
                if (snapshot.data.docs[i].id == listId[index]) {
                  title = snapshot.data.docs[i]['title'];
                  time = snapshot.data.docs[i]['time'];
                  url = snapshot.data.docs[i]['song'];
                  id = snapshot.data.docs[i].id;
                }
              }
              return Column(
                children: [
                  SoundContainer(
                    color: AppColor.active,
                    title: title!,
                    time: (time! / 60).toStringAsFixed(1),
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
                                title: title!,
                                url: url!,
                                id: id!,
                                onPressed: () {
                                  _toPlayPage(url!, title!, id!);
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
                        title: title,
                        id: id!,
                        url: url!,
                        onDelete: () {

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
}
