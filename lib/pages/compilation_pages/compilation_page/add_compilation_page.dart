import 'package:audio_stories/pages/compilation_pages/compilation_page/compilation_page.dart';
import 'package:flutter/material.dart';

import '../../../resources/app_icons.dart';
import '../../../widgets/background.dart';
import '../../main_pages/main_page/main_page.dart';

class AddCompilationPage extends StatefulWidget {
  static const routName = '/addCompilation';

  const AddCompilationPage({Key? key}) : super(key: key);

  @override
  State<AddCompilationPage> createState() => _AddCompilationPageState();
}

class _AddCompilationPageState extends State<AddCompilationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    _titleController.text = 'Название';

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
            onPressed: () {},
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
                      image: Image.asset(AppIcons.headphones).image,
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
                    onPressed: () {},
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
                    onPressed: () {},
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
              const Spacer(),
              Expanded(
                child: TextButton(
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {},
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
        ),
      ],
    );
  }
}
