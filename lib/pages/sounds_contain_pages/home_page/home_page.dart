import 'dart:async';

import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/pages/sounds_contain_pages/home_page/home_widgets/sound_list.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/uncategorized/background.dart';
import 'package:audio_stories/widgets/uncategorized/sound_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../../utils/local_db.dart';
import '../../../widgets/buttons/button_menu.dart';
import '../../../widgets/uncategorized/compilation_container.dart';
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
  List<Map<String, dynamic>> compilations = [];
  List<Map<String, dynamic>> sounds = [];
  bool update = false;

  Future<void> _createCompilations(AsyncSnapshot snapshot) async {
    compilations = [];
    for (int i = 0; i < snapshot.data.docs.length; i++) {
      compilations.add({
        'title': snapshot.data.docs[i]['title'],
        'url': snapshot.data.docs[i]['image'],
        'text': snapshot.data.docs[i]['text'],
        'date': snapshot.data.docs[i]['date'],
        'listId': snapshot.data.docs[i]['sounds'],
        'id': snapshot.data.docs[i]['id'],
      });
    }
  }

  Future<void> _createSounds(AsyncSnapshot snapshot) async {
    if (sounds.isEmpty) {
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        sounds.add(
          {
            'current': false,
            'title': snapshot.data.docs[i]['title'],
            'time': snapshot.data.docs[i]['time'],
            'id': snapshot.data.docs[i]['id'],
            'url': snapshot.data.docs[i]['song'],
          },
        );
      }
    }
  }

  Future<void> _createCompilationsContainers(int length) async {
    if (FirebaseAuth.instance.currentUser != null && !update) {
      if (length > 0) {
        _firstContainer = _CompilationHomeContainer(
          compilations: compilations,
          index: 0,
        );
        //setState(() {});
        if (length > 1) {
          _secondContainer = _CompilationHomeContainer(
            compilations: compilations,
            index: 1,
          );
          //setState(() {});
          if (length > 2) {
            _thirdContainer = _CompilationHomeContainer(
              compilations: compilations,
              index: 2,
            );
            //setState(() {});
          }
        }
      }
      Future.delayed(const Duration(milliseconds: 20), () {
        setState(() {
          update = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
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
        _CompilationStream(
          create: _createCompilations,
          createContainers: _createCompilationsContainers,
          child: Column(
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
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(0.0, 1.05),
          child: Container(
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
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    bottom: 10.0,
                  ),
                  child: SoundStream(
                    create: _createSounds,
                    child: SoundsList(
                      sounds: sounds,
                      routName: HomePage.routName,
                      onDelete: (i) {
                        Future.delayed(
                            const Duration(
                              milliseconds: 1500,
                            ), () {
                          setState(() {
                            sounds = [];
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _firstContainer = _FirstContainer();

  Widget _secondContainer = Container(
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

  Widget _thirdContainer = Container(
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
}

class _CompilationHomeContainer extends StatelessWidget {
  const _CompilationHomeContainer({
    Key? key,
    required this.compilations,
    required this.index,
  }) : super(key: key);
  final List<Map<String, dynamic>> compilations;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          CurrentCompilationPage.routName,
          arguments: CurrentCompilationPageArguments(
            title: compilations[index]['title'],
            url: compilations[index]['url'],
            listId: compilations[index]['listId'],
            date: compilations[index]['date'],
            id: compilations[index]['id'],
            text: compilations[index]['text'],
          ),
        );
        context.read<BlocIndex>().add(
              ColorCategory(),
            );
      },
      child: CompilationContainer(
        url: compilations[index]['url'],
        height: double.infinity,
        width: double.infinity,
        title: compilations[index]['title'],
        length: compilations[index]['listId'].length,
      ),
    );
  }
}

class _FirstContainer extends StatelessWidget {
  const _FirstContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            flex: 5,
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
  }
}

class _CompilationStream extends StatefulWidget {
  const _CompilationStream({
    Key? key,
    required this.child,
    required this.createContainers,
    required this.create,
  }) : super(key: key);

  final Future<void> Function(int) createContainers;
  final Future<void> Function(AsyncSnapshot) create;
  final Widget child;

  @override
  State<_CompilationStream> createState() => _CompilationStreamState();
}

class _CompilationStreamState extends State<_CompilationStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('compilations')
          .orderBy(
            'date',
            descending: true,
          )
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (snapshot.hasData) {
          widget.create(snapshot).whenComplete(
            () {
              widget.createContainers(snapshot.data.docs.length);
            },
          );

          return widget.child;
        } else {
          return Container();
        }
      },
    );
  }
}
