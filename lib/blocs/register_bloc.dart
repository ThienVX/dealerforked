import 'package:dealer_app/repositories/events/register_event.dart';
import 'package:dealer_app/repositories/states/register_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required RegisterState initialState}) : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is EventPhoneNumberChanged) {
      yield state.copyWith(phone: event.phoneNumber);
    } else if (event is EventSendOTP) {
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
}
