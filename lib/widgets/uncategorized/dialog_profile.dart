import 'package:flutter/material.dart';

class DialogProfile extends StatelessWidget {
  final String title;
  final void Function() onPressedNo;
  final void Function() onPressedYes;

  const DialogProfile({
    Key? key,
    required this.title,
    required this.onPressedNo,
    required this.onPressedYes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ShapeBorder.lerp(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          const CircleBorder(),
          0.3),
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'Желаете продолжить?',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: onPressedNo,
              child: const Text(
                'Нет',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
            TextButton(
              onPressed: onPressedYes,
              child: const Text(
                'Да',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ],
    );
  }
}
