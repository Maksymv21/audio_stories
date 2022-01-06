import 'package:flutter/material.dart';

class BurgerButton extends StatelessWidget {
  final String icon;
  final String title;

  const BurgerButton({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

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
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
