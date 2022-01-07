import 'package:audio_stories/resources/app_colors.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/widgets/burger_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

class BurgerMenu extends StatefulWidget {
  const BurgerMenu({Key? key}) : super(key: key);

  @override
  State<BurgerMenu> createState() => _BurgerMenuState();
}

class _BurgerMenuState extends State<BurgerMenu> {
  final ColorActive _colorIcon = ColorActive();

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
            children: [
              BurgerButton(
                icon: AppIcons.home,
                title: 'Главная',
                onTap: () {},
              ),
              BurgerButton(
                icon: AppIcons.profile,
                title: 'Профиль',
                onTap: () {
                  setState(() {
                    Utils.globalKey.currentState!.pushReplacementNamed('/profile');
                    Scaffold.of(context).openEndDrawer();
                    _colorIcon.profileActive();
                  });
                },
              ),
              BurgerButton(
                icon: AppIcons.category,
                title: 'Подборки',
                onTap: () {},
              ),
              BurgerButton(
                icon: AppIcons.paper,
                title: 'Все аудиофайлы',
                onTap: () {},
              ),
              BurgerButton(
                icon: AppIcons.search,
                title: 'Поиск',
                onTap: () {},
              ),
              BurgerButton(
                icon: AppIcons.delete,
                title: 'Недавно удаленные',
                onTap: () {},
              ),
              const SizedBox(
                height: 30.0,
              ),
              BurgerButton(
                icon: AppIcons.wallet,
                title: 'Подписка',
                onTap: () {},
              ),
              const SizedBox(
                height: 30.0,
              ),
              BurgerButton(
                icon: AppIcons.edit,
                title: 'Написать в '
                    '\nподдержку',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
