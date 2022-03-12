import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../resources/app_color.dart';
import '../../../utils/local_db.dart';
import '../../main_pages/widgets/button_menu.dart';
import '../../main_pages/widgets/popup_menu_sound_container.dart';
import '../../main_pages/widgets/sound_container.dart';

class SearchPage extends StatefulWidget {
  static const routName = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();

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
                image: AppIcons.upSearch,
                child: Stack(
                  children: [
                    const Align(
                      alignment: AlignmentDirectional(-1.1, -0.95),
                      child: ButtonMenu(),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1.12, -1.15),
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
                              letterSpacing: 3.0),
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
                onChanged: (String text) {},
              ),
              const Spacer(),
              Expanded(
                flex: 17,
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
                      if (snapshot.data?.docs.length == 0) {
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
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SoundContainer(
                                  color: AppColor.active,
                                  title: snapshot.data.docs[index]['title'],
                                  time: (snapshot.data.docs[index]['time'] / 60)
                                      .toStringAsFixed(1),
                                  buttonRight: PopupMenuSoundContainer(
                                    size: 30.0,
                                    title: snapshot.data.docs[index]['title'],
                                    id: snapshot.data.docs[index].id,
                                    url: snapshot.data.docs[index]['song'],
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
                    }),
              ),
            ],
          ),
        ),
      ],
    );
    //   Column(
    //   children: [
    //     Background(
    //       image: AppIcons.upSearch,
    //       height: 275.0,
    //       child: Stack(
    //         children: [
    //           const Align(
    //             alignment: AlignmentDirectional(-1.1, -0.55),
    //             child: ButtonMenu(),
    //           ),
    //           const Align(
    //             alignment: AlignmentDirectional(0.0, -0.53),
    //             child: Text(
    //               'Поиск',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.w700,
    //                 fontSize: 36.0,
    //                 letterSpacing: 3.0,
    //               ),
    //             ),
    //           ),
    //           Align(
    //             alignment: const AlignmentDirectional(1.12, -0.725),
    //             child: TextButton(
    //               style: const ButtonStyle(
    //                 splashFactory: NoSplash.splashFactory,
    //               ),
    //               onPressed: () {},
    //               child: const Text(
    //                 '...',
    //                 style: TextStyle(
    //                     color: Colors.white, fontSize: 48, letterSpacing: 3.0),
    //               ),
    //             ),
    //           ),
    //           const Align(
    //             alignment: AlignmentDirectional(0.0, -0.2),
    //             child: Text(
    //               'Найди потеряшку',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.w400,
    //                 fontSize: 16.0,
    //                 letterSpacing: 1.0,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget _textForm({
    required BuildContext context,
    required TextEditingController controller,
    required void Function(String)? onChanged,
  }) {
    return PhysicalModel(
      color: Colors.white,
      elevation: 6.0,
      borderRadius: BorderRadius.circular(45.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          fontSize: 20.0,
          letterSpacing: 1.0,
        ),
        onChanged: onChanged,
        enableIMEPersonalizedLearning: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.87,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(45.0),
            ),
          ),
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
    );
  }
}
