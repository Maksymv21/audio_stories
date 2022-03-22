import 'package:audio_stories/pages/audio_pages/audio_page/audio_page.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import 'package:audio_stories/pages/home_pages/home_page/home_page.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/database.dart';
import '../../../widgets/dialog_sound.dart';
import '../../compilation_pages/compilation_current_page/compilation_current_page.dart';
import '../../compilation_pages/compilation_page/compilation_page.dart';
import '../main_blocs/bloc_icon_color/bloc_index.dart';
import '../main_page/main_page.dart';

//ignore: must_be_immutable
class PopupMenuSoundContainer extends StatelessWidget {
  String url;
  String id;
  String title;
  double size;
  String? page;
  void Function()? onDelete;

  PopupMenuSoundContainer({
    Key? key,
    required this.url,
    required this.id,
    required this.title,
    required this.size,
    this.onDelete,
    this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) {
          MainPage.globalKey.currentState!
              .pushReplacementNamed(CompilationPage.routName);
          context.read<CompilationBloc>().add(
                ToAddInCompilation(
                  listId: [id],
                ),
              );
          context.read<BlocIndex>().add(ColorCategory());
        }
        if (value == 1) {
          _dialog(context, title, id);
        }
        if (value == 3) {
          download2(url, title).then(
            (value) => _showSnackBar(
              context: context,
              title: 'Файл сохранен.'
                  '\nDownload/$title.aac',
            ),
          );
        }
        if (value == 4) {
          if (page != null) {
            MainPage.globalKey.currentState!.pushReplacementNamed(page!);
            context.read<BlocIndex>().add(
                  _bloc(page!),
                );
          }
          if (page != CurrentCompilationPage.routName) {
            Database.createOrUpdateSound(
              {
                'deleted': true,
                'dateDeleted': Timestamp.now(),
                'id': id,
              },
            );
          }

          if (onDelete != null) onDelete!();
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 0,
          child: Text(
            'Добавить в подборку',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            'Редактировать название',
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
            'Скачать',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(
            'Удалить',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ],
      child: Text(
        '...',
        style: TextStyle(
          color: Colors.black,
          fontSize: size,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Future<String?> _dialog(
    BuildContext context,
    String title,
    String id,
  ) {
    final TextEditingController controller = TextEditingController();
    controller.text = title;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => DialogSound(
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
            List<String> search = [];
            for (int i = 1; i < controller.text.length + 1; i++) {
              search.add(controller.text.substring(0, i).toLowerCase());
            }

            Database.createOrUpdateSound(
              {
                'title': controller.text,
                'search': search,
                'id': id,
              },
            );
          }
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
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

  Future download2(String url, String name) async {
    String path = 'storage/emulated/0/Download/$name.aac';

    Dio dio = Dio();

    await dio.download(
      url,
      path,
    );
  }

  IndexEvent _bloc(String page) {
    IndexEvent event;
    if (page == HomePage.routName) {
      event = ColorHome();
    } else if (page == CompilationPage.routName ||
        page == CurrentCompilationPage.routName) {
      event = ColorCategory();
    } else if (page == AudioPage.routName) {
      event = ColorAudio();
    } else {
      event = NoColor();
    }
    return event;
  }
}
