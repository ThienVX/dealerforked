import 'package:dealer_app/providers/configs/flavor_config.dart';
import 'package:dealer_app/providers/services/firebase_service.dart';
import 'package:dealer_app/repositories/handlers/authentication_handler.dart';
import 'package:dealer_app/repositories/handlers/user_handler.dart';
import 'package:dealer_app/ui/app.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/configs/injection_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  // Load env
  await dotenv.load(fileName: EnvAppSetting.dev);
  // Add Flavor
  FlavorConfiguration.addFlavorConfig(
      EnvBaseAppSettingValue.flavor, Colors.green);
  configureDependencies();
  final firebase = getIt.get<FirebaseNotification>();
  await firebase.initialize();
  print(await firebase.getToken());
  runApp(DealerApp(
    authenticationHandler: AuthenticationHandler(),
    userHandler: UserHandler(),
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.green
    ..textColor = Colors.green
    ..maskType = EasyLoadingMaskType.black
    ..indicatorWidget = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 60, height: 60, child: CircularProgressIndicator()),
        Image.asset(
          CustomAssets.logo,
          height: 40,
          width: 40,
        ),
      ],
    )
    ..userInteractions = false
    ..dismissOnTap = true;
}
