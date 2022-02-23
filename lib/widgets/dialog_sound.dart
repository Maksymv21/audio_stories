import 'package:flutter/material.dart';

class DialogSound extends StatelessWidget {
  final String title;
  final void Function() onPressedCancel;
  final void Function()? onPressedSave;
  final Widget content;

  const DialogSound({
    Key? key,
    required this.title,
    required this.onPressedCancel,
    required this.onPressedSave,
    required this.content,
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
      content: content,
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: onPressedCancel,
              child: const Text(
                'Отмена',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
            TextButton(
              onPressed: onPressedSave,
              child: const Text(
                'Сохранить',
                style: TextStyle(
                  color: Colors.black,
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
