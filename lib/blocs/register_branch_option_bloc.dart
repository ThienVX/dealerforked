import 'package:dealer_app/repositories/events/register_branch_option_event.dart';
import 'package:dealer_app/repositories/states/register_branch_option_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBranchOptionBloc
    extends Bloc<RegisterBranchOptionEvent, RegisterBranchOptionState> {
  RegisterBranchOptionBloc({required RegisterBranchOptionState initialState})
      : super(initialState);

  @override
  Stream<RegisterBranchOptionState> mapEventToState(
      RegisterBranchOptionEvent event) async* {
    if (event is EventIsBranchChanged) {
      yield state.copyWith(isBranch: event.isBranch);
    } else if (event is EventMainBranchChanged) {
      yield state.copyWith(mainBranchId: event.mainBranchId);
    } else if (event is EventNextButtonPressed) {
      yield state.copyWith(process: Process.valid);
      yield state.copyWith(process: Process.neutral);
    }
  }
}
