import 'package:dealer_app/utils/param_util.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterPersonalInfoEvent extends Equatable {}

class EventNameChanged extends RegisterPersonalInfoEvent {
  final String name;

  EventNameChanged({required this.name});

  @override
  List<String> get props => [name];
}

class EventIdChanged extends RegisterPersonalInfoEvent {
  final String id;

  EventIdChanged({required this.id});

  @override
  List<String> get props => [id];
}

class EventBirthdateChanged extends RegisterPersonalInfoEvent {
  final DateTime birthdate;

  EventBirthdateChanged({required this.birthdate});

  @override
  List<DateTime> get props => [birthdate];
}

class EventAddressChanged extends RegisterPersonalInfoEvent {
  final String address;

  EventAddressChanged({required this.address});

  @override
  List<String> get props => [address];
}

class EventSexChanged extends RegisterPersonalInfoEvent {
  final Sex sex;

  EventSexChanged({required this.sex});

  @override
  List<Sex> get props => [sex];
}

class EventPasswordChanged extends RegisterPersonalInfoEvent {
  final String password;

  EventPasswordChanged({required this.password});

  @override
  List<String> get props => [password];
}

class EventRePasswordChanged extends RegisterPersonalInfoEvent {
  final String rePassword;

  EventRePasswordChanged({required this.rePassword});

  @override
  List<String> get props => [rePassword];
}

class EventNextButtonPressed extends RegisterPersonalInfoEvent {
  @override
  List<Object?> get props => [];
}
