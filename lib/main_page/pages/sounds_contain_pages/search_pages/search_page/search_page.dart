import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../../../repositories/global_repository.dart';
import '../../../../../resources/app_color.dart';
import '../../../../../utils/database.dart';
import '../../../../../utils/local_db.dart';
import '../../../../main_page.dart';
import '../../../../widgets/buttons/button_menu.dart';
import '../../../../widgets/uncategorized/custom_checkbox.dart';
import '../../../../widgets/uncategorized/custom_player.dart';
import '../../../../widgets/menu/popup_menu_pick_few.dart';
import '../../../../widgets/menu/popup_menu_sound_container.dart';
import '../../../../widgets/uncategorized/sound_container.dart';
import '../../../compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../../../compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../../../compilation_pages/compilation_page/compilation_page.dart';


class SearchPage extends StatefulWidget {
  static const routName = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<bool> current = [];
  Set<int> search = {};
  List<bool> chek = [];
  List currentId = [];
  bool _pickFew = false;
  Widget _player = const Text('');
  double _bottom = 10.0;

  @override
  Widget build(BuildContext context) {
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
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Background(
                      height: 375.0,
                      image: AppIcons.upSearch,
                      child: Stack(
                        children: [
                          const Align(
                            alignment: AlignmentDirectional(-1.1, -0.95),
                            child: ButtonMenu(),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(1.0, -1.1),
                            child: _pickFew
                                ? _popupMenu(snapshot)
                                : _popupPickFew(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 5,
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
                      child: Text(
                        'Поиск',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 36.0,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ),
                    const Text(
                      'Найди потеряшку',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    _textForm(
                      context: context,
                      controller: controller,
                      onChanged: (String text) {
                        setState(() {});
                      },
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 17,
                      child: Stack(
                        children: [
                          snapshot.hasData
                              ? snapshot.data.docs.length == 0 ||
                                      FirebaseAuth.instance.currentUser == null
                                  ? Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          controller.text == ''
                                              ? 'Как только ты запишешь'
                                                  '\nаудио, она появится здесь.'
                                              : 'Ничего не найдено',
                                          style: const TextStyle(
                                            fontSize: 24.0,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : _soundList(snapshot)
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: _player,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _soundList(AsyncSnapshot snapshot) {
    final int length = snapshot.data.docs.length;
    _createLists(snapshot, length);
    List<int> list = search.toList();

    return Padding(
      padding: EdgeInsets.only(bottom: _bottom),
      child: controller.text != '' && search.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  'Ничего не найдено',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              itemCount: controller.text == '' ? length : search.length,
              itemBuilder: (context, index) {
                final int i = controller.text == '' ? index : list[index];

                Color color =
                    current[i] ? const Color(0xffF1B488) : AppColor.active;
                final String title = snapshot.data.docs[i]['title'];
                final String id = snapshot.data.docs[i].id;
                final String url = snapshot.data.docs[i]['song'];

                return Column(
                  children: [
                    SoundContainer(
                      color: color,
                      title: title,
                      time: (snapshot.data.docs[i]['time'] / 60)
                          .toStringAsFixed(1),
                      buttonRight: Align(
                        alignment: const AlignmentDirectional(0.9, -1.0),
                        child: _pickFew
                            ? CustomCheckBox(
                                value: chek[i],
                                onTap: () {
                                  setState(() {
                                    chek[index] = !chek[index];
                                  });
                                },
                                color: Colors.black87,
                              )
                            : PopupMenuSoundContainer(
                                size: 30.0,
                                title: title,
                                id: id,
                                url: url,
                                onDelete: () {
                                  if (current[i]) {
                                    setState(() {
                                      _player = const Text('');
                                    });
                                  }
                                  current.removeAt(i);
                                },
                              ),
                      ),
                      onTap: () {
                        if (!current[i]) {
                          for (int i = 0; i < length; i++) {
                            current[i] = false;
                          }
                          setState(() {
                            _player = const Text('');
                            _bottom = 90.0;
                          });

                          Future.delayed(const Duration(milliseconds: 50), () {
                            setState(() {
                              current[i] = true;
                              _player = CustomPlayer(
                                onDismissed: (direction) {
                                  setState(() {
                                    _player = const Text('');
                                    _bottom = 10.0;
                                    current[i] = false;
                                  });
                                },
                                url: url,
                                id: id,
                                title: title,
                                routName: SearchPage.routName,
                              );
                            });
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _textForm({
    required BuildContext context,
    required TextEditingController controller,
    required void Function(String)? onChanged,
  }) {
    return Stack(
      children: [
        PhysicalModel(
          color: Colors.white,
          elevation: 6.0,
          borderRadius: BorderRadius.circular(45.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5.0),
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 1.0,
                ),
                onChanged: onChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      icon: Image.asset(
                        AppIcons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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

  Widget _popupMenu(AsyncSnapshot snapshot) {
    return PopupMenuPickFew(
      onSelected: (value) async {
        if (value == 0) {
          setState(() {
            _pickFew = false;
          });
        }
        if (value == 1) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (chek[i]) currentId.add(snapshot.data.docs[i]['id']);
            }
            MainPage.globalKey.currentState!
                .pushReplacementNamed(CompilationPage.routName);
            context.read<CompilationBloc>().add(
                  ToAddInCompilation(
                    listId: currentId,
                  ),
                );
            context.read<BlocIndex>().add(
              ColorCategory(),
            );
          }
        }
        if (value == 2) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            List<String> url = [];
            List<String> title = [];
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (chek[i]) {
                url.add(snapshot.data.docs[i]['song']);
                title.add(snapshot.data.docs[i]['title']);

                setState(() {
                  chek[i] = false;
                });
              }
            }
            GlobalRepo.share(url, title);
          }
        }
        if (value == 3) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (chek[i]) {
                GlobalRepo.download(
                  snapshot.data.docs[i]['song'],
                  snapshot.data.docs[i]['title'],
                ).then((value) => {
                      GlobalRepo.showSnackBar(
                        context: context,
                        title: 'Файл сохранен.'
                            '\nDownload/${snapshot.data.docs[i]['title']}.aac',
                      ),
                    });

                setState(() {
                  chek[i] = false;
                });
              }
            }
          }
        }
        if (value == 4) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (chek[i]) {
                Database.createOrUpdateSound(
                  {
                    'deleted': true,
                    'dateDeleted': Timestamp.now(),
                    'id': snapshot.data.docs[i]['id'],
                  },
                );
                chek[i] = false;
              }
            }
          }
        }
      },
    );
  }

  void _createLists(
    AsyncSnapshot snapshot,
    int length,
  ) {
    if (current.isEmpty) {
      for (int i = 0; i < length; i++) {
        current.add(false);
      }
    }
    if (chek.isEmpty) {
      for (int i = 0; i < length; i++) {
        chek.add(false);
      }
    }
    if (current.length < length) {
      current = List.from(current.reversed);
      current.add(false);
      current = List.from(current.reversed);
    }

    search = {};

    for (int i = 0; i < length; i++) {
      if (snapshot.data.docs[i]['search'].contains(controller.text)) {
        search.add(i);
      }
    }
  }

  void _choiseSnackBar(BuildContext context) {
    GlobalRepo.showSnackBar(
      context: context,
      title: 'Перед этим нужно сделать выбор',
    );
  }
}
