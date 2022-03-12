import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/register_store_info_event.dart';
import 'package:dealer_app/repositories/states/register_store_info_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterStoreInfoBloc
    extends Bloc<RegisterStoreInfoEvent, RegisterStoreInfoState> {
  RegisterStoreInfoBloc({required RegisterStoreInfoState initialState})
      : super(initialState);

  final _picker = getIt.get<ImagePicker>();

  @override
  Stream<RegisterStoreInfoState> mapEventToState(
      RegisterStoreInfoEvent event) async* {
    if (event is EventStoreNameChanged) {
      yield state.copyWith(storeName: event.storeName);
    } else if (event is EventStoreAddressChanged) {
      yield state.copyWith(storeAddress: event.storeAddress);
    } else if (event is EventStorePhoneChanged) {
      yield state.copyWith(storePhone: event.storePhone);
    } else if (event is EventChangeStoreImageRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
    } else if (event is EventOpenImagePicker) {
      yield state.copyWith(isImageSourceActionSheetVisible: false);
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage != null) {
        yield state.copyWith(pickedImageUrl: pickedImage.path);
      } else
        return;
    } else if (event is EventNextButtonPressed) {
      //TODO: send registration request
      yield state.copyWith(process: Process.valid);
      yield state.copyWith(process: Process.neutral);
    }
  }
}
