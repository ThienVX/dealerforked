import 'package:dealer_app/utils/param_util.dart';

class RegisterOTPState {
  String phone;
  String otp;

  bool get isOTPValid => RegExp(CustomRegexs.otpRegex).hasMatch(otp);

  int timer;
  Process process;

  RegisterOTPState({
    required phone,
    otp,
    timer,
    process,
  })  : phone = phone,
        otp = otp ?? '',
        timer = timer ?? 0,
        process = process ?? Process.neutral;

  RegisterOTPState copyWith({
    String? phone,
    String? otp,
    int? timer,
    Process? process,
  }) {
    return RegisterOTPState(
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      timer: timer ?? this.timer,
      process: process ?? this.process,
    );
  }
}
