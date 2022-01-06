import 'package:audio_stories/Widgets/burger_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 100.0,
          ),
          const Text(
            'Аудиосказки',
            style: TextStyle(
              fontSize: 26.0,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            'Меню',
            style: TextStyle(
              fontSize: 22.0,
              color: Color.fromRGBO(58, 58, 85, 0.5),
            ),
          ),
          const SizedBox(
            height: 70.0,
          ),
          Column(
            children: const [
              BurgerButton(
                icon: AppIcons.home,
                title: 'Главная',
              ),
              BurgerButton(
                icon: AppIcons.profile,
                title: 'Профиль',
              ),
              BurgerButton(
                icon: AppIcons.category,
                title: 'Подборки',
              ),
              BurgerButton(
                icon: AppIcons.paper,
                title: 'Все аудиофайлы',
              ),
              BurgerButton(
                icon: AppIcons.search,
                title: 'Поиск',
              ),
              BurgerButton(
                icon: AppIcons.delete,
                title: 'Недавно удаленные',
              ),
              SizedBox(
                height: 30.0,
              ),
              BurgerButton(
                icon: AppIcons.wallet,
                title: 'Подписка',
              ),
              SizedBox(
                height: 30.0,
              ),
              BurgerButton(
                icon: AppIcons.edit,
                title: 'Написать в '
                    '\nподдержку',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
