import 'package:flutter/material.dart';

class FootButton extends StatelessWidget {
  final String icon;
  final String title;
  final Color color;
  final void Function() onPressed;

  const FootButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: onPressed,
          icon: Image.asset(
            icon,
            color: color,
          ),
          iconSize: 20.0,
        ),
        Align(
          heightFactor: 0.0,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10.0,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
