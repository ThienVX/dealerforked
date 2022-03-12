abstract class ForgetPasswordEvent {
  const ForgetPasswordEvent();
}

class ForgetPasswordPasswordChange extends ForgetPasswordEvent {
  const ForgetPasswordPasswordChange({
    required this.password,
  });

  final String password;

  @override
  List<Object> get props => [password];
}

class ForgetPasswordRepeatPasswordChanged extends ForgetPasswordEvent {
  const ForgetPasswordRepeatPasswordChanged({
    required this.repeatPassword,
  });

  final String repeatPassword;

  @override
  List<Object> get props => [repeatPassword];
}

class ForgetPasswordPasswordShowOrHide extends ForgetPasswordEvent {}

class ForgetPasswordRepeatPasswordShowOrHide extends ForgetPasswordEvent {}

class ForgetPasswordSubmmited extends ForgetPasswordEvent {}
