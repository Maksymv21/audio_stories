import 'package:audio_stories/pages/home_pages/home_widgets/open_all_button.dart';
import 'package:audio_stories/pages/main_pages/widgets/sound_container.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/dialog_sound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../../utils/local_db.dart';
import '../../main_pages/widgets/button_menu.dart';

class HomePage extends StatefulWidget {
  static const routName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    permission();
  }

  Future permission() async{
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: const [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppIcons.up,
                child: Align(
                  alignment: AlignmentDirectional(-1.1, -0.95),
                  child: ButtonMenu(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        Column(
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
                    flex: 8,
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
                    child: Container(
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
                            flex: 4,
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
                              onPressed: () {},
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
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 12,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromRGBO(241, 180, 136, 1.0),
                            ),
                            width: 160.0,
                            height: 112.0,
                            child: const Center(
                              child: Text(
                                'Тут',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromRGBO(103, 139, 210, 0.75),
                            ),
                            width: 160.0,
                            height: 112.0,
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
                          ),
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
        Align(
          alignment: const AlignmentDirectional(0.0, 1.05),
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.96,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.38,
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
                  padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(LocalDB.uid)
                          .collection('sounds')
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
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
                                    image: Image
                                        .asset(AppIcons.arrow)
                                        .image,
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
                              final String title =
                              snapshot.data.docs[index]['title'];
                              final String id = snapshot.data.docs[index].id;
                              return Column(
                                children: [
                                  SoundContainer(
                                    color: AppColor.active,
                                    title: title,
                                    time:
                                    (snapshot.data.docs[index]['time'] / 60)
                                        .toStringAsFixed(1),
                                    delete: () {
                                      Database.deleteSound(id);
                                    },
                                    name: () =>
                                        _dialog(
                                          context,
                                          title,
                                          id,
                                        ),
                                    download: () => {},
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
        ),
      ],
    );
  }

  Future<String?> _dialog(BuildContext context,
      String title,
      String id,) {
    final TextEditingController controller = TextEditingController();
    controller.text = title;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          DialogSound(
            content: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            title: 'Введите новое название',
            onPressedCancel: () => Navigator.pop(context, 'Cancel'),
            onPressedSave: () {
              if (controller.text != '') {
                Database.createOrUpdateSound(
                    {'title': controller.text}, id: id);
              }
              Navigator.pop(context, 'Cancel');
            },
          ),
    );
  }

  Future<void> _download(String url) async {
    // final dir = await getApplicationDocumentsDirectory();
    // String _path = dir.path + name;
    // final saveDir = Directory(_path);
    // await saveDir.create(recursive: true).then((value) async {
    //   String? taskId = await FlutterDownloader.enqueue(
    //     url: url,
    //     savedDir: _path,
    //   );
    // });
    final status = await Permission.storage.request();

    final externalDir = await getExternalStorageDirectory();

    final id = await FlutterDownloader.enqueue(
      url:
      url,
      savedDir: externalDir!.path,
      fileName: "download",
      showNotification: true,
      openFileFromNotification: true,);
  }

}
