import 'package:audio_stories/main_page/pages/compilation_pages/compilation_current_page/compilation_current_page.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/local_db.dart';
import '../../../main_page.dart';
import '../../../widgets/compilation_container.dart';
import '../../../widgets/custom_checkbox.dart';
import '../compilation_create_page/compilation_create_bloc/add_in_compilation_bloc.dart';
import '../compilation_create_page/compilation_create_bloc/add_in_compilation_event.dart';
import '../compilation_create_page/create_compilation_page.dart';
import 'compilation_bloc/compilation_bloc.dart';
import 'compilation_bloc/compilation_event.dart';
import 'compilation_bloc/compilation_state.dart';

class CompilationPage extends StatefulWidget {
  static const routName = '/compilation';

  const CompilationPage({Key? key}) : super(key: key);

  @override
  State<CompilationPage> createState() => _CompilationPageState();
}

class _CompilationPageState extends State<CompilationPage> {
  List<bool> chek = [];
  bool ready = false;
  bool delete = false;
  bool _pickFew = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompilationBloc, CompilationState>(
        builder: (context, state) {
      String subTitle;
      Widget topRightButton;
      bool visible;

      if (state is InitialCompilation) {
        print('0');
        subTitle = 'Все в одном месте';
        topRightButton = Align(
          alignment: const AlignmentDirectional(0.95, -0.95),
          child: _pickFew ? _popupPickDelete() : _popupPickFew(),
        );
        if (_pickFew) {
          visible = true;
        } else {
          visible = false;
        }
      } else {
        print('1');
        subTitle = '';
        topRightButton = Align(
          alignment: const AlignmentDirectional(1.0, -0.89),
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              if (chek.contains(true)) {
                setState(() {
                  ready = !ready;
                });
              } else {
                GlobalRepo.showSnackBar(
                  context: context,
                  title: 'Выберите подборку',
                );
              }
            },
            child: const Text(
              'Добавить',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        );
        visible = true;
      }

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
                      color: Colors.white,
                      iconSize: 40.0,
                      icon: const Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser == null) {
                          GlobalRepo.showSnackBar(
                            context: context,
                            title:
                                'Для создания подборки нужно зарегистрироваться',
                          );
                        } else {
                          if (state is InitialCompilation) {
                            context.read<AddInCompilationBloc>().add(
                                  ToCreateCompilation(),
                                );
                          }
                          if (state is AddInCompilation) {
                            context.read<AddInCompilationBloc>().add(
                                  ToCreate(
                                    listId: state.listId,
                                    text: '',
                                    title: '',
                                  ),
                                );
                          }
                          MainPage.globalKey.currentState!.pushReplacementNamed(
                              CreateCompilationPage.routName);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          topRightButton,
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Column(
                children: [
                  const Text(
                    'Подборки',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 36.0,
                      letterSpacing: 3.0,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _listCompilation(visible, state, ready),
        ],
      );
    });
  }

  Widget _listCompilation(
    bool visible,
    CompilationState state,
    bool ready,
  ) {
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
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final double _width = MediaQuery.of(context).size.width;
        final double _height = MediaQuery.of(context).size.height;

        if (snapshot.data?.docs.length == 0 ||
            FirebaseAuth.instance.currentUser == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0, top: 100.0),
              child: Text(
                'Как только ты создадишь'
                '\nподборку, она появится здесь.',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          final int length = snapshot.data.docs.length;

          if (chek.isEmpty || chek.length < length) {
            for (int i = 0; i < length; i++) {
              chek.add(false);
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              top: _height * 0.15,
              left: _width * 0.02,
              right: _width * 0.02,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.0,
                childAspectRatio: 61 / 80,
                mainAxisSpacing: _width * 0.04,
                crossAxisSpacing: _width * 0.04,
              ),
              itemCount: length,
              itemBuilder: (context, index) {
                final String title = snapshot.data.docs[index]['title'];
                final String text = snapshot.data.docs[index]['text'];
                final String image = snapshot.data.docs[index]['image'];
                final List listId = snapshot.data.docs[index]['sounds'];
                final Timestamp date = snapshot.data.docs[index]['date'];
                final String id = snapshot.data.docs[index].id;

                if (ready && state is AddInCompilation && chek[index]) {
                  for (int i = 0; i < state.listId.length; i++) {
                    if (!listId.contains(state.listId[i])) {
                      listId.add(state.listId[i]);
                    }
                  }

                  Database.createOrUpdateCompilation({
                    'id': id,
                    'sounds': listId,
                  });
                  context.read<CompilationBloc>().add(
                        ToInitialCompilation(),
                      );
                  ready = false;
                }

                if (delete && chek[index]) {
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    Database.deleteCompilation({
                      'id': id,
                      'title': title,
                      'date': date,
                    }).whenComplete(() {
                      setState(() {
                        delete = false;
                        _pickFew = false;
                        chek.removeAt(index);
                      });
                    });
                  }
                }

                return GestureDetector(
                  onTap: () {
                    if (state is InitialCompilation) {
                      Navigator.pushNamed(
                        context,
                        CurrentCompilationPage.routName,
                        arguments: CurrentCompilationPageArguments(
                          title: title,
                          url: image,
                          listId: listId,
                          date: date,
                          id: id,
                          text: text,
                        ),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      CompilationContainer(
                        url: image,
                        height: _height,
                        width: _width,
                        title: title,
                        length: listId.length,
                      ),
                      Visibility(
                        visible: visible,
                        child: Stack(
                          children: [
                            Container(
                              height: _height * 0.4,
                              decoration: BoxDecoration(
                                color: chek[index]
                                    ? Colors.transparent
                                    : const Color(0xff454545).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: _width * 0.175),
                              child: CustomCheckBox(
                                color: Colors.white,
                                value: chek[index],
                                onTap: () {
                                  setState(() {
                                    chek[index] = !chek[index];
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff71A59F),
            ),
          );
        }
      },
    );
  }

  Widget _popupPickFew() {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) {
          setState(() {
            _pickFew = true;
          });
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 0,
          child: Text(
            'Выбрать несколько',
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
          fontSize: 48.0,
          letterSpacing: 3.0,
        ),
      ),
    );
  }

  Widget _popupPickDelete() {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) {
          setState(() {
            _pickFew = false;
          });
        }
        if (value == 1) {
          if (!chek.contains(true)) {
            GlobalRepo.showSnackBar(
              context: context,
              title: 'Сделайте выбор',
            );
          } else {
            setState(() {
              delete = true;
            });
          }
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 0,
          child: Text(
            'Отменить выбор',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            'Удалить',
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
          fontSize: 48.0,
          letterSpacing: 3.0,
        ),
      ),
    );
  }
}