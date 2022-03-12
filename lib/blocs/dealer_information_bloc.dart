import 'package:dealer_app/log/logger.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/services/identity_server_service.dart';
import 'package:dealer_app/repositories/events/dealer_information_event.dart';
import 'package:dealer_app/repositories/states/dealer_information_state.dart';
import 'package:dealer_app/utils/common_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class DealerInformationBloc
    extends Bloc<DealerInformationEvent, DealerInformationState> {
  DealerInformationBloc({IdentityServerService? identityServerService})
      : super(DealerInformationState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  late IdentityServerService _identityServerService;

  @override
  Stream<DealerInformationState> mapEventToState(
      DealerInformationEvent event) async* {
    if (event is DealerInformationInitial) {
      if (state.status != FormzStatus.submissionInProgress) {
        try {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          var newState = await futureAppDuration(
              _identityServerService.getDealerInformation());

          yield newState.copyWith(
            status: FormzStatus.submissionSuccess,
          );
        } catch (e) {
          AppLog.error(e);
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
      }
    } else if (event is DealerInformationClear) {
      try {
        yield DealerInformationState();
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is ModifyActivationSwitch) {
      try {
        bool expected = !state.isActive;
        var result = await futureAppDuration(
            _identityServerService.changeDealerStatus(expected));
        yield state.copyWith(isActive: expected);
        if (result) {
        } else {
          throw Exception('result is false');
        }
      } catch (e) {
        AppLog.error(e);
      }
    }
  }
}
