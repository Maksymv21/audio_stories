import 'dart:io';

import 'package:audio_stories/main_page/widgets/uncategorized/sound_stream.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../resources/app_icons.dart';
import '../../../../resources/app_images.dart';
import '../../../../widgets/background.dart';
import '../../../main_page.dart';
import '../../../widgets/uncategorized/sound_container.dart';
import '../compilation_page/compilation_bloc/compilation_bloc.dart';
import '../compilation_page/compilation_bloc/compilation_event.dart';
import '../compilation_page/compilation_page.dart';
import 'compilation_create_bloc/add_in_compilation_bloc.dart';
import 'compilation_create_bloc/add_in_compilation_event.dart';
import 'compilation_create_bloc/add_in_compilation_state.dart';
import 'compilation_search_page.dart';

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
  String? _url;
  List<Map<String, dynamic>> sounds = [];
  List listId = []; // this listId need to fixed bug with text controller
  bool loading = false;

  Future pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _image = File(image.path));
  }

  void _addAudio(BuildContext context) {
    context.read<AddInCompilationBloc>().add(
          ToChoiseSound(
              text: _textController.text,
              title: _titleController.text,
              image: _image),
        );
    MainPage.globalKey.currentState!
        .pushReplacementNamed(CompilationSearchPage.routName);
  }

  void _back() {
    MainPage.globalKey.currentState!.pushReplacementNamed(
      CompilationPage.routName,
    );
  }

  void _create(AsyncSnapshot snapshot) {
    if (sounds.isEmpty) {
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        for (int j = 0; j < listId.length; j++) {
          if (snapshot.data.docs[i]['id'] == listId[j]) {
            sounds.add(
              {
                'title': snapshot.data.docs[i]['title'],
                'time': snapshot.data.docs[i]['time'],
              },
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return BlocBuilder<AddInCompilationBloc, AddInCompilationState>(
      builder: (context, state) {
        String _titlePage = 'Создание';

        Widget _list = Expanded(
          flex: 5,
          child: Column(
            children: [
              const Spacer(),
              Expanded(
                child: TextButton(
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () => _addAudio(context),
                    child: Container(
                      padding: const EdgeInsets.only(
                        bottom: 1.0,
                      ),
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

        if (state is Create) {
          if (listId != state.listId) {
            listId = state.listId;
            _textController.text = state.text;
            _titleController.text = state.title;
            _image = state.image;
            _url = state.url;
          }
          if (_url != null) _titlePage = '';
          _list = Expanded(
            flex: 5,
            child: SoundStream(
              create: _create,
              child: _SoundList(
                sounds: sounds,
              ),
            ),
          );
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
                        onPressed: () => _back(),
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
              alignment: const AlignmentDirectional(
                0.95,
                -0.87,
              ),
              child: TextButton(
                child: const Text(
                  'Готово',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () => _ready(state),
              ),
            ),
            Center(
              child: Column(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _titlePage,
                      style: const TextStyle(
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
                      padding: EdgeInsets.only(
                        left: _width * 0.05,
                      ),
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
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Container(
                      width: _width * 0.9,
                      height: _height * 0.3,
                      decoration: _image == null
                          ? _url == null
                              ? BoxDecoration(
                                  color: const Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(
                                    15.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                )
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15.0,
                                  ),
                                  image: DecorationImage(
                                    colorFilter:
                                        const ColorFilter.srgbToLinearGamma(),
                                    image: Image.network(_url!).image,
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                colorFilter:
                                    const ColorFilter.srgbToLinearGamma(),
                                image: Image.file(_image!).image,
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
                        icon: Image.asset(
                          AppIcons.camera,
                          color: Colors.black,
                        ),
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
                          padding: EdgeInsets.only(
                            left: _width * 0.085,
                          ),
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
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Card(
                        child: EditableText(
                          backgroundCursorColor: Colors.white,
                          textAlign: TextAlign.start,
                          focusNode: FocusNode(),
                          controller: _textController,
                          maxLines: 5,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.blue,
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
                        onPressed: () => _ready(state),
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
            Visibility(
              visible: loading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createCompilation(
    List listId,
    String? id,
    File? image,
  ) async {
    if (id == null) {
      const Uuid uuid = Uuid();

      id = uuid.v1();
    }

    await Database.createOrUpdateCompilation({
      'id': id,
      'title': _titleController.text,
      'text': _textController.text,
      'sounds': listId,
      'date': Timestamp.now(),
    }, image: image);
  }

  void _ready(AddInCompilationState state) {
    if (state is AddInCompilationInitial) {
      GlobalRepo.showSnackBar(
        context: context,
        title: 'Добавтье аудиофайли',
      );
    }
    if (state is Create) {
      if (_image == null && _url == null) {
        if (_textController.text != '' && _titleController.text != '') {
          GlobalRepo.showSnackBar(
            context: context,
            title: 'Выберите излюражение',
          );
        }
        if (_textController.text == '' || _titleController.text == '') {
          GlobalRepo.showSnackBar(
            context: context,
            title: 'Для создания подборки должно быть выбрано '
                'название, изображение и описание',
          );
        }
      }
      if (_image != null || _url != null) {
        if (_textController.text == '' || _titleController.text == '') {
          GlobalRepo.showSnackBar(
            context: context,
            title: 'Для создания подборки должно быть выбрано '
                'название и описание',
          );
        }
        if (_textController.text != '' && _titleController.text != '') {
          loading = true;
          setState(() {});
          _createCompilation(listId, state.id, _image).then(
            (value) {
              context.read<CompilationBloc>().add(
                    ToInitialCompilation(),
                  );
              MainPage.globalKey.currentState!
                  .pushReplacementNamed(CompilationPage.routName);
            },
          );
        }
      }
    }
  }
}

class _SoundList extends StatelessWidget {
  const _SoundList({
    Key? key,
    required this.sounds,
  }) : super(key: key);
  final List<Map<String, dynamic>> sounds;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SoundContainer(
              color: AppColor.active,
              title: sounds[index]['title'],
              time: (sounds[index]['time'] / 60).toStringAsFixed(1),
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
  }
}
