import 'package:flutter/material.dart';

class BurgerButton extends StatelessWidget {
  const BurgerButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final String icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0.0),
      child: SizedBox(
        height: 43.0,
        child: Theme(
          data: ThemeData(
            fontFamily: 'TTNorms',
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: ListTile(
            onTap: onTap,
            minLeadingWidth: 0.0,
            leading: ImageIcon(
              Image.asset(icon).image,
              color: Colors.black,
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
