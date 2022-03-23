import 'package:audio_stories/pages/compilation_pages/compilation_current_page/compilation_current_page.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/app_color.dart';
import '../../../resources/app_icons.dart';
import '../../../utils/database.dart';
import '../../../utils/local_db.dart';
import '../../../widgets/background.dart';
import '../../main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import '../../main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import '../../main_pages/main_page/main_page.dart';
import '../../main_pages/widgets/custom_checkbox.dart';
import '../../main_pages/widgets/player_container.dart';
import '../../main_pages/widgets/sound_container.dart';
import '../../play_page/play_page.dart';
import '../compilation_page/compilation_bloc/compilation_bloc.dart';
import '../compilation_page/compilation_bloc/compilation_event.dart';
import '../compilation_page/compilation_page.dart';

//ignore: must_be_immutable
class PickFewCompilationPage extends StatefulWidget {
  static const routName = '/pickFew';

  final String? title;
  final String? url;
  List? listId;
  final Timestamp? date;
  final String? id;

  PickFewCompilationPage({
    Key? key,
    this.title,
    this.url,
    this.listId,
    this.date,
    this.id,
  }) : super(key: key);

  @override
  State<PickFewCompilationPage> createState() => _PickFewCompilationPageState();
}

class _PickFewCompilationPageState extends State<PickFewCompilationPage> {
  double _bottom = 0.0;
  List<bool> current = [];
  List<bool> chek = [];
  List<String> listTitle = [];
  List<String> listUrl = [];
  List<double> listTime = [];
  List currentId = [];
  Widget _player = const Text('');

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

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
                            onPressed: () {
                              MainPage.globalKey.currentState!
                                  .pushReplacementNamed(
                                      CurrentCompilationPage.routName);
                            },
                            icon: Image.asset(AppIcons.back),
                            iconSize: 60.0,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                Align(
                  alignment: const AlignmentDirectional(0.95, -0.95),
                  child: _popupMenu(),
                ),
                Column(
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: _width * 0.05,
                        bottom: _height * 0.01,
                      ),
                      child: Row(
                        children: [
                          Text(
                            widget.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _imageContainer(
                      width: _width,
                      height: _height,
                      url: widget.url!,
                      date: widget.date!,
                      length: widget.listId!.length,
                    ),
                    Expanded(
                      flex: 6,
                      child: _soundList(snapshot),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: _player,
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _imageContainer({
    required double width,
    required double height,
    required String url,
    required Timestamp date,
    required int length,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: [
          Container(
            width: width * 0.9,
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: Image.network(url).image,
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
            width: width * 0.9,
            height: height * 0.3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xff454545),
                ],
                stops: [0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(-0.85, -0.9),
                  child: Text(
                    _convertDate(date),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.85, 0.9),
                  child: Text(
                    '$length аудио'
                    '\n0 часов',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _soundList(AsyncSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.only(bottom: _bottom),
      child: ListView.builder(
          itemCount: widget.listId!.length,
          itemBuilder: (context, index) {
            _createLists(snapshot, widget.listId!.length);
            Color color =
                current[index] ? const Color(0xffF1B488) : AppColor.active;

            if (listTitle.isEmpty) {
              for (int i = 0; i < snapshot.data.docs.length; i++) {
                for (int j = 0; j < widget.listId!.length; j++) {
                  if (snapshot.data.docs[i].id == widget.listId![j]) {
                    listTitle.add(snapshot.data.docs[i]['title']);
                    listUrl.add(snapshot.data.docs[i]['song']);
                    listTime.add(snapshot.data.docs[i]['time']);
                  }
                }
              }
            }

            return Column(
              children: [
                SoundContainer(
                  color: color,
                  title: listTitle[index],
                  time: (listTime[index] / 60).toStringAsFixed(1),
                  buttonRight: Align(
                    alignment: const AlignmentDirectional(0.9, -1.0),
                    child: CustomCheckBox(
                      color: Colors.black87,
                      value: chek[index],
                      onTap: () {
                        setState(() {
                          chek[index] = !chek[index];
                        });
                      },
                    ),
                  ),
                  onTap: () {
                    if (!current[index]) {
                      for (int i = 0; i < widget.listId!.length; i++) {
                        current[i] = false;
                      }
                      setState(() {
                        _player = const Text('');
                        _bottom = 90.0;
                      });

                      Future.delayed(const Duration(milliseconds: 50), () {
                        setState(() {
                          current[index] = true;
                          _player = Dismissible(
                            key: const Key(''),
                            direction: DismissDirection.down,
                            onDismissed: (direction) {
                              setState(() {
                                _player = const Text('');
                                _bottom = 10.0;
                                current[index] = false;
                              });
                            },
                            child: PlayerContainer(
                              title: listTitle[index],
                              url: listUrl[index],
                              id: widget.listId![index],
                              onPressed: () {
                                setState(() {
                                  _player = const Text('');
                                });
                                _toPlayPage(
                                  listUrl[index],
                                  listTitle[index],
                                  widget.listId![index],
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
          }),
    );
  }

  Widget _popupMenu() {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) async {
        if (value == 0) {
          setState(() {
            for (int i = 0; i < chek.length; i++) {
              chek[i] = false;
            }
          });
        }
        if (value == 1) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            for (int i = 0; i < widget.listId!.length; i++) {
              if (chek[i]) currentId.add(widget.listId![i]);
            }
            MainPage.globalKey.currentState!
                .pushReplacementNamed(CompilationPage.routName);
            context.read<CompilationBloc>().add(
                  ToAddInCompilation(
                    listId: currentId,
                  ),
                );
          }
        }
        if (value == 2) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {}
        }
        if (value == 3) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            for (int i = 0; i < widget.listId!.length; i++) {
              if (chek[i]) {
                _download(listUrl[i], listTitle[i]).then((value) {
                  GlobalRepo.showSnackBar(
                    context: context,
                    title: 'Файл сохранен.'
                        '\nDownload/${listTitle[i]}.aac',
                  );

                  setState(() {
                    chek[i] = false;
                  });
                });
              }
            }
          }
        }
        if (value == 4) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            if (!chek.contains(false)) {
              GlobalRepo.showSnackBar(
                context: context,
                title: 'В подборке должно оставаться минимум одно аудио',
              );
            } else {
              for (int i = 0; i < chek.length; i++) {
                if (chek[i]) {
                  Database.deleteSoundInCompilation(
                    {'sounds': widget.listId!},
                    widget.id!,
                    widget.listId![i],
                  );
                  setState(() {
                    chek.removeAt(i);
                    listTitle.removeAt(i);
                    listUrl.removeAt(i);
                    listTime.removeAt(i);
                    widget.listId!.removeAt(i);

                    current.removeAt(i);
                  });
                }
              }
            }
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
            'Добавить в подборку',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            'Поделиться',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            'Скачать все',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(
            'Удалить все',
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
          fontSize: 48,
          letterSpacing: 3.0,
        ),
      ),
    );
  }

  void _createLists(AsyncSnapshot snapshot, int length) {
    if (current.isEmpty) {
      for (int i = 0; i < length; i++) {
        current.add(false);
      }
    }
    // if (current.length < length) {
    //   current = List.from(current.reversed);
    //   current.add(false);
    //   current = List.from(current.reversed);
    // }

    if (chek.isEmpty) {
      for (int i = 0; i < length; i++) {
        chek.add(false);
      }
    }
  }

  void _toPlayPage(
    String url,
    String title,
    String id,
  ) {
    setState(() {
      _player = const Text('');
    });
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PlayPage(
          url: url,
          title: title,
          id: id,
          page: PickFewCompilationPage.routName,
        ),
      ),
    );
    context.read<BlocIndex>().add(
          NoColor(),
        );
  }

  Future _download(String url, String name) async {
    String path = 'storage/emulated/0/Download/$name.aac';

    Dio dio = Dio();

    await dio.download(
      url,
      path,
    );
  }

  String _convertDate(Timestamp date) {
    final String dateTime = date.toDate().toString();
    final String result = dateTime.substring(8, 10) +
        '.' +
        dateTime.substring(5, 7) +
        '.' +
        dateTime.substring(2, 4);
    return result;
  }

  void _choiseSnackBar(BuildContext context) {
    GlobalRepo.showSnackBar(
      context: context,
      title: 'Перед этим нужно сделать выбор',
    );
  }
}
