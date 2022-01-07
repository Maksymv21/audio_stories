import 'package:flutter/material.dart';

class FootButton extends StatefulWidget {
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
  State<FootButton> createState() => _FootButtonState();
}

class _FootButtonState extends State<FootButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          // color: const Color.fromRGBO(58, 58,85, 0.8),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: widget.onPressed,
          icon: Image.asset(
            widget.icon,
            color: widget.color,
            // color: const Color.fromRGBO(140, 132, 226, 1),
          ),
          iconSize: 20.0,
        ),
        Align(
          heightFactor: 0.0,
          child: Text(
            widget.title,
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
