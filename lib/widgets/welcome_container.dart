import 'package:flutter/material.dart';

class WelcomeContainer extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final double fontSize;

  const WelcomeContainer({
    Key? key,
    required this.text,
    required this.width,
    required this.height,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      elevation: 4.0,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'TTNormsL',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
