import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/add_category_bloc.dart';
import 'package:dealer_app/repositories/events/add_category_event.dart';
import 'package:dealer_app/repositories/states/add_category_state.dart';
import 'package:dealer_app/ui/widgets/flexible.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/currency_text_formatter.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  //controllers
  final TextEditingController _scrapNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCategoryBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddCategoryBloc, AddCategoryState>(
              listenWhen: (p, c) => !p.isImageSourceActionSheetVisible,
              listener: (context, state) {
                if (state.isImageSourceActionSheetVisible) {
                  _showImageSourceActionSheet(context);
                }
              }),
          BlocListener<AddCategoryBloc, AddCategoryState>(
              listener: (context, state) {
            if (state is LoadingState) {
              EasyLoading.show();
            } else {
              EasyLoading.dismiss();
              if (state is SubmittedState) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.SUCCES,
                  desc: state.message,
                  btnOkText: 'Đóng',
                  okRoutePress: CustomRoutes.categoryList,
                );
              }
              if (state is ErrorState) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.ERROR,
                  desc: state.message,
                  btnOkText: 'Đóng',
                );
              }
            }
          }),
        ],
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text(
              CustomTexts.addCategoryScreenTitle,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          body: _addCategoryBody(),
        ),
      ),
    );
  }

  _addCategoryBody() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      builder: (blocContext, state) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 90,
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: [
                      CustomWidgets.customText(text: CustomTexts.image),
                      _scrapImage(),
                      _scrapNameField(),
                      _detailTextAndButton(blocContext),
                      _scrapUnit(),
                    ],
                  ),
                ),
                //Form submit button
                Flexible(
                  flex: 10,
                  fit: FlexFit.loose,
                  child: _buttons(blocContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _scrapNameField() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      buildWhen: (p, c) => p.isNameExisted != c.isNameExisted,
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: CustomTexts.scrapCategoryName,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          controller: _scrapNameController,
          onChanged: (value) {
            context
                .read<AddCategoryBloc>()
                .add(EventChangeScrapName(scrapName: value));
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: 100,
          validator: (value) {
            if (value == null || value.isEmpty)
              return CustomTexts.inputScrapCategoryName;
            if (state.isNameExisted) return CustomTexts.scrapNameExisted;
          },
        );
      },
    );
  }

  Row _detailTextAndButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomWidgets.customText(text: CustomTexts.detail),
        InkWell(
          onTap: () {
            context.read<AddCategoryBloc>().add(EventAddScrapCategoryUnit());
          },
          child: SizedBox(width: 50, child: Icon(Icons.add)),
        )
      ],
    );
  }

  _scrapImage() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
          height: 150,
          child: Center(
            child: InkWell(
              onTap: () {
                context
                    .read<AddCategoryBloc>()
                    .add(EventChangeScrapImageRequest());
              },
              child: _getScrapImage(state),
            ),
          ),
        );
      },
    );
  }

  _scrapUnit() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      builder: (context, state) {
        return FormField(
          builder: (formFieldState) => Column(
            children: [
              if (formFieldState.hasError && formFieldState.errorText != null)
                Text(
                  formFieldState.errorText!,
                  style: TextStyle(color: Colors.red),
                ),
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: state.units.length,
                  itemBuilder: (context, index) {
                    return rowFlexibleBuilder(
                      SizedBox(
                        height: 90,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: CustomTexts.unit,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                          initialValue: state.units[index].unit,
                          onChanged: (value) {
                            context
                                .read<AddCategoryBloc>()
                                .add(EventChangeUnitAndPrice(
                                  index: index,
                                  unit: value,
                                  price: state.units[index].price.toString(),
                                ));
                          },
                          validator: (value) {
                            if (value == CustomTexts.emptyString) return null;
                            var text = CustomTexts.unitIsExisted;
                            var count = 0;
                            state.units.forEach((element) {
                              if (element.unit == value?.trim()) {
                                count++;
                              }
                            });
                            if (count >= 2)
                              return text;
                            else
                              return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: CustomTexts.unitPrice,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            suffix: Text(CustomTexts.vndSymbolUnderlined),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [CurrencyTextFormatter()],
                          initialValue: CustomFormats.numberFormat(
                              state.units[index].price),
                          onChanged: (value) {
                            context
                                .read<AddCategoryBloc>()
                                .add(EventChangeUnitAndPrice(
                                  index: index,
                                  unit: state.units[index].unit,
                                  price:
                                      value.replaceAll(RegExp(r'[^0-9]'), ''),
                                ));
                          },
                        ),
                      ),
                      rowFlexibleType.bigToSmall,
                    );
                  }),
            ],
          ),
          validator: (value) {
            if (!state.isOneUnitExist)
              return CustomTexts.eachScrapCategoryHasAtLeastOneUnit;
          },
        );
      },
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<AddCategoryBloc>()
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
                  title: Text(CustomTexts.camera),
                  onTap: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text(CustomTexts.gallery),
                  onTap: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.gallery);
                  },
                ),
              ],
            ));
  }

  Container _buttons(BuildContext blocContext) {
    return Container(
      height: 40,
      child: rowFlexibleBuilder(
        CustomWidgets.customCancelButton(blocContext, CustomTexts.cancel),
        CustomWidgets.customElevatedButton(
            blocContext, CustomTexts.addScrapCategory, () {
          if (_formKey.currentState!.validate()) {
            FunctionalWidgets.showAwesomeDialog(
              blocContext,
              dialogType: DialogType.QUESTION,
              desc: 'Thêm danh mục?',
              btnCancelText: 'Hủy',
              btnOkText: 'Đồng ý',
              btnOkOnpress: () {
                blocContext
                    .read<AddCategoryBloc>()
                    .add(EventSubmitScrapCategory());
                Navigator.pop(blocContext);
              },
            );
          }
        }),
        rowFlexibleType.smallToBig,
      ),
    );
  }

  Widget _getScrapImage(state) {
    if (state.pickedImageUrl != CustomTexts.emptyString) {
      return Image.file(File(state.pickedImageUrl));
    } else if (state.initScrapImage != null) {
      return Image(
        image: state.initScrapImage,
        fit: BoxFit.cover,
      );
    } else
      return Icon(
        Icons.add_a_photo,
        size: 100,
      );
  }
}
