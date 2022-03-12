import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  static OutlinedButton customCancelButton(context, text) {
    return OutlinedButton(
      style:
          ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey)),
      onPressed: () => Navigator.pop(context),
      child: Text(text),
    );
  }

  static ElevatedButton customElevatedButton(context, text, action) {
    return ElevatedButton(onPressed: action, child: Text(text));
  }

  static OutlinedButton customSecondaryButton({
    required String text,
    Function()? action,
    MaterialStateProperty<Color?>? textColor,
    MaterialStateProperty<Color?>? backgroundColor,
  }) {
    return OutlinedButton(
      onPressed: action ?? () {},
      child: Text(text),
      style: ButtonStyle(
        foregroundColor: textColor ?? MaterialStateProperty.all(Colors.grey),
        backgroundColor:
            backgroundColor ?? MaterialStateProperty.all(Colors.grey),
      ),
    );
  }

  static AppBar customAppBar(
      {required BuildContext context, required String titleText}) {
    return AppBar(
      elevation: 1,
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  static Widget customErrorWidget() {
    return Container(
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            Text('Đã có lỗi xảy ra'),
          ],
        ),
      ),
    );
  }

  static CircleAvatar customAvatar({ImageProvider? avatar}) {
    return CircleAvatar(
      backgroundColor: Colors.green,
      backgroundImage: AssetImage('assets/images/avatar_male_399x425.png'),
      foregroundImage: avatar != null ? avatar : null,
    );
  }

  static Widget customText(
      {required String text,
      Alignment? alignment,
      double? fontSize,
      TextAlign? textAlign,
      Color? color,
      double? height,
      TextStyle? textStyle,
      FontWeight? fontWeight}) {
    return Container(
      height: height ?? 50,
      alignment: alignment ?? Alignment.centerLeft,
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              fontSize: fontSize ?? 15,
              color: color ?? Color.fromARGB(255, 20, 20, 21),
              fontWeight: fontWeight,
            ),
        textAlign: textAlign ?? TextAlign.left,
      ),
    );
  }

  static Widget customTextButton(
      {required String text,
      Alignment? alignment,
      double? fontSize,
      onPressed}) {
    return Container(
      height: 50,
      alignment: alignment ?? Alignment.centerLeft,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize ?? 15, color: AppColors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static Widget customDateText(
      {required DateTime time,
      Alignment? alignment,
      double? fontSize,
      TextAlign? textAlign,
      Color? color,
      double? height,
      TextStyle? textStyle,
      FontWeight? fontWeight}) {
    String weekday = '';
    switch (time.weekday) {
      case 1:
        weekday = 'Th 2';
        break;
      case 2:
        weekday = 'Th 3';
        break;
      case 3:
        weekday = 'Th 4';
        break;
      case 4:
        weekday = 'Th 5';
        break;
      case 5:
        weekday = 'Th 6';
        break;
      case 6:
        weekday = 'Th 7';
        break;
      case 7:
        weekday = 'CN';
        break;
      default:
    }
    return Container(
      height: height ?? 50,
      alignment: alignment ?? Alignment.centerLeft,
      child: Text(
        '$weekday, ${time.day} thg ${time.month}',
        style: textStyle ??
            TextStyle(
              fontSize: fontSize ?? 15,
              color: color ?? Color.fromARGB(255, 20, 20, 21),
              fontWeight: fontWeight,
            ),
        textAlign: textAlign ?? TextAlign.left,
      ),
    );
  }
}
