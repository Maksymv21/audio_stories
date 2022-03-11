import 'package:flutter/material.dart';

import '../../../resources/app_color.dart';
import '../../../resources/app_icons.dart';
import '../../main_pages/widgets/foot_button.dart';

//ignore: must_be_immutable
class DeleteBottomBar extends StatelessWidget {
  void Function() rees;
  void Function() delete;

  DeleteBottomBar({
    Key? key,
    required this.rees,
    required this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FootButton(
            icon: AppIcons.arrows,
            title: 'Восстановить',
            color: AppColor.disActive,
            onPressed: rees,
          ),
          FootButton(
            icon: AppIcons.delete,
            title: 'Удалить',
            color: AppColor.disActive,
            onPressed: delete,
          ),
        ],
      ),
    );
  }
}
