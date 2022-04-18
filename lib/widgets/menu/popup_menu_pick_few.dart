import 'package:audio_stories/pages/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../repositories/global_repository.dart';
import '../../../utils/database.dart';
import '../../pages/compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../../pages/compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../../pages/compilation_pages/compilation_page/compilation_page.dart';

//ignore: must_be_immutable
class PopupMenuPickFew extends StatelessWidget {
  PopupMenuPickFew({
    Key? key,
    required this.sounds,
    required this.cancel,
    required this.set,
  }) : super(key: key);

  final List<Map<String, dynamic>> sounds;
  final void Function() cancel;
  final void Function() set;

  void _addInCompilation(BuildContext context) {
    if (!_chek()) {
      _choiseSnackBar(context);
    } else {
      List currentId = [];
      for (int i = 0; i < sounds.length; i++) {
        if (sounds[i]['chek']) {
          currentId.add(sounds[i]['id']);
        }
      }
      MainPage.globalKey.currentState!
          .pushReplacementNamed(CompilationPage.routName);
      context.read<CompilationBloc>().add(
            ToAddInCompilation(
              listId: currentId,
            ),
          );
      context.read<BlocIndex>().add(ColorCategory());
    }
  }

  void _share(BuildContext context) {
    if (!_chek()) {
      _choiseSnackBar(context);
    } else {
      List<String> url = [];
      List<String> title = [];
      for (int i = 0; i < sounds.length; i++) {
        if (sounds[i]['chek']) {
          url.add(sounds[i]['url']);
          title.add(sounds[i]['title']);
        }
      }
      GlobalRepo.share(url, title);
    }
  }

  void _download(BuildContext context) {
    if (!_chek()) {
      _choiseSnackBar(context);
    } else {
      for (int i = 0; i < sounds.length; i++) {
        if (sounds[i]['chek']) {
          GlobalRepo.download(
            sounds[i]['url'],
            sounds[i]['title'],
            context,
          );
        }
      }
    }
  }

  void _delete(BuildContext context) {
    if (!_chek()) {
      _choiseSnackBar(context);
    } else {
      for (int i = sounds.length - 1; i >= 0; i = i - 1) {
        if (sounds[i]['chek']) {
          Database.createOrUpdateSound(
            {
              'deleted': true,
              'dateDeleted': Timestamp.now(),
              'id': sounds[i]['id'],
            },
          );
        }
      }
      set();
    }
  }

  bool _chek() {
    bool chek = false;
    for (var map in sounds) {
      if (map.containsKey('chek')) {
        if (map['chek']) {
          chek = true;
        }
      }
    }
    return chek;
  }

  void _choiseSnackBar(BuildContext context) {
    GlobalRepo.showSnackBar(
      context: context,
      title: 'Перед этим нужно сделать выбор',
    );
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
        if (value == 0) cancel();
        if (value == 1) _addInCompilation(context);
        if (value == 2) _share(context);
        if (value == 3) _download(context);
        if (value == 4) _delete(context);
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
}
