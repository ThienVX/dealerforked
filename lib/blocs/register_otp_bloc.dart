import 'dart:async';

import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/register_otp_event.dart';
import 'package:dealer_app/repositories/states/register_otp_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterOTPBloc extends Bloc<RegisterOTPEvent, RegisterOTPState> {
  RegisterOTPBloc({required RegisterOTPState initialState})
      : super(initialState);

  final _ticker = getIt.get<ITicker>();

  StreamSubscription<int>? _tickerSubscription;

  @override
  Stream<RegisterOTPState> mapEventToState(RegisterOTPEvent event) async* {
    if (event is EventOTPChanged) {
      yield state.copyWith(otp: event.otp);
    } else if (event is EventResendOTP) {
      //TODO: resend OTP
      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker
          .tick(ticks: CustomTickerDurations.resendOTPDuration)
          .listen((value) => add(EventTickerTicked(second: value)));
    } else if (event is EventTickerTicked) {
      yield state.copyWith(timer: event.second);
      if (event.second > 0) {
        yield state.copyWith(timer: event.second);
      } else {
        _tickerSubscription?.cancel();
      }
    } else if (event is EventCheckOTP) {
      //start progress indicator
      yield state.copyWith(process: Process.processing);
      try {
        //TODO: send OTP
        await Future.delayed(Duration(seconds: 5));
        yield state.copyWith(process: Process.processed);
        yield state.copyWith(process: Process.valid);
      } on Exception {
        yield state.copyWith(process: Process.processed);
        yield state.copyWith(process: Process.error);
      } finally {
        yield state.copyWith(process: Process.neutral);
      }
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
