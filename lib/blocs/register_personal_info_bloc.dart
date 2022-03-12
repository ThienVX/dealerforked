import 'package:dealer_app/repositories/events/register_personal_info_event.dart';
import 'package:dealer_app/repositories/states/register_personal_info_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPersonalInfoBloc
    extends Bloc<RegisterPersonalInfoEvent, RegisterPersonalInfoState> {
  RegisterPersonalInfoBloc({required RegisterPersonalInfoState initialState})
      : super(initialState);

  @override
  Stream<RegisterPersonalInfoState> mapEventToState(
      RegisterPersonalInfoEvent event) async* {
    if (event is EventNameChanged) {
      yield state.copyWith(name: event.name);
    } else if (event is EventIdChanged) {
      yield state.copyWith(id: event.id);
    } else if (event is EventBirthdateChanged) {
      yield state.copyWith(birthdate: event.birthdate);
    } else if (event is EventAddressChanged) {
      yield state.copyWith(address: event.address);
    } else if (event is EventSexChanged) {
      yield state.copyWith(sex: event.sex);
    } else if (event is EventPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is EventRePasswordChanged) {
      yield state.copyWith(rePassword: event.rePassword);
    } else if (event is EventNextButtonPressed) {
      yield state.copyWith(process: Process.valid);
      yield state.copyWith(process: Process.neutral);
    }
  }
}
