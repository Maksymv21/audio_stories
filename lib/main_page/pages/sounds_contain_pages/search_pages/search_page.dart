import 'package:audio_stories/main_page/widgets/uncategorized/search_form.dart';
import 'package:audio_stories/main_page/widgets/uncategorized/search_sound_list.dart';
import 'package:audio_stories/main_page/widgets/uncategorized/sound_stream.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:flutter/material.dart';

import '../../../widgets/buttons/button_menu.dart';
import '../../../widgets/menu/pick_few_popup.dart';
import '../../../widgets/menu/popup_menu_pick_few.dart';

class SearchPage extends StatefulWidget {
  static const routName = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> sounds = [];
  Set<int> search = {};
  bool _pickFew = false;

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 3,
              child: Background(
                height: 375.0,
                image: AppImages.upSearch,
                child: Stack(
                  children: [
                    const Align(
                      alignment: AlignmentDirectional(-1.1, -0.95),
                      child: ButtonMenu(),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1.0, -1.1),
                      child: _pickFew
                          ? PopupMenuPickFew(
                              sounds: sounds,
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
                                    sounds = [];
                                  });
                                });
                              },
                            )
                          : PickFewPopup(
                              pickFew: () {
                                _pickFew = true;
                                setState(() {});
                              },
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
                    routName: SearchPage.routName,
                    searchText: _controller.text,
                    isPopup: !_pickFew,
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
