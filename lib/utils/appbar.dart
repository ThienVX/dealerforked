import 'package:flutter/material.dart';

class CustomAppBar {
  static AppBar buildAppBar({
    required BuildContext context,
    Color? color,
    Color? backgroundColor,
    double? elevation,
    List<Widget>? action,
    Widget? title,
    bool? centerTitle,
  }) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          color: color ?? Color.fromARGB(255, 181, 181, 181),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: elevation ?? 0,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      actions: action,
      title: title,
      centerTitle: centerTitle,
    );
  }
}
