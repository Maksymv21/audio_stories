import 'package:flutter/material.dart';

class FootButton extends StatelessWidget {
  final String icon;
  final String title;

  const FootButton({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {},
          icon: Image.asset(
            icon,
            // color: const Color.fromRGBO(140, 132, 226, 1),
          ),
          iconSize: 20.0,
        ),
        Align(
          heightFactor: 0.0,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10.0,
              color: Color.fromRGBO(58, 58, 85, 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
