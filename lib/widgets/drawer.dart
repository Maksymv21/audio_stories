import 'package:audio_stories/bloc/bloc_icon_color.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/widgets/burger_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorBloc _bloc = BlocProvider.of<ColorBloc>(context);
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
                onTap: () {
                  Utils.globalKey.currentState!.pushReplacementNamed('/');
                  Scaffold.of(context).openEndDrawer();
                  _bloc.add(ColorHome());
                },
              ),
              BurgerButton(
                icon: AppIcons.profile,
                title: 'Профиль',
                onTap: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed('/profile');
                  Scaffold.of(context).openEndDrawer();
                  _bloc.add(ColorProfile());
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
