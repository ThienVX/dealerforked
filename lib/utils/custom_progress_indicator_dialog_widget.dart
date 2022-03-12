import 'package:flutter/material.dart';

import 'custom_widgets.dart';

class CustomProgressIndicatorDialog extends StatelessWidget {
  const CustomProgressIndicatorDialog({
    Key? key,
    this.text = 'Vui lòng đợi...',
    this.semanticLabel,
  }) : super(key: key);

  final String text;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  value: null,
                  semanticsLabel: semanticLabel,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: CustomWidgets.customText(
                    text: text,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
