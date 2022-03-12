import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {}

class EventPhoneNumberChanged extends RegisterEvent {
  final String phoneNumber;

  EventPhoneNumberChanged({required this.phoneNumber});

  @override
  List<String> get props => [phoneNumber];
}

class EventSendOTP extends RegisterEvent {
  @override
  List<Object?> get props => [];
}
