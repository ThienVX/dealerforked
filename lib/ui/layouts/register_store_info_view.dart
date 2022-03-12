import 'dart:io';

import 'package:dealer_app/blocs/register_store_info_bloc.dart';
import 'package:dealer_app/repositories/events/register_store_info_event.dart';
import 'package:dealer_app/repositories/states/register_store_info_state.dart';

import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterStoreInfoView extends StatelessWidget {
  RegisterStoreInfoView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map _argumentMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (context) {
        return RegisterStoreInfoBloc(
            initialState: RegisterStoreInfoState(
          phone: _argumentMap['phone'],
          name: _argumentMap['name'],
          id: _argumentMap['id'],
          birthdate: _argumentMap['birthdate'],
          address: _argumentMap['address'],
          sex: _argumentMap['sex'],
          password: _argumentMap['password'],
          isBranch: _argumentMap['isBranch'],
          mainBranchId: _argumentMap['mainBranchId'],
        ));
      },
      child: BlocListener<RegisterStoreInfoBloc, RegisterStoreInfoState>(
        listener: (context, state) {
          if (state.isImageSourceActionSheetVisible) {
            _showImageSourceActionSheet(context);
          } else if (state.process == Process.valid) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              CustomRoutes.registerComplete,
              (route) => false,
              arguments: <String, dynamic>{
                'name': state.name,
              },
            );
          }
        },
        child: BlocBuilder<RegisterStoreInfoBloc, RegisterStoreInfoState>(
          builder: (context, state) {
            return Scaffold(
              appBar: _appBar(context),
              body: _body(),
            );
          },
        ),
      ),
    );
  }

  _appBar(context) {
    return AppBar(
      title: Text(
        CustomTexts.appBarStoreInfoText,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  _body() {
    return BlocBuilder<RegisterStoreInfoBloc, RegisterStoreInfoState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomWidgets.customText(text: CustomTexts.storeFrontImageText),
                _scrapImage(),
                _storeNameField(),
                _storePhoneField(),
                _storeAddressField(),
                _submitButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  _scrapImage() {
    return BlocBuilder<RegisterStoreInfoBloc, RegisterStoreInfoState>(
      builder: (context, state) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(10),
          child: Center(
            child: InkWell(
              onTap: () {
                context
                    .read<RegisterStoreInfoBloc>()
                    .add(EventChangeStoreImageRequest());
              },
              child: state.isImagePicked
                  ? Image.file(File(state.pickedImageUrl))
                  : Icon(
                      Icons.add_a_photo,
                      size: 100,
                    ),
            ),
          ),
        );
      },
    );
  }

  _storeNameField() {
    return BlocBuilder<RegisterStoreInfoBloc, RegisterStoreInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.storeNameLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) => context
                .read<RegisterStoreInfoBloc>()
                .add(EventStoreNameChanged(storeName: value)),
            validator: (value) {
              if (value == null || value.isEmpty)
                return CustomTexts.storeNameBlank;
            },
          ),
        );
      },
    );
  }

  _storePhoneField() {
    return BlocBuilder<RegisterStoreInfoBloc, RegisterStoreInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.storePhoneLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) => context
                .read<RegisterStoreInfoBloc>()
                .add(EventStorePhoneChanged(storePhone: value)),
            validator: (value) {
              if (value == null || value.isEmpty)
                return CustomTexts.storePhoneBlank;
              if (!state.isStorePhoneValid) return CustomTexts.storePhoneError;
            },
          ),
        );
      },
    );
  }

  _storeAddressField() {
    return BlocBuilder<RegisterStoreInfoBloc, RegisterStoreInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.storeAddressLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            onChanged: (value) => context
                .read<RegisterStoreInfoBloc>()
                .add(EventStoreAddressChanged(storeAddress: value)),
            validator: (value) {
              if (value == null || value.isEmpty)
                return CustomTexts.storeAddressBlank;
            },
          ),
        );
      },
    );
  }

  _submitButton() {
    return BlocBuilder<RegisterStoreInfoBloc, RegisterStoreInfoState>(
      builder: (context, state) {
        return CustomWidgets.customElevatedButton(
          context,
          CustomTexts.next,
          () {
            if (_formKey.currentState!.validate())
              context
                  .read<RegisterStoreInfoBloc>()
                  .add(EventNextButtonPressed());
          },
        );
      },
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<RegisterStoreInfoBloc>()
          .add(EventOpenImagePicker(imageSource: imageSource));
    };

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        builder: (_) => ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text(CustomTexts.cameraText),
                  onTap: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text(CustomTexts.galleryText),
                  onTap: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.gallery);
                  },
                ),
              ],
            ));
  }
}
