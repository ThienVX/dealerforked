import 'package:dealer_app/utils/param_util.dart';

class RegisterState {
  String phone;

  Process process;

  bool get isPhoneValid => RegExp(CustomRegexs.phoneRegex).hasMatch(phone);

  RegisterState({
    phone,
    process,
  })  : phone = phone ?? '',
        process = process ?? Process.neutral;

  RegisterState copyWith({
    String? phone,
    Process? process,
  }) {
    return RegisterState(
      phone: phone ?? this.phone,
      process: process ?? this.process,
    );
  }
}
