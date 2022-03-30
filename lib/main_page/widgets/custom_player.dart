import 'package:audio_stories/main_page/widgets/player_container.dart';
import 'package:flutter/material.dart';

import '../../../repositories/global_repository.dart';

//ignore: must_be_immutable
class CustomPlayer extends StatelessWidget {
  void Function(DismissDirection)? onDismissed;
  String url;
  String id;
  String title;
  String routName;

  CustomPlayer({
    Key? key,
    required this.onDismissed,
    required this.url,
    required this.id,
    required this.title,
    required this.routName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key(''),
      direction: DismissDirection.down,
      onDismissed: onDismissed,
      child: PlayerContainer(
        title: title,
        url: url,
        id: id,
        onPressed: () => GlobalRepo.toPlayPage(
          context: context,
          url: url,
          title: title,
          id: id,
          routName: routName,
        ),
      ),
    );
  }
}
