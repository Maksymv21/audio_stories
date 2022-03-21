import 'package:flutter/material.dart';

class CustomWillPopScope extends StatefulWidget {
  final Widget child;

  const CustomWillPopScope({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<CustomWillPopScope> createState() => _CustomWillPopScopeState();
}

class _CustomWillPopScopeState extends State<CustomWillPopScope> {
  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: widget.child,
      onWillPop: () async {
        final now = DateTime.now();
        const maxDuration = Duration(seconds: 2);
        final isWarning =
            lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          lastPressed = DateTime.now();

          const SnackBar snackBar = SnackBar(
            content: Text(
              'Нажмите еще раз чтобы выйти',
              textAlign: TextAlign.center,
            ),
            duration: maxDuration,
          );

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);

          return false;
        } else {
          return true;
        }
      },
    );
  }
}
