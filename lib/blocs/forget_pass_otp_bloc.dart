import 'package:dealer_app/log/logger.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/services/identity_server_service.dart';
import 'package:dealer_app/repositories/events/forget_pass_otp_event.dart';
import 'package:dealer_app/repositories/models/otp_code_model.dart';
import 'package:dealer_app/repositories/models/phone_number_model.dart';
import 'package:dealer_app/repositories/states/forget_pass_otp_state.dart';
import 'package:dealer_app/utils/common_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ForgetPassOTPBloc extends Bloc<ForgetPassOTPEvent, ForgetPassOTPState> {
  ForgetPassOTPBloc({IdentityServerService? identityServerService})
      : super(const ForgetPassOTPState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }
  late final IdentityServerService _identityServerService;
  @override
  Stream<ForgetPassOTPState> mapEventToState(ForgetPassOTPEvent event) async* {
    if (event is ForgetPassOTPInitital) {
      var newState = state.copyWith(
        phoneNumber: PhoneNumber.pure(
          event.phoneNumber,
        ),
      );

      yield newState;
    } else if (event is ForgetPassOTPCodeChanged) {
      OTPCode otpCode = event.otpCode.isEmpty
          ? const OTPCode.pure()
          : OTPCode.dirty(event.otpCode);
      var newState = state.copyWith(
        otpCode: otpCode,
        status: Formz.validate([otpCode]),
      );

      yield newState;
    } else if (event is ForgetPassOTPSubmitted) {
      try {
        // yield for listener
        if (state.status.isValidated) {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          var token = await futureAppDuration(
            _identityServerService.confirmOTPRestorePass(
              state.phoneNumber.value,
              state.otpCode.value,
            ),
          );

          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            token: token,
          );
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    } else if (event is ForgetPassOTPResendPressed) {
      try {
        if (state.status.isInvalid ||
            state.status.isPure ||
            state.status.isInvalid) {
          yield state.copyWith(
            timerStatus: TimerStatus.processed,
          );

          var result = await futureAppDuration(
            _identityServerService
                .restorePassSendingOTP(state.phoneNumber.value),
          );
          //

          if (result) {
            yield state.copyWith(
              timerStatus: TimerStatus.resent,
            );
          }
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          timerStatus: TimerStatus.error,
        );
      }
      yield state.copyWith(
        timerStatus: TimerStatus.nothing,
      );
    }
  }
}
