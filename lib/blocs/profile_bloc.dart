import 'package:dealer_app/log/logger.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/services/identity_server_service.dart';
import 'package:dealer_app/repositories/events/profile_event.dart';
import 'package:dealer_app/repositories/states/profile_state.dart';
import 'package:dealer_app/utils/common_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({IdentityServerService? identityServerService})
      : super(ProfileState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  late final IdentityServerService _identityServerService;

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileInitial) {
      if (state.status != FormzStatus.submissionInProgress) {
        try {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          var newState =
              await futureAppDuration(_identityServerService.getProfile());

          if (newState != null) {
            yield state.copyWith(
              id: newState.id,
              address: newState.address,
              birthDate: newState.birthDate,
              email: newState.email,
              gender: newState.gender,
              image: newState.image,
              name: newState.name,
              phone: newState.phone,
              totalPoint: newState.totalPoint,
              idCard: newState.idCard,
              status: FormzStatus.submissionSuccess,
              dealerType: newState.dealerType,
            );
          } else {
            throw Exception('New Sate is null');
          }
        } catch (e) {
          AppLog.error(e);
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
      }
    } else if (event is ProfileClear) {
      try {
        yield ProfileState();
      } catch (e) {
        AppLog.error(e);
      }
    }
  }
}
