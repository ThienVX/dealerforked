import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';

class RegisterCompleteView extends StatelessWidget {
  const RegisterCompleteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map _argumentMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: _body(context, _argumentMap),
    );
  }

  _body(context, argumentMap) {
    var _deviceSize = MediaQuery.of(context).size;
    return Container(
      width: _deviceSize.width,
      height: _deviceSize.height,
      padding: const EdgeInsets.fromLTRB(30, 100, 30, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomWidgets.customText(
                  text: CustomTexts.registerCompleteGreeting +
                      argumentMap['name'],
                  alignment: Alignment.center,
                  textAlign: TextAlign.center),
              CustomWidgets.customText(
                  text: CustomTexts.registerCompleteCongrat,
                  alignment: Alignment.center,
                  textAlign: TextAlign.center),
              CustomWidgets.customText(
                  text: CustomTexts.registerCompleteNote,
                  alignment: Alignment.center,
                  textAlign: TextAlign.center),
            ],
          ),
          _logoutButton(context),
        ],
      ),
    );
  }

  _logoutButton(context) {
    return CustomWidgets.customElevatedButton(
      context,
      CustomTexts.logoutButtonText,
      () {
        //TODO: logout
      },
    );
  }
}
