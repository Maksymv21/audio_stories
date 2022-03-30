import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final Timestamp date;
  final int length;
  final Widget? child;

  const ImageContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.url,
    required this.date,
    required this.length,
    this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: [
          Container(
            width: width * 0.9,
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: Image
                    .network(url)
                    .image,
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
            width: width * 0.9,
            height: height * 0.3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xff454545),
                ],
                stops: [0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(
                    -0.85,
                    -0.9,
                  ),
                  child: Text(
                    _convertDate(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(
                    -0.85,
                    0.9,
                  ),
                  child: Text(
                    '$length аудио'
                        '\n0 часов',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.85, 0.85),
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _convertDate(Timestamp date) {
    final String dateTime = date.toDate().toString();
    final String result = dateTime.substring(8, 10) +
        '.' +
        dateTime.substring(5, 7) +
        '.' +
        dateTime.substring(2, 4);
    return result;
  }
}
