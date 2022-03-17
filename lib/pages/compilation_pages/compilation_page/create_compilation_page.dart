import 'dart:io';

import 'package:audio_stories/pages/compilation_pages/compilation_blocs/add_in_compilation_bloc.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_blocs/add_in_compilation_state.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_page/compilation_page.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_page/compilation_search_page.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../resources/app_icons.dart';
import '../../../utils/local_db.dart';
import '../../../widgets/background.dart';
import '../../main_pages/main_page/main_page.dart';
import '../../main_pages/widgets/sound_container.dart';
import '../compilation_blocs/add_in_compilation_event.dart';

class CreateCompilationPage extends StatefulWidget {
  static const routName = '/addCompilation';

  const CreateCompilationPage({Key? key}) : super(key: key);

  @override
  State<CreateCompilationPage> createState() => _CreateCompilationPageState();
}

class _CreateCompilationPageState extends State<CreateCompilationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  File? _image;
  List<String> listId = [];

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _image = File(image.path));
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return BlocBuilder<AddInCompilationBloc, AddInCompilationState>(
        builder: (context, state) {
      Widget _list = Expanded(
        flex: 4,
        child: Container(),
      );
      if (state is AddInCompilationInitial) {
        _list = Expanded(
          flex: 4,
          child: Column(
            children: [
              const Spacer(),
              Expanded(
                child: TextButton(
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      _image == null
                          ? context.read<AddInCompilationBloc>().add(
                                AddWithoutImage(
                                  text: _textController.text,
                                  title: _titleController.text,
                                ),
                              )
                          : context.read<AddInCompilationBloc>().add(
                                AddWithImage(
                                  image: _image!,
                                  text: _textController.text,
                                  title: _titleController.text,
                                ),
                              );

                      MainPage.globalKey.currentState!
                          .pushReplacementNamed(CompilationSearchPage.routName);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Добавить аудиофайл",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    )),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        );
      }
      if (state is WithoutImageList) {
        _list = _soundList(state.id);
        _textController.text = state.text;
        _titleController.text = state.title;
        listId = state.id;
      }
      if (state is WithImageList) {
        _list = _soundList(state.id);
        _textController.text = state.text;
        _titleController.text = state.title;
        _image = state.image;
        listId = state.id;
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
                      onPressed: () {
                        MainPage.globalKey.currentState!
                            .pushReplacementNamed(CompilationPage.routName);
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
            alignment: const AlignmentDirectional(0.95, -0.87),
            child: TextButton(
              child: const Text(
                'Готово',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                if (_image != null) {
                  _createCompilation(listId, _image!);
                  MainPage.globalKey.currentState!
                      .pushReplacementNamed(CompilationPage.routName);
                }
              },
            ),
          ),
          Center(
            child: Column(
              children: [
                const Spacer(),
                const Expanded(
                  child: Text(
                    'Создание',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 36.0,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: _width * 0.05),
                    child: TextFormField(
                      controller: _titleController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        letterSpacing: 1.0,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Название',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          letterSpacing: 1.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    width: _width * 0.9,
                    height: _height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        colorFilter: const ColorFilter.srgbToLinearGamma(),
                        image: _image == null
                            ? Image.asset(AppIcons.headphones).image
                            : Image.file(_image!).image,
                        fit: BoxFit.cover,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Image.asset(AppIcons.camera),
                      onPressed: () {
                        pickImage();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: _width * 0.085),
                        child: const Text(
                          'Введите описание...',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _width * 0.3,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: _width * 0.05,
                      right: _width * 0.05,
                    ),
                    child: TextFormField(
                      controller: _textController,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: _width * 0.8,
                    ),
                    TextButton(
                      onPressed: () {
                        if (_image != null) {
                          _createCompilation(listId, _image!);
                          MainPage.globalKey.currentState!
                              .pushReplacementNamed(CompilationPage.routName);
                        }
                      },
                      child: const Text(
                        'Готово',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                _list,
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _soundList(List<String> id) {
    return Expanded(
      flex: 4,
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
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: id.length,
              itemBuilder: (context, index) {
                String? title;
                double? time;
                for (int i = 0; i < snapshot.data.docs.length; i++) {
                  if (snapshot.data.docs[i].id == id[index]) {
                    title = snapshot.data.docs[i]['title'];
                    time = snapshot.data.docs[i]['time'];
                  }
                }
                return Column(
                  children: [
                    SoundContainer(
                      color: AppColor.active,
                      title: title!,
                      time: (time! / 60).toStringAsFixed(1),
                      onTap: () {},
                      buttonRight: Container(),
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
        },
      ),
    );
  }

  void _createCompilation(List<String> listId, File image) {
    const Uuid uuid = Uuid();

    final String id = uuid.v1();

    Database.createOrUpdateCompilation({
      'id': id,
      'title': _titleController.text,
      'text': _textController.text,
      'sounds': listId,
      'date': Timestamp.now(),
    }, image);
  }
}
