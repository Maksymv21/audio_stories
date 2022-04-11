import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/widgets/uncategorized/dialog_sound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/database.dart';
import '../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../pages/compilation_pages/compilation_current_page/compilation_current_page.dart';
import '../../pages/compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../../pages/compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../../pages/compilation_pages/compilation_page/compilation_page.dart';
import '../../pages/sounds_contain_pages/home_page/home_page.dart';

//ignore: must_be_immutable
class PopupMenuSoundContainer extends StatelessWidget {
  PopupMenuSoundContainer({
    Key? key,
    required this.url,
    required this.id,
    required this.title,
    required this.size,
    this.onDelete,
    this.onRename,
    this.page,
    this.playPage,
  }) : super(key: key);

  String url;
  String id;
  String title;
  double size;
  String? page;
  void Function()? onDelete;
  void Function(String)? onRename;
  bool? playPage;

  void _addInCompilation(BuildContext context) {
    MainPage.globalKey.currentState!
        .pushReplacementNamed(CompilationPage.routName);
    context.read<CompilationBloc>().add(
          ToAddInCompilation(
            listId: [id],
          ),
        );
    context.read<BlocIndex>().add(ColorCategory());
  }

  Future<String?> _editName(
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
            ).whenComplete(() => {
                  if (onRename != null) onRename!(controller.text),
                });
          }

          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }

  void _delete(BuildContext context) {
    if (playPage != null) {
      MainPage.globalKey.currentState!.pushReplacementNamed(
        HomePage.routName,
      );
      context.read<BlocIndex>().add(
            ColorHome(),
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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) _addInCompilation(context);

        if (value == 1) _editName(context, title, id);

        if (value == 2) GlobalRepo.share([url], [title]);

        if (value == 3) {
          GlobalRepo.download(url, title).then(
            (value) => GlobalRepo.showSnackBar(
              context: context,
              title: 'Файл сохранен.'
                  '\nDownload/$title.aac',
            ),
          );
        }

        if (value == 4) _delete(context);
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
}
