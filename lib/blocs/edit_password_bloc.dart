import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/services/identity_server_service.dart';
import 'package:dealer_app/repositories/events/edit_password_event.dart';
import 'package:dealer_app/repositories/models/password_model.dart';
import 'package:dealer_app/repositories/states/edit_password_state.dart';
import 'package:dealer_app/utils/common_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class EditPasswordBloc extends Bloc<EditPasswordEvent, EditPasswordState> {
  EditPasswordBloc(
      {IdentityServerService? identityServerService, required String id})
      : super(EditPasswordState(id: id)) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }
  late final IdentityServerService _identityServerService;
  @override
  Stream<EditPasswordState> mapEventToState(EditPasswordEvent event) async* {
    if (event is EditPassPasswordChange) {
      var password = Password.dirty(
        password: state.password.value.copyWith(
          value: event.password,
        ),
      );

      var repeatPassword = state.repeatPassword.pure
          ? RepeatPassword.pure(
              password: state.repeatPassword.value,
              currentPassword: event.password,
            )
          : RepeatPassword.dirty(
              password: state.repeatPassword.value,
              currentPassword: event.password,
            );

      yield state.copyWith(
        password: password,
        repeatPassword: repeatPassword,
        status: Formz.validate(
          [
            state.oldPassword,
            password,
            repeatPassword,
          ],
        ),
      );
    } else if (event is EditPassRepeatPasswordChanged) {
      var repeatPassword = RepeatPassword.dirty(
        password: state.repeatPassword.value.copyWith(
          value: event.repeatPassword,
        ),
        currentPassword: state.password.value.value,
      );
      yield state.copyWith(
        repeatPassword: repeatPassword,
        status: Formz.validate(
          [
            state.oldPassword,
            state.password,
            repeatPassword,
          ],
        ),
      );
    } else if (event is EditOldPasswordChange) {
      var oldPass = Password.dirty(
        password: state.oldPassword.value.copyWith(
          value: event.password,
        ),
      );
      yield state.copyWith(
        oldPassword: oldPass,
        status: Formz.validate(
          [
            oldPass,
            state.password,
            state.repeatPassword,
          ],
        ),
      );
    } else if (event is EditPassPasswordShowOrHide) {
      Password password;
      var commonPassword = state.password.value.copyWith(
        isHide: !state.password.value.isHide,
      );

      if (state.password.pure) {
        password = Password.pure(
          password: commonPassword,
        );
      } else {
        password = Password.dirty(
          password: commonPassword,
        );
      }

      yield state.copyWith(
        password: password,
        status: Formz.validate(
          [
            state.oldPassword,
            password,
            state.repeatPassword,
          ],
        ),
      );
    } else if (event is EditPassRepeatPasswordShowOrHide) {
      RepeatPassword password;
      var commonPassword = state.repeatPassword.value.copyWith(
        isHide: !state.repeatPassword.value.isHide,
      );

      if (state.repeatPassword.pure) {
        password = RepeatPassword.pure(
          password: commonPassword,
          currentPassword: state.password.value.value,
        );
      } else {
        password = RepeatPassword.dirty(
          password: commonPassword,
          currentPassword: state.password.value.value,
        );
      }

      yield state.copyWith(
        repeatPassword: password,
        status: Formz.validate(
          [
            state.oldPassword,
            state.password,
            password,
          ],
        ),
      );
    } else if (event is EditOldPasswordShowOrHide) {
      Password oldPassword;
      var commonPassword = state.oldPassword.value.copyWith(
        isHide: !state.oldPassword.value.isHide,
      );

      if (state.oldPassword.pure) {
        oldPassword = Password.pure(
          password: commonPassword,
        );
      } else {
        oldPassword = Password.dirty(
          password: commonPassword,
        );
      }

      yield state.copyWith(
        oldPassword: oldPassword,
        status: Formz.validate(
          [
            oldPassword,
            state.password,
            state.repeatPassword,
          ],
        ),
      );
    } else if (event is EditPassSubmmited) {
      Password oldPassword = Password.dirty(
        password: state.oldPassword.value.copyWith(
          value: state.oldPassword.value.value,
        ),
      );

      Password password = Password.dirty(
        password: state.password.value.copyWith(
          value: state.password.value.value,
        ),
      );
      RepeatPassword repeatPassword = RepeatPassword.dirty(
        password: state.repeatPassword.value.copyWith(
          value: state.repeatPassword.value.value,
        ),
        currentPassword: password.value.value,
      );

      yield state.copyWith(
        oldPassword: oldPassword,
        password: password,
        repeatPassword: repeatPassword,
        status: Formz.validate(
          [
            oldPassword,
            password,
            repeatPassword,
          ],
        ),
      );

      if (state.status.isValid) {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        try {
          var result = await futureAppDuration(
            _identityServerService.updatePassword(
              state.id,
              state.oldPassword.value.value,
              state.password.value.value,
            ),
          );

          if (result == NetworkConstants.ok200) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
              statusSubmmited: NetworkConstants.ok200,
            );
          } else if (result == 400) {
            yield state.copyWith(
              status: FormzStatus.submissionFailure,
              statusSubmmited: NetworkConstants.badRequest400,
            );
          } else {
            throw Exception();
          }
        } catch (e) {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
      }
    }
  }
}
