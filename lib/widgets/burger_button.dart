import 'package:flutter/material.dart';

class BurgerButton extends StatefulWidget {
  final String icon;
  final String title;
  final void Function() onTap;

  const BurgerButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  State<BurgerButton> createState() => _BurgerButtonState();
}

class _BurgerButtonState extends State<BurgerButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0.0),
      child: SizedBox(
        height: 43.0,
        child: Theme(
          data: ThemeData(
            fontFamily: 'TTNorms',
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: ListTile(
            onTap: widget.onTap,
            minLeadingWidth: 0.0,
            leading: ImageIcon(
              Image.asset(widget.icon).image,
              color: Colors.black,
            ),
            title: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
