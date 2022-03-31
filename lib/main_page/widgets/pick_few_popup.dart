import 'package:flutter/material.dart';

//ignore: must_be_immutable
class PickFewPopup extends StatelessWidget {
  const PickFewPopup({
    Key? key,
    required this.pickFew,
  }) : super(key: key);

  final void Function() pickFew;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) pickFew();
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 0,
          child: Text(
            'Выбрать несколько',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ],
      child: const Text(
        '...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 48.0,
          letterSpacing: 3.0,
        ),
      ),
    );
  }
}
