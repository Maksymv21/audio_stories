import 'package:audio_stories/main_page/widgets/uncategorized/search_sound_list.dart';
import 'package:audio_stories/main_page/widgets/uncategorized/sound_stream.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/app_icons.dart';
import '../../../../widgets/background.dart';
import '../../../main_page.dart';
import '../../../widgets/uncategorized/search_form.dart';
import 'compilation_create_bloc/add_in_compilation_bloc.dart';
import 'compilation_create_bloc/add_in_compilation_event.dart';
import 'compilation_create_bloc/add_in_compilation_state.dart';
import 'create_compilation_page.dart';

class CompilationSearchPage extends StatefulWidget {
  static const routName = '/compilationSearch';

  const CompilationSearchPage({Key? key}) : super(key: key);

  @override
  State<CompilationSearchPage> createState() => _CompilationSearchPageState();
}

class _CompilationSearchPageState extends State<CompilationSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> sounds = [];
  Set<int> search = {};
  List<String> listId = [];

  Future<void> _createLists(AsyncSnapshot snapshot) async {
    if (sounds.isEmpty) {
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        sounds.add(
          {
            'chek': false,
            'current': false,
            'title': snapshot.data.docs[i]['title'],
            'time': snapshot.data.docs[i]['time'],
            'id': snapshot.data.docs[i]['id'],
            'url': snapshot.data.docs[i]['song'],
            'search': snapshot.data.docs[i]['search'],
          },
        );
      }
    }
  }

  void _createSearch() {
    search = {};
    for (int i = 0; i < sounds.length; i++) {
      if (sounds[i]['search'].contains(_controller.text)) {
        search.add(i);
      }
    }
  }

  void _add(AddInCompilationState state) {
    for (int i = 0; i < sounds.length; i++) {
      if (sounds[i]['chek']) {
        listId.add(sounds[i]['id']);
      }
    }
    if (listId.isEmpty) {
      GlobalRepo.showSnackBar(
        context: context,
        title: 'Сделайте выбор',
      );
    } else {
      if (state is ChoiseSound) {
        context.read<AddInCompilationBloc>().add(
              ToCreate(
                listId: listId,
                text: state.text,
                title: state.title,
                image: state.image,
              ),
            );
      }
      MainPage.globalKey.currentState!.pushReplacementNamed(
        CreateCompilationPage.routName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  image: AppImages.upGreen,
                  child: Stack(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(
                          -1.1,
                          -0.9,
                        ),
                        child: IconButton(
                          onPressed: () {
                            MainPage.globalKey.currentState!
                                .pushReplacementNamed(
                                    CreateCompilationPage.routName);
                            context.read<AddInCompilationBloc>().add(
                                  ToCreateCompilation(),
                                );
                          },
                          icon: Image.asset(AppIcons.back),
                          iconSize: 60.0,
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(
                          1.05,
                          -0.65,
                        ),
                        child: TextButton(
                          style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () => _add(state),
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
                padding: EdgeInsets.only(
                  top: 40.0,
                  bottom: 5.0,
                ),
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
              SearchForm(
                controller: _controller,
                onChanged: (String text) {
                  setState(() {
                    _createSearch();
                  });
                },
              ),
              const Spacer(),
              Expanded(
                flex: 17,
                child: SoundStream(
                  create: _createLists,
                  child: SearchSoundList(
                    sounds: sounds,
                    search: search.toList(),
                    routName: CompilationSearchPage.routName,
                    searchText: _controller.text,
                    isPopup: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


