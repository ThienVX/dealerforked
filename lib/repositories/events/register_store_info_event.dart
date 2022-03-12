import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class RegisterStoreInfoEvent extends Equatable {}

class EventStoreNameChanged extends RegisterStoreInfoEvent {
  final String storeName;

  EventStoreNameChanged({required this.storeName});

  @override
  List<String> get props => [storeName];
}

class EventStorePhoneChanged extends RegisterStoreInfoEvent {
  final String storePhone;

  EventStorePhoneChanged({required this.storePhone});

  @override
  List<String> get props => [storePhone];
}

class EventStoreAddressChanged extends RegisterStoreInfoEvent {
  final String storeAddress;

  EventStoreAddressChanged({required this.storeAddress});

  @override
  List<String> get props => [storeAddress];
}

class EventOpenImagePicker extends RegisterStoreInfoEvent {
  final ImageSource imageSource;

  EventOpenImagePicker({required this.imageSource});

  @override
  List<String> get props => [];
}

class EventNextButtonPressed extends RegisterStoreInfoEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeStoreImageRequest extends RegisterStoreInfoEvent {
  @override
  List<Object?> get props => [];
}
