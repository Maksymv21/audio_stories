import 'package:flutter/material.dart';

class CompilationContainer extends StatelessWidget {
  final String url;
  final double height;
  final String title;
  final int length;
  final double width;

  const CompilationContainer({
    Key? key,
    required this.url,
    required this.height,
    required this.title,
    required this.length,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: Image.network(url).image,
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ],
          ),
        ),
        Container(
          height: height * 0.4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.transparent,
                Color(0xff454545),
              ],
              stops: [0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Text(
                  '$length аудио'
                  '\n0 часов',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
