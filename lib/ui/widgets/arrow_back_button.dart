import 'package:flutter/material.dart';

class ArrowBackIconButton extends StatelessWidget {
  const ArrowBackIconButton({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: color,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
