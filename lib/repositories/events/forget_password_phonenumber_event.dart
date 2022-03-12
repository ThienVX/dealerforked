abstract class ForgetPasswordPhoneNumberEvent {
  const ForgetPasswordPhoneNumberEvent();
}

class ForgetPasswordPhoneNumberChanged extends ForgetPasswordPhoneNumberEvent {
  const ForgetPasswordPhoneNumberChanged(this.phoneNumber);

  final String phoneNumber;

  @override
  List<String> get props => [phoneNumber];
}

class ForgetPasswordPhoneNumberSubmmited
    extends ForgetPasswordPhoneNumberEvent {}
