import 'package:dealer_app/repositories/models/otp_code_model.dart';
import 'package:dealer_app/repositories/models/phone_number_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

enum TimerStatus { processed, resent, nothing, error }

class ForgetPassOTPState extends Equatable {
  const ForgetPassOTPState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.otpCode = const OTPCode.pure(),
    this.status = FormzStatus.pure,
    this.timerStatus = TimerStatus.nothing,
    this.token = Symbols.empty,
  });

  final PhoneNumber phoneNumber;
  final OTPCode otpCode;
  final FormzStatus status;
  final TimerStatus timerStatus;
  final String token;

  ForgetPassOTPState copyWith({
    PhoneNumber? phoneNumber,
    OTPCode? otpCode,
    FormzStatus? status,
    TimerStatus? timerStatus,
    String? token,
  }) {
    return ForgetPassOTPState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      status: status ?? this.status,
      timerStatus: timerStatus ?? this.timerStatus,
      token: token ?? this.token,
    );
  }

  @override
  List<Object> get props => [
        otpCode,
        status,
        timerStatus,
        token,
      ];
}
