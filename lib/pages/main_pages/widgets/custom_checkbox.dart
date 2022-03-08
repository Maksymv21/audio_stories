import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({Key? key}) : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: const AlignmentDirectional(0.95, 0.0),
      child: Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: Transform.scale(
          scale: 1.4,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                _value = !_value;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.5,
                  color: Colors.black87,
                ),
              ),
              child: Transform.scale(
                scale: 0.5,
                child: Icon(
                  Icons.check,
                  size: 30.0,
                  color: _value ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
