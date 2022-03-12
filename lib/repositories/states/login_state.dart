import 'package:dealer_app/utils/param_util.dart';

class LoginState {
  String phone;
  String password;

  Process process;
  bool isPasswordObscured;

  bool get isPhoneValid => RegExp(CustomRegexs.phoneRegex).hasMatch(phone);
  bool get isPasswordValid =>
      RegExp(CustomRegexs.passwordRegex).hasMatch(password);

  LoginState(
      {String? phone,
      String? password,
      Process? process,
      bool? isPasswordObscured})
      : phone = phone ?? '',
        password = password ?? '',
        process = process ?? Process.neutral,
        isPasswordObscured = isPasswordObscured ?? true;

  LoginState copyWith(
      {String? phone,
      String? password,
      Process? process,
      bool? isPasswordObscured}) {
    return LoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      process: process ?? this.process,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
    );
  }
}
