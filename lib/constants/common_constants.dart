import 'package:flutter/cupertino.dart';

class NetworkConstants {
  static const urlencoded = 'application/x-www-form-urlencoded';
  static const applicationJson = 'application/json';
  static const postType = 'POST';
  static const getType = 'GET';

  // status code
  static const ok200 = 200;
  static const badRequest400 = 400;
  static const unauthorized401 = 401;
  static const notFound404 = 404;
  static const statusCode = 'statusCode';
  static const isSuccess = 'isSuccess';
}

class DeviceConstants {
  static const double logicalWidth = 1080;
  static const double logicalHeight = 2220;
}

class WidgetConstants {
  static const double buttonCommonFrontSize = 50;
  static const FontWeight buttonCommonFrontWeight = FontWeight.w500;
  static const double buttonCommonHeight = 120;
}

class Others {
  static const int otpLength = 6;

  static final String ddMMyyyyPattern = 'dd-MM-yyyy';
}
