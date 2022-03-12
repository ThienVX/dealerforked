import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/create_transaction_bloc.dart';
import 'package:dealer_app/repositories/events/create_transaction_event.dart';
import 'package:dealer_app/repositories/models/scrap_category_unit_model.dart';
import 'package:dealer_app/repositories/states/create_transaction_state.dart';
import 'package:dealer_app/ui/widgets/custom_text_widget.dart';
import 'package:dealer_app/ui/widgets/flexible.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/currency_text_formatter.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/qr_scanner.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateTransactionView extends StatelessWidget {
  final TextEditingController _collectorPhoneController =
      TextEditingController();
  final TextEditingController _collectorNameController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CreateTransactionBloc(initialState: CreateTransactionState()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<CreateTransactionBloc, CreateTransactionState>(
            listener: (context, state) {
              if (state.isModalBottomSheetShowed) {
                _showItemDialog(context);
              }
              //process
              if (state.process == Process.processing) {
                EasyLoading.show();
              } else {
                EasyLoading.dismiss();
                if (state.process == Process.error) {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.ERROR,
                    desc: CustomTexts.generalErrorMessage,
                    btnOkText: 'Đóng',
                  );
                } else if (state.process == Process.valid) {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.SUCCES,
                    desc: CustomTexts.createTransactionSuccessfullyText,
                    btnOkText: 'Đóng',
                    btnOkOnpress: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        CustomRoutes.transactionHistoryDetailView,
                        ModalRoute.withName(CustomRoutes.botNav),
                        arguments: state.transactionId,
                      );
                    },
                  );
                }
              }
            },
          ),
          // Collector phone listener
          BlocListener<CreateTransactionBloc, CreateTransactionState>(
              listenWhen: (previous, current) {
            return current.isQRScanned == true;
          }, listener: (context, state) {
            _collectorPhoneController.text = state.collectorPhone;
          }),
          // Collector name listener
          BlocListener<CreateTransactionBloc, CreateTransactionState>(
              listenWhen: (previous, current) {
            return previous.collectorName != current.collectorName;
          }, listener: (context, state) {
            _collectorNameController.text =
                state.collectorName ?? CustomTexts.emptyString;
          }),
        ],
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              CustomTexts.createTransactionScreenTitle,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          body: _body(),
        ),
      ),
    );
  }

  _getDottedDivider() {
    return Container(
      padding: EdgeInsets.only(top: 50.h, bottom: 50.h),
      child: DottedLine(
        direction: Axis.horizontal,
        dashGapLength: 3.0,
        dashColor: AppColors.greyFFB5B5B5,
      ),
    );
  }

  _body() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 90,
                  fit: FlexFit.tight,
                  child: ListView(
                    children: [
                      // BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      //   builder: (context, state) {
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text('Chủ vựa: ${state.user!.nxame}'),
                      //         SizedBox(height: 10),
                      //         Text('SĐT chủ vựa: ${state.user!.phone}'),
                      //       ],
                      //     );
                      //   },
                      // ),
                      // Divider(),
                      _phoneField(),
                      _nameField(),
                      _detailText(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30.h),
                        child: _items(),
                      ),
                      _getDottedDivider(),
                      _subTotal(),
                      SizedBox(
                        height: 20.h,
                      ),
                      _promotioBonusnAmount(),
                      _getDottedDivider(),
                      _total(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: _transactionButtons(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _phoneField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            controller: _collectorPhoneController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              labelText: CustomTexts.collectorPhoneLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: _scanQRIcon(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              context
                  .read<CreateTransactionBloc>()
                  .add(EventPhoneNumberChanged(collectorPhone: value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.phoneBlank;
              if (!state.isPhoneValid) return CustomTexts.phoneError;
              if (!state.isCollectorPhoneExist && state.collectorId == null)
                return CustomTexts.phoneNotExist;
            },
          ),
        );
      },
    );
  }

  _scanQRIcon() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return IconButton(
            onPressed: () async {
              var collectorId;
              collectorId = await QRScanner.scanQR();
              context
                  .read<CreateTransactionBloc>()
                  .add(EventCollectorIdChanged(collectorId: collectorId));
            },
            icon: Icon(Icons.qr_code_scanner));
      },
    );
  }

  _nameField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            enabled: false,
            controller: _collectorNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              labelText: CustomTexts.collectorNameLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
          ),
        );
      },
    );
  }

  _detailText() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: CustomTexts.detailText,
              color: AppColors.black,
              fontSize: 42.sp,
            ),
            //add item button
            Visibility(
              visible: state.scrapCategoryMap.length != 0,
              child: InkWell(
                onTap: () {
                  context
                      .read<CreateTransactionBloc>()
                      .add(EventShowItemDialog());
                },
                child: SizedBox(width: 50, child: Icon(Icons.add)),
              ),
            ),
          ],
        );
      },
    );
  }

  _items() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      buildWhen: (previous, current) {
        return previous.isItemsUpdated == false &&
            current.isItemsUpdated == true;
      },
      builder: (context, state) {
        return FormField(
          builder: (formFieldState) => Column(
            children: [
              ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      context
                          .read<CreateTransactionBloc>()
                          .add(EventShowItemDialog(
                            key: index,
                            detail: state.items[index],
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    tileColor: Colors.grey[200],
                    title: state.items[index] != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    text: state.scrapCategories
                                        .firstWhere((element) =>
                                            element.id ==
                                            state.items[index].dealerCategoryId)
                                        .name,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 42.sp,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              if (state.items[index].quantity != 0 &&
                                  state.items[index].unit != null &&
                                  state.items[index].isCalculatedByUnitPrice)
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.loose,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      text: state.items[index].quantity != 0 &&
                                              state.items[index].unit != null
                                          ? '${CustomFormats.replaceDotWithComma(CustomFormats.quantityFormat.format(state.items[index].quantity))} ${state.items[index].unit}'
                                          : CustomTexts.emptyString,
                                      textAlign: TextAlign.center,
                                      fontSize: 42.sp,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              if (!(state.items[index].quantity != 0 &&
                                  state.items[index].unit != null &&
                                  state.items[index].isCalculatedByUnitPrice))
                                Flexible(
                                  flex: 3,
                                  fit: FlexFit.loose,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      text: '-',
                                      fontSize: 60.sp,
                                      color: Colors.grey[800],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              Flexible(
                                flex: 4,
                                fit: FlexFit.tight,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomText(
                                    text: CustomFormats.currencyFormat(
                                        state.items[index].total),
                                    textAlign: TextAlign.right,
                                    fontSize: 42.sp,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : null,
                    subtitle: state.items[index] != null &&
                            state.items[index].bonusAmount != 0 &&
                            state.items[index].isPromotionnApplied
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  CustomTexts.promotionText,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              Text(
                                CustomFormats.currencyFormat(
                                    state.items[index].bonusAmount),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          )
                        : null,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
              if (formFieldState.hasError && formFieldState.errorText != null)
                Text(
                  formFieldState.errorText!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          validator: (value) {
            if (state.items.length == 0) return CustomTexts.noItemsErrorText;
          },
        );
      },
    );
  }

  _subTotal() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: CustomTexts.subTotalText,
              color: AppColors.black,
              fontSize: 42.sp,
            ),
            CustomText(
              text: CustomFormats.currencyFormat(state.total),
              color: AppColors.black,
              fontSize: 42.sp,
            ),
          ],
        );
      },
    );
  }

  _promotioBonusnAmount() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: CustomTexts.promotionText,
              color: AppColors.black,
              fontSize: 42.sp,
            ),
            CustomText(
              text: CustomFormats.currencyFormat(state.totalBonus),
              color: AppColors.black,
              fontSize: 42.sp,
            ),
          ],
        );
      },
    );
  }

  _total() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: CustomTexts.totalText,
              fontSize: 48.sp,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              text: CustomFormats.currencyFormat(state.grandTotal),
              fontSize: 48.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        );
      },
    );
  }

  _transactionButtons() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          height: 40,
          child: rowFlexibleBuilder(
            CustomWidgets.customCancelButton(
                context, CustomTexts.cancelButtonText),
            CustomWidgets.customElevatedButton(
                context, CustomTexts.createTransactionButtonText, () {
              if (_formKey.currentState!.validate()) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.QUESTION,
                  desc: 'Tạo giao dịch?',
                  btnCancelText: 'Hủy',
                  btnOkText: 'Đồng ý',
                  btnOkOnpress: () {
                    context
                        .read<CreateTransactionBloc>()
                        .add(EventSubmitNewTransaction());
                  },
                );
              }
            }),
            rowFlexibleType.smallToBig,
          ),
        );
      },
    );
  }

// Item fields
  void _showItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<CreateTransactionBloc>(context),
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 320,
            height: 340,
            child: Form(
              key: _itemFormKey,
              child: Scrollbar(
                isAlwaysShown: true,
                child: Container(
                  padding: EdgeInsets.only(right: 15.w),
                  child: ListView(
                    children: [
                      _calculatedByUnitPriceSwitch(),
                      rowFlexibleBuilder(
                        _scrapCategoryUnitField(),
                        _scrapCategoryField(),
                        rowFlexibleType.bigToSmall,
                      ),
                      _quantityField(),
                      BlocBuilder<CreateTransactionBloc,
                          CreateTransactionState>(
                        builder: (context, state) {
                          return Visibility(
                            visible: (state.itemQuantity -
                                    state.itemQuantity.truncate()) >
                                0,
                            child: Container(
                              padding:
                                  EdgeInsets.only(bottom: 40.h, left: 20.w),
                              child: CustomText(
                                text: '* Chữ số thập phân sử dụng dấu "," '
                                    'nên dùng cho các loại đơn vị như kilogam, gam, tạ, tấn,... ',
                                fontSize: 35.sp,
                                color: AppColors.greyFF939393,
                              ),
                            ),
                          );
                        },
                      ),
                      _unitPriceField(),
                      Stack(
                        children: [
                          _totalField(),
                          Positioned(
                            top: 3,
                            right: 30,
                            child: _promotionApplicationBonusAmount(),
                          )
                        ],
                      ),
                      _promotionApplicationDescription(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: state.key != null && !state.isNewItem,
                      child: _deleteItemButton(),
                    );
                  },
                ),
                Row(
                  children: [
                    CustomWidgets.customCancelButton(
                        context, CustomTexts.cancelButtonText),
                    SizedBox(
                      width: 10,
                    ),
                    _addAndUpdateItemButton(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).then((value) =>
        context.read<CreateTransactionBloc>().add(EventDissmissPopup()));
  }

  _calculatedByUnitPriceSwitch() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.greyFFF8F8F8,
            borderRadius: BorderRadius.circular(30.0.r),
          ),
          margin: EdgeInsets.only(bottom: 50.h),
          child: SizedBox(
            height: 210.h,
            child: ListTile(
              // dense: true,
              isThreeLine: true,
              title: Text(
                CustomTexts.calculatedByUnitPriceText,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                CustomTexts.calculatedByUnitPriceExplainationText,
                style: TextStyle(fontSize: 37.sp),
              ),
              trailing: SizedBox(
                height: 80.h,
                child: Switch(
                  value: state.isItemTotalCalculatedByUnitPrice,
                  onChanged: state.itemDealerCategoryId !=
                          CustomVar.unnamedScrapCategory.id
                      ? (value) {
                          context.read<CreateTransactionBloc>().add(
                              EventCalculatedByUnitPriceChanged(
                                  isCalculatedByUnitPrice: value));
                        }
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _scrapCategoryField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownSearch(
            mode: Mode.DIALOG,
            maxHeight: 250,
            showSelectedItems: true,
            showSearchBox: true,
            label: CustomTexts.scrapTypeLabel,
            items: state.scrapCategoryMap.keys.toList(),
            selectedItem: state.itemDealerCategoryId != CustomTexts.emptyString
                ? state.itemDealerCategoryId
                : null,
            compareFn: (String? item, String? selectedItem) =>
                item == selectedItem,
            itemAsString: (String? id) => id != null
                ? state.scrapCategoryMap[id] ?? CustomTexts.emptyString
                : CustomTexts.emptyString,
            validator: (value) {
              if (value == null || value == CustomTexts.emptyString)
                return CustomTexts.scrapTypeBlank;
              if (!state.isScrapCategoryValid)
                return CustomTexts.scrapTypeNotChoosenError;
            },
            onChanged: (String? selectedValue) {
              if (selectedValue != null)
                context.read<CreateTransactionBloc>().add(
                    EventDealerCategoryChanged(
                        dealerCategoryId: selectedValue));
            },
          ),
        );
      },
    );
  }

  _scrapCategoryUnitField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownSearch(
            enabled: state.scrapCategoryDetails.isNotEmpty &&
                state.isItemTotalCalculatedByUnitPrice,
            selectedItem: state.itemDealerCategoryDetailId != null &&
                    state.isItemTotalCalculatedByUnitPrice
                ? state.scrapCategoryDetails.firstWhere(
                    (element) => element.id == state.itemDealerCategoryDetailId)
                : null,
            mode: Mode.DIALOG,
            maxHeight: 250,
            showSelectedItems: true,
            items: state.scrapCategoryDetails,
            compareFn: (ScrapCategoryUnitModel? item,
                    ScrapCategoryUnitModel? selectedItem) =>
                item?.id == selectedItem?.id,
            itemAsString: (ScrapCategoryUnitModel? model) =>
                model != null ? model.unit : CustomTexts.emptyString,
            validator: (value) {
              if (state.isItemTotalCalculatedByUnitPrice) {
                if (value == null || value == CustomTexts.emptyString)
                  return CustomTexts.scrapCategoryUnitBlank;
              }
            },
            onChanged: (ScrapCategoryUnitModel? selectedValue) {
              if (selectedValue != null)
                context.read<CreateTransactionBloc>().add(
                    EventDealerCategoryUnitChanged(
                        dealerCategoryDetailId: selectedValue.id));
            },
            dropdownSearchDecoration: InputDecoration(
              labelText: CustomTexts.unitLabel,
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
            dropdownBuilder: _customDropDownExample,
          ),
        );
      },
    );
  }

  Widget _customDropDownExample(
      BuildContext context, ScrapCategoryUnitModel? item) {
    if (item == null) {
      return SizedBox(
        height: 46,
      );
    }

    return Container(
      child: Text(
        item.unit,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  _quantityField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isItemTotalCalculatedByUnitPrice,
          child: Container(
            margin: EdgeInsets.only(bottom: 30.h),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: CustomTexts.quantityLabel,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*,?\d*)')),
              ],
              initialValue: CustomFormats.replaceDotWithComma(
                  CustomFormats.quantityFormat.format(state.itemQuantity)),
              onChanged: (value) {
                if (value != CustomTexts.emptyString && value != ',') {
                  var valueWithDot = value.replaceAll(RegExp(r'[^0-9],'), '');
                  valueWithDot = valueWithDot.replaceAll(RegExp(r','), '.');
                  context
                      .read<CreateTransactionBloc>()
                      .add(EventQuantityChanged(quantity: valueWithDot));
                } else {
                  context.read<CreateTransactionBloc>().add(
                      EventQuantityChanged(quantity: CustomTexts.zeroString));
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return CustomTexts.quantityBlank;
                if (!state.isItemQuantityValid) {
                  return CustomTexts.quantityZero;
                }
              },
            ),
          ),
        );
      },
    );
  }

  _unitPriceField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isItemTotalCalculatedByUnitPrice,
          child: Container(
            margin: EdgeInsets.only(top: 16),
            child: SizedBox(
              height: 90,
              child: TextFormField(
                key: state.itemDealerCategoryDetailId != null
                    ? Key(state.itemDealerCategoryDetailId!)
                    : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: CustomTexts.unitPriceLabel,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixText: CustomTexts.vndSymbolUnderlined,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyTextFormatter()],
                //get the unit price for each unit
                initialValue: CustomFormats.numberFormat(state.itemPrice),
                onChanged: (value) {
                  if (value != CustomTexts.emptyString) {
                    context.read<CreateTransactionBloc>().add(
                        EventUnitPriceChanged(
                            unitPrice:
                                value.replaceAll(RegExp(r'[^0-9]'), '')));
                  } else {
                    context.read<CreateTransactionBloc>().add(
                        EventUnitPriceChanged(
                            unitPrice: CustomTexts.zeroString));
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return CustomTexts.unitPriceBlank;
                  if (!state.isItemPriceValid) {
                    return CustomTexts.unitPriceNegative;
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  _totalField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          key: state.isItemTotalCalculatedByUnitPrice ? UniqueKey() : null,
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.totalLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixText: CustomTexts.vndSymbolUnderlined,
              errorStyle: TextStyle(
                color: Theme.of(context).errorColor, // or any other color
              ),
            ),
            enabled: !state.isItemTotalCalculatedByUnitPrice,
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyTextFormatter()],
            initialValue: state.isItemTotalCalculatedByUnitPrice
                ? CustomFormats.numberFormat(state.itemTotalCalculated)
                : CustomFormats.numberFormat(state.itemTotal),
            onChanged: (value) {
              if (value != CustomTexts.emptyString) {
                context.read<CreateTransactionBloc>().add(EventItemTotalChanged(
                    total: value.replaceAll(RegExp(r'[^0-9]'), '')));
              } else {
                context
                    .read<CreateTransactionBloc>()
                    .add(EventItemTotalChanged(total: CustomTexts.zeroString));
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.totalBlank;
              if (!state.isItemTotalLowerThanZero) {
                return CustomTexts.isItemTotalLowerThanZero;
              }
              if (!state.isItemTotalUnderLimit) {
                return CustomTexts.totalOverLimit;
              }
            },
          ),
        );
      },
    );
  }

  _promotionApplicationBonusAmount() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isPromotionApplied,
          child: CustomWidgets.customText(
            textStyle: Theme.of(context).textTheme.bodyText2,
            text: '+ ${CustomFormats.numberFormat(state.itemBonusAmount)}',
          ),
        );
      },
    );
  }

  _promotionApplicationDescription() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isPromotionApplied,
          child: CustomWidgets.customText(
              textStyle: Theme.of(context).textTheme.bodyText2,
              text: state.itemPromotionId != null
                  ? CustomTexts.promotionAppliedText(
                      promotionCode: state.getItemPromotionCode)
                  : CustomTexts.promotionNotAppliedText),
        );
      },
    );
  }

  _addAndUpdateItemButton() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return CustomWidgets.customElevatedButton(
            context,
            state.key == null
                ? CustomTexts.addScrapButtonText
                : CustomTexts.saveUpdateButtonText, () {
          if (_itemFormKey.currentState!.validate()) {
            if (state.isNewItem)
              context.read<CreateTransactionBloc>().add(EventAddNewItem());
            else
              context.read<CreateTransactionBloc>().add(EventUpdateItem());
            Navigator.of(context).pop();
          }
        });
      },
    );
  }

  _deleteItemButton() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return CustomWidgets.customSecondaryButton(
          text: CustomTexts.deleteItemButtonText,
          action: () {
            context
                .read<CreateTransactionBloc>()
                .add(EventDeleteItem(key: state.key!));
            Navigator.of(context).pop();
          },
          textColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(AppColors.orangeFFF5670A),
        );
      },
    );
  }
}
