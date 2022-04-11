import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final double height;
  final String image;
  final Widget child;

  const Background({
    Key? key,
    required this.height,
    required this.image,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: Image.asset(
            image,
          ).image,
        ),
      ),
      child: child,
    );
  }
}
