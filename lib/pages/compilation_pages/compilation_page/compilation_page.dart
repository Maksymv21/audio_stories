import 'package:audio_stories/pages/compilation_pages/compilation_create_page/create_compilation_page.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_bloc/compilation_current_bloc.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_bloc/compilation_current_event.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_page.dart';
import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/local_db.dart';
import '../compilation_create_page/compilation_blocs/add_in_compilation_bloc.dart';
import '../compilation_create_page/compilation_blocs/add_in_compilation_event.dart';

class CompilationPage extends StatelessWidget {
  static const routName = '/compilation';

  const CompilationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      MainPage.globalKey.currentState!
                          .pushReplacementNamed(CreateCompilationPage.routName);
                      context.read<AddInCompilationBloc>().add(
                            InitialCompilation(),
                          );
                    },
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        Align(
          alignment: const AlignmentDirectional(1.0, -0.975),
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {},
            child: const Text(
              '...',
              style: TextStyle(
                  color: Colors.white, fontSize: 48, letterSpacing: 3.0),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: const [
                Text(
                  'Подборки',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 36.0,
                    letterSpacing: 3.0,
                  ),
                ),
                Text(
                  'Все в одном месте',
                  style: TextStyle(
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
        _listCompilation(),
      ],
    );
  }

  Widget _listCompilation() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('compilations')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final double _width = MediaQuery.of(context).size.width;
        final double _height = MediaQuery.of(context).size.height;

        if (snapshot.data?.docs.length == 0) {
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
                return GestureDetector(
                  onTap: () {
                    MainPage.globalKey.currentState!
                        .pushReplacementNamed(CurrentCompilationPage.routName);
                    context.read<CompilationCurrentBloc>().add(
                          ToCurrentCompilation(
                              listId: listId,
                              url: image,
                              text: text,
                              title: title),
                        );
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            image: Image.network(image).image,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0xff454545),
                            ],
                            stops: [0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 3.0,
                              ),
                              Text(
                                '${listId.length} аудио'
                                '\n0 часов',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
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
}
