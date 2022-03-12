import 'package:dealer_app/repositories/handlers/authentication_handler.dart';
import 'package:dealer_app/repositories/models/dealer_info_model.dart';
import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final DealerInfoModel? user;

  const AuthenticationState({
    AuthenticationStatus? status,
    DealerInfoModel? user,
  })  : this.status = status ?? AuthenticationStatus.unknown,
        this.user = user;

  const AuthenticationState.unknown()
      : this.status = AuthenticationStatus.unknown,
        this.user = null;

  const AuthenticationState.authenticated({required DealerInfoModel user})
      : this.status = AuthenticationStatus.authenticated,
        this.user = user;

  const AuthenticationState.unauthenticated()
      : this.status = AuthenticationStatus.unauthenticated,
        this.user = null;

  @override
  List<Object?> get props => [status, user];
}
