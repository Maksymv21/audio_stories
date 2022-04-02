import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../../utils/local_db.dart';
import '../../../main_page.dart';
import '../../../widgets/buttons/button_menu.dart';
import '../../../widgets/uncategorized/compilation_container.dart';
import '../../../widgets/uncategorized/custom_player.dart';
import '../../../widgets/menu/popup_menu_sound_container.dart';
import '../../../widgets/uncategorized/sound_container.dart';
import '../../compilation_pages/compilation_current_page/compilation_current_page.dart';
import '../../compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../../compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../../compilation_pages/compilation_page/compilation_page.dart';
import 'home_widgets/open_all_button.dart';


class HomePage extends StatefulWidget {
  static const routName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _bottom = 10.0;
  List<bool> current = [];

  @override
  void initState() {
    permission();
    super.initState();
  }

  Future permission() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    Permission.microphone.request();
  }

  Widget _player = const Text('');

  @override
  Widget build(BuildContext context) {
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
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(LocalDB.uid)
                .collection('compilations')
                .orderBy(
                  'date',
                  descending: true,
                )
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget _firstContainer;
              Widget _secondContainer;
              Widget _thirdContainer;

              if (snapshot.hasData) {
                final int _length = snapshot.data.docs.length;

                _firstContainer = Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color.fromRGBO(113, 165, 159, 0.75),
                  ),
                  child: Column(
                    children: [
                      const Spacer(
                        flex: 2,
                      ),
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Здесь будет'
                          '\nтвой набор '
                          '\nсказок',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 3,
                        child: TextButton(
                          style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {
                            MainPage.globalKey.currentState!
                                .pushReplacementNamed(CompilationPage.routName);
                            context.read<BlocIndex>().add(
                                  ColorCategory(),
                                );
                            context.read<CompilationBloc>().add(
                                  ToInitialCompilation(),
                                );
                          },
                          child: const Text(
                            'Добавить',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                );

                _secondContainer = Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color(0xffF1B488),
                  ),
                  child: const Center(
                    child: Text(
                      'Тут',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );

                _thirdContainer = Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color.fromRGBO(103, 139, 210, 0.75),
                  ),

                  //color: const Color.fromRGBO(113, 165, 159, 0.75),
                  child: const Center(
                    child: Text(
                      'И тут',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );

                if (FirebaseAuth.instance.currentUser != null) {
                  if (_length > 0) {
                    _firstContainer = _compilationContainer(snapshot, 0);
                    if (_length > 1) {
                      _secondContainer = _compilationContainer(snapshot, 1);
                      if (_length > 2) {
                        _thirdContainer = _compilationContainer(snapshot, 2);
                      }
                    }
                  }
                }

                return Column(
                  children: [
                    const Spacer(
                      flex: 4,
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          const Spacer(),
                          const Expanded(
                            flex: 11,
                            child: Text(
                              'Подборки',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          const Spacer(
                            flex: 9,
                          ),
                          Expanded(
                            flex: 9,
                            child: Column(
                              children: const [
                                Spacer(),
                                Expanded(
                                  flex: 5,
                                  child: OpenAllButton(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 12,
                      child: Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            flex: 12,
                            child: _firstContainer,
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 12,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: _secondContainer,
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 7,
                                  child: _thirdContainer,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 17,
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
        Align(
          alignment: const AlignmentDirectional(0.0, 1.05),
          child: _soundContainerList(),
        ),
      ],
    );
  }

  Widget _soundContainerList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.96,
      height: MediaQuery.of(context).size.height * 0.38,
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
      child: Stack(
        children: [
          const Align(
            alignment: AlignmentDirectional(-0.9, -0.9),
            child: Text(
              'Аудиозаписи',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          const Align(
            alignment: AlignmentDirectional(1.0, -0.92),
            child: OpenAllButton(
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: _bottom),
            child: StreamBuilder(
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
                if (snapshot.data?.docs.length == 0 ||
                    FirebaseAuth.instance.currentUser == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Как только ты запишешь'
                            '\nаудио, она появится здесь.',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Image(
                            image: Image.asset(AppIcons.arrow).image,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  final int length = snapshot.data.docs.length;
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

                  return ListView.builder(
                    itemCount: length,
                    itemBuilder: (context, index) {
                      Color color = current[index]
                          ? const Color(0xffF1B488)
                          : AppColor.active;

                      final String url = snapshot.data.docs[index]['song'];
                      final String id = snapshot.data.docs[index].id;
                      final String title = snapshot.data.docs[index]['title'];
                      final double time = snapshot.data.docs[index]['time'];
                      return Column(
                        children: [
                          SoundContainer(
                            color: color,
                            title: title,
                            time: (time / 60).toStringAsFixed(1),
                            onTap: () {
                              if (!current[index]) {
                                for (int i = 0; i < length; i++) {
                                  current[i] = false;
                                }
                                setState(() {
                                  _player = const Text('');
                                  _bottom = 90.0;
                                });

                                Future.delayed(const Duration(milliseconds: 50),
                                    () {
                                  setState(() {
                                    current[index] = true;
                                    _player = CustomPlayer(
                                      onDismissed: (direction) {
                                        setState(() {
                                          _player = const Text('');
                                          _bottom = 10.0;
                                          current[index] = false;
                                        });
                                      },
                                      url: url,
                                      id: id,
                                      title: title,
                                      routName: HomePage.routName,
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
                                id: id,
                                url: url,
                                onDelete: () {
                                  if (current[index]) {
                                    setState(() {
                                      _player = const Text('');
                                    });
                                  }
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
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: _player,
            ),
          ),
        ],
      ),
    );
  }

  Widget _compilationContainer(AsyncSnapshot snapshot, int index) {
    final List listId = snapshot.data.docs[index]['sounds'];
    final String url = snapshot.data.docs[index]['image'];
    final String text = snapshot.data.docs[index]['text'];
    final String title = snapshot.data.docs[index]['title'];
    final Timestamp date = snapshot.data.docs[index]['date'];
    final String id = snapshot.data.docs[index].id;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          CurrentCompilationPage.routName,
          arguments: CurrentCompilationPageArguments(
            title: title,
            url: url,
            listId: listId,
            date: date,
            id: id,
            text: text,
          ),
        );
        context.read<BlocIndex>().add(
              ColorCategory(),
            );

      },
      child: CompilationContainer(
        url: url,
        height: double.infinity,
        width: double.infinity,
        title: title,
        length: listId.length,
      ),
    );
  }
}
