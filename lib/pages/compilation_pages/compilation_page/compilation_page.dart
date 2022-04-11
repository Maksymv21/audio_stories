import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_page.dart';
import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:audio_stories/widgets/menu/pick_few_popup.dart';
import 'package:audio_stories/widgets/uncategorized/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/local_db.dart';
import '../../../widgets/uncategorized/compilation_container.dart';
import '../../../widgets/uncategorized/custom_checkbox.dart';
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
  List<Map<String, dynamic>> compilations = [];
  bool _pickFew = false;

  void _createList(AsyncSnapshot snapshot) {
    if (compilations.isEmpty) {
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        compilations.add({
          'chek': false,
          'title': snapshot.data.docs[i]['title'],
          'url': snapshot.data.docs[i]['image'],
          'text': snapshot.data.docs[i]['text'],
          'date': snapshot.data.docs[i]['date'],
          'listId': snapshot.data.docs[i]['sounds'],
          'id': snapshot.data.docs[i]['id'],
        });
      }
    }
  }

  Future<void> _addIn(
    AddInCompilation state,
  ) async {
    for (int i = 0; i < compilations.length; i++) {
      if (compilations[i]['chek']) {
        for (int j = 0; j < state.listId.length; j++) {
          if (!compilations[i]['listId'].contains(state.listId[j])) {
            compilations[i]['listId'].add(state.listId[j]);
          }
        }
        await Database.createOrUpdateCompilation(
          {
            'id': compilations[i]['id'],
            'sounds': compilations[i]['listId'],
          },
        );
      }
    }

    context.read<CompilationBloc>().add(
          ToInitialCompilation(),
        );
  }

  bool _chek(List<Map<String, dynamic>> dataList) {
    bool chek = false;
    for (var map in dataList) {
      if (map.containsKey('chek')) {
        if (map['chek']) {
          chek = true;
        }
      }
    }
    return chek;
  }

  void _toCreateCompilation(CompilationState state) {
    if (FirebaseAuth.instance.currentUser == null) {
      GlobalRepo.showSnackBar(
        context: context,
        title: 'Для создания подборки нужно зарегистрироваться',
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
      MainPage.globalKey.currentState!
          .pushReplacementNamed(CreateCompilationPage.routName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompilationBloc, CompilationState>(
        builder: (context, state) {
      String subTitle;
      Widget topRightButton;
      bool visible;
      compilations = [];

      subTitle = 'Все в одном месте';
      topRightButton = Align(
        alignment: const AlignmentDirectional(0.95, -0.95),
        child: _pickFew
            ? _PopupMenu(
                compilations: compilations,
                cancel: () {
                  setState(() {
                    _pickFew = false;
                  });
                },
                set: () {
                  Future.delayed(
                      const Duration(
                        milliseconds: 1000,
                      ), () {
                    setState(() {
                      compilations = [];
                      _pickFew = false;
                    });
                  });
                },
              )
            : PickFewPopup(pickFew: () {
                setState(() {
                  _pickFew = true;
                });
              }),
      );
      if (_pickFew) {
        visible = true;
      } else {
        visible = false;
      }

      if (state is AddInCompilation) {
        subTitle = '';
        topRightButton = Align(
          alignment: const AlignmentDirectional(1.0, -0.89),
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              if (_chek(compilations)) {
                _addIn(state).then((value) {
                  setState(() {});
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
                  image: AppImages.upGreen,
                  height: 325.0,
                  child: Align(
                    alignment: const AlignmentDirectional(
                      -1.1,
                      -0.9,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      iconSize: 40.0,
                      icon: const Icon(
                        Icons.add,
                      ),
                      onPressed: () => _toCreateCompilation(
                        state,
                      ),
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
          _CompilationStream(
            create: _createList,
            child: _CompilationsList(
              compilations: compilations,
              state: state,
              visible: visible,
            ),
          ),
        ],
      );
    });
  }
}

//ignore: must_be_immutable
class _PopupMenu extends StatelessWidget {
  _PopupMenu({
    Key? key,
    required this.cancel,
    required this.compilations,
    required this.set,
  }) : super(key: key);

  void Function() cancel;
  void Function() set;
  final List<Map<String, dynamic>> compilations;

  Future<void> _deleteCompilations() async {
    for (int i = compilations.length - 1; i >= 0; i = i - 1) {
      if (compilations[i]['chek']) {
        await Database.deleteCompilation(
          {
            'id': compilations[i]['id'],
            'sounds': compilations[i]['listId'],
          },
        );
      }
    }
  }

  void _delete(BuildContext context) {
    if (!_chek(compilations)) {
      GlobalRepo.showSnackBar(
        context: context,
        title: 'Сделайте выбор',
      );
    } else {
      _deleteCompilations().whenComplete(
        () => set(),
      );
    }
  }

  bool _chek(List<Map<String, dynamic>> dataList) {
    bool chek = false;
    for (var map in dataList) {
      if (map.containsKey('chek')) {
        if (map['chek']) {
          chek = true;
        }
      }
    }
    return chek;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) cancel();
        if (value == 1) {
          _delete(context);
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

class _CompilationStream extends StatefulWidget {
  const _CompilationStream({
    Key? key,
    required this.child,
    required this.create,
  }) : super(key: key);

  final void Function(AsyncSnapshot) create;
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
          if (snapshot.data.docs.length == 0 ||
              FirebaseAuth.instance.currentUser == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 10.0,
                  top: 100.0,
                ),
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
          } else {
            widget.create(snapshot);

            return widget.child;
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _CompilationsList extends StatefulWidget {
  const _CompilationsList({
    Key? key,
    required this.compilations,
    required this.state,
    required this.visible,
  }) : super(key: key);

  final List<Map<String, dynamic>> compilations;
  final CompilationState state;
  final bool visible;

  @override
  State<_CompilationsList> createState() => _CompilationsListState();
}

class _CompilationsListState extends State<_CompilationsList> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

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
        itemCount: widget.compilations.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (widget.state is InitialCompilation && !widget.visible) {
                Navigator.pushNamed(
                  context,
                  CurrentCompilationPage.routName,
                  arguments: CurrentCompilationPageArguments(
                    title: widget.compilations[index]['title'],
                    url: widget.compilations[index]['url'],
                    listId: widget.compilations[index]['listId'],
                    date: widget.compilations[index]['date'],
                    id: widget.compilations[index]['id'],
                    text: widget.compilations[index]['text'],
                  ),
                );
              }
            },
            child: Stack(
              children: [
                CompilationContainer(
                  url: widget.compilations[index]['url'],
                  height: _height,
                  width: _width,
                  title: widget.compilations[index]['title'],
                  length: widget.compilations[index]['listId'].length,
                ),
                Visibility(
                  visible: widget.visible,
                  child: Stack(
                    children: [
                      Container(
                        height: _height * 0.4,
                        decoration: BoxDecoration(
                          color: widget.compilations[index]['chek']
                              ? Colors.transparent
                              : const Color(0xff454545).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: _width * 0.175),
                        child: CustomCheckBox(
                          color: Colors.white,
                          value: widget.compilations[index]['chek'],
                          onTap: () {
                            setState(() {
                              widget.compilations[index]['chek'] =
                                  !widget.compilations[index]['chek'];
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
  }
}
