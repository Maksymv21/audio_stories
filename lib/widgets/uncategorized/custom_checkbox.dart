import 'package:flutter/material.dart';

//ignore: must_be_immutable
class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({
    Key? key,
    required this.value,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  bool value;
  Color color;
  void Function()? onTap;

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.95, 0.0),
      child: Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: Transform.scale(
          scale: 1.4,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.5,
                  color: widget.color,
                ),
              ),
              child: Transform.scale(
                scale: 0.5,
                child: Icon(
                  Icons.check,
                  size: 30.0,
                  color: widget.value ? widget.color : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
