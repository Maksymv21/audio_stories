import 'package:audio_stories/pages/compilation_pages/compilation_blocs/add_in_compilation_bloc.dart';
import 'package:audio_stories/pages/main_pages/widgets/custom_checkbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/app_color.dart';
import '../../../resources/app_icons.dart';
import '../../../utils/local_db.dart';
import '../../../widgets/background.dart';
import '../../main_pages/main_page/main_page.dart';
import '../../main_pages/widgets/player_container.dart';
import '../../main_pages/widgets/sound_container.dart';
import '../../play_page/play_page.dart';
import '../compilation_blocs/add_in_compilation_event.dart';
import '../compilation_blocs/add_in_compilation_state.dart';
import 'create_compilation_page.dart';

class CompilationSearchPage extends StatefulWidget {
  static const routName = '/compilationSearch';

  const CompilationSearchPage({Key? key}) : super(key: key);

  @override
  State<CompilationSearchPage> createState() => _CompilationSearchPageState();
}

class _CompilationSearchPageState extends State<CompilationSearchPage> {
  TextEditingController controller = TextEditingController();
  List<bool> current = [];
  List<bool> chek = [];
  Set<int> search = {};
  List<String> id = [];
  double _bottom = 10.0;

  Widget _player = const Text('');
  Widget _body = const Center(
    child: CircularProgressIndicator(),
  );

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
          if (snapshot.hasData) {
            final int length = snapshot.data.docs.length;
            _createLists(snapshot, length);
            List<int> list = search.toList();

            _body = _soundList(length, list, snapshot);
          } else {
            _body = const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              BlocBuilder<AddInCompilationBloc, AddInCompilationState>(
                  builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Background(
                        height: 375.0,
                        image: AppIcons.upGreen,
                        child: Stack(
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(-1.1, -0.9),
                              child: IconButton(
                                onPressed: () {
                                  MainPage.globalKey.currentState!
                                      .pushReplacementNamed(
                                          CreateCompilationPage.routName);
                                  context.read<AddInCompilationBloc>().add(
                                        InitialCompilation(),
                                      );
                                },
                                icon: Image.asset(AppIcons.back),
                                iconSize: 60.0,
                              ),
                            ),
                            Align(
                              alignment:
                                  const AlignmentDirectional(1.05, -0.65),
                              child: TextButton(
                                style: const ButtonStyle(
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                onPressed: () {
                                  for (int i = 0; i < chek.length; i++) {
                                    if (chek[i]) {
                                      id.add(snapshot.data.docs[i].id);
                                    }
                                  }
                                  if (id.isEmpty) {
                                    _showSnackBar(
                                      context: context,
                                      title: 'Не выбрано ни одной аудиозаписи',
                                    );
                                  } else {
                                    if (state is ImageState) {
                                      context.read<AddInCompilationBloc>().add(
                                            AddListWithImage(
                                              id: id,
                                              image: state.image,
                                              text: state.text,
                                              title: state.title,
                                            ),
                                          );
                                    }
                                    if (state is TextState) {
                                      context.read<AddInCompilationBloc>().add(
                                            AddListWithoutImage(
                                              id: id,
                                              text: state.text,
                                              title: state.title,
                                            ),
                                          );
                                    }
                                    MainPage.globalKey.currentState!
                                        .pushReplacementNamed(
                                            CreateCompilationPage.routName);
                                  }
                                },
                                child: const Text(
                                  'Добавить',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 5,
                    ),
                  ],
                );
              }),
              Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 40.0, bottom: 5.0),
                      child: Text(
                        'Выбрать',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 36.0,
                          letterSpacing: 3.0,
                        ),
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
                          _body,
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

  Widget _soundList(int length, List<int> list, AsyncSnapshot snapshot) {
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
                        child: CustomCheckBox(
                          value: chek[i],
                          onTap: () {
                            setState(() {
                              chek[i] = !chek[i];
                            });
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
                              _player = Dismissible(
                                key: const Key(''),
                                direction: DismissDirection.down,
                                onDismissed: (direction) {
                                  setState(() {
                                    _player = const Text('');
                                    _bottom = 10.0;
                                    current[i] = false;
                                  });
                                },
                                child: PlayerContainer(
                                  title: title,
                                  url: url,
                                  id: id,
                                  onPressed: () {
                                    setState(() {
                                      _player = const Text('');
                                    });
                                    Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => PlayPage(
                                          url: url,
                                          title: title,
                                          id: id,
                                          page: CompilationSearchPage.routName,
                                        ),
                                      ),
                                    );
                                  },
                                ),
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

  void _createLists(AsyncSnapshot snapshot, int length) {
    if (chek.isEmpty) {
      for (int i = 0; i < length; i++) {
        chek.add(false);
      }
    }
    if (current.isEmpty) {
      for (int i = 0; i < length; i++) {
        current.add(false);
      }
    }

    search = {};

    for (int i = 0; i < length; i++) {
      if (snapshot.data.docs[i]['search'].contains(controller.text)) {
        search.add(i);
      }
    }
  }

  void _showSnackBar({
    required BuildContext context,
    required String title,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
