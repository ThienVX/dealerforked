import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/add_promotion_bloc.dart';
import 'package:dealer_app/repositories/events/add_promotion_event.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/states/add_promotion_state.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/currency_text_formatter.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPromotionView extends StatelessWidget {
  AddPromotionView({Key? key}) : super(key: key);

  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Show loading
        EasyLoading.show();
        return AddPromotionBloc();
      },
      child: MultiBlocListener(
        listeners: [
          // Close loading dialog
          BlocListener<AddPromotionBloc, AddPromotionState>(
            listenWhen: (previous, current) {
              return previous is LoadingState;
            },
            listener: (context, state) {
              if (state is LoadedState) {
                EasyLoading.dismiss();
              }
            },
          ),
          // Date listener
          BlocListener<AddPromotionBloc, AddPromotionState>(
            listenWhen: (previous, current) {
              return current.appliedFromTime != previous.appliedFromTime ||
                  current.appliedToTime != previous.appliedToTime;
            },
            listener: (context, state) {
              var date;
              if (state.appliedFromTime == null && state.appliedToTime == null)
                date = '';
              if (state.appliedFromTime == null && state.appliedToTime != null)
                date =
                    'Chưa chọn ngày - ${DateFormat('dd/MM/yyyy').format(state.appliedToTime!)}';
              if (state.appliedFromTime != null && state.appliedToTime == null)
                date =
                    '${DateFormat('dd/MM/yyyy').format(state.appliedFromTime!)} - Chưa chọn ngày';
              if (state.appliedFromTime != null && state.appliedToTime != null)
                date =
                    '${DateFormat('dd/MM/yyyy').format(state.appliedFromTime!)} - ${DateFormat('dd/MM/yyyy').format(state.appliedToTime!)}';

              _dateController.text = date;
            },
          ),
          BlocListener<AddPromotionBloc, AddPromotionState>(
              listener: (context, state) {
            if (state is LoadingState) {
              EasyLoading.show();
            } else {
              EasyLoading.dismiss();
              if (state is SuccessState) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.SUCCES,
                  desc: state.message,
                  btnOkText: 'Đóng',
                  okRoutePress: CustomRoutes.promotionListView,
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
          backgroundColor: AppColors.white,
          appBar: _appBar(),
          body: _body(),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      // backgroundColor: Colors.lightGreen,
      elevation: 0,
      title: BlocBuilder<AddPromotionBloc, AddPromotionState>(
        builder: (context, state) {
          return Text(
            'Ưu đãi mới',
            style: Theme.of(context).textTheme.headline2,
          );
        },
      ),
    );
  }

  _body() {
    return BlocBuilder<AddPromotionBloc, AddPromotionState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: [
                        _promotionName(),
                        _appliedScrapCategory(),
                        _appliedAmount(),
                        _bonusAmount(),
                        _appliedTime(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: CustomWidgets.customCancelButton(
                              context, CustomTexts.cancel),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                            flex: 7,
                            fit: FlexFit.tight,
                            child: CustomWidgets.customElevatedButton(
                              context,
                              CustomTexts.addPromotion,
                              () {
                                if (_formKey.currentState!.validate())
                                  FunctionalWidgets.showAwesomeDialog(
                                    context,
                                    dialogType: DialogType.QUESTION,
                                    desc: 'Thêm ưu đãi?',
                                    btnCancelText: 'Hủy',
                                    btnOkText: 'Đồng ý',
                                    btnOkOnpress: () {
                                      context
                                          .read<AddPromotionBloc>()
                                          .add(EventSubmitPromotion());
                                    },
                                  );
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        else if (state is LoadingState) {
          return Container(
            child: Center(
              child: Text('Đang tải dữ liệu...'),
            ),
          );
        } else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _promotionName() {
    return BlocBuilder<AddPromotionBloc, AddPromotionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: CustomTexts.promotionName,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            onChanged: (value) {
              context
                  .read<AddPromotionBloc>()
                  .add(EventChangePromotionName(value));
            },
            maxLength: 100,
            validator: (value) {
              if (value == null || value.isEmpty)
                return CustomTexts.promotionNameBlank;
            },
          ),
        );
      },
    );
  }

  _appliedScrapCategory() {
    return BlocBuilder<AddPromotionBloc, AddPromotionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownSearch<ScrapCategoryModel>(
            mode: Mode.MENU,
            maxHeight: 250,
            showSearchBox: true,
            label: CustomTexts.appliedScrapCategory,
            items: state.categories,
            itemAsString: (ScrapCategoryModel? model) =>
                model?.name ?? CustomTexts.emptyString,
            validator: (value) {
              if (value == null) return CustomTexts.scrapCategoryBlank;
            },
            onChanged: (selectedValue) {
              if (selectedValue != null) {
                context
                    .read<AddPromotionBloc>()
                    .add(EventChangePromotionScrapCategoryId(selectedValue.id));
              }
            },
          ),
        );
      },
    );
  }

  _appliedAmount() {
    return BlocBuilder<AddPromotionBloc, AddPromotionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: CustomTexts.appliedAmount,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffix: Text(CustomTexts.vndSymbolUnderlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyTextFormatter()],
            initialValue: CustomFormats.numberFormat(state.appliedAmount),
            onChanged: (value) {
              context
                  .read<AddPromotionBloc>()
                  .add(EventChangeAppliedAmount(value));
            },
            validator: (value) {
              if (value == null || value.isEmpty)
                return CustomTexts.appliedAmountBlank;
              int? valueInt = int.tryParse(value);
              if (valueInt != null) if (valueInt < 0)
                return CustomTexts.appliedAmountNegative;
            },
          ),
        );
      },
    );
  }

  _bonusAmount() {
    return BlocBuilder<AddPromotionBloc, AddPromotionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: CustomTexts.bonusAmount,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffix: Text(CustomTexts.vndSymbolUnderlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyTextFormatter()],
            initialValue: CustomFormats.numberFormat(state.bonusAmount),
            onChanged: (value) {
              context
                  .read<AddPromotionBloc>()
                  .add(EventChangeBonusAmount(value));
            },
            validator: (value) {
              if (value == null || value.isEmpty)
                return CustomTexts.bonusAmountBlank;
              int? valueInt = int.tryParse(value);
              if (valueInt != null) if (valueInt <= 0)
                return CustomTexts.bonusAmountNegative;
            },
          ),
        );
      },
    );
  }

  _appliedTime() {
    return BlocBuilder<AddPromotionBloc, AddPromotionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: _dateController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.promotionDuration,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            readOnly: true,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: Container(
                        height: 400,
                        width: 400,
                        child: Stack(children: [
                          SfDateRangePicker(
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs
                                    onSelectionChanged) {
                              context
                                  .read<AddPromotionBloc>()
                                  .add(EventChangeDate(
                                    fromDate:
                                        onSelectionChanged.value.startDate,
                                    toDate: onSelectionChanged.value.endDate,
                                  ));
                            },
                            selectionMode: DateRangePickerSelectionMode.range,
                            minDate: DateTime.now(),
                            initialSelectedRange: PickerDateRange(
                              state.appliedFromTime,
                              state.appliedToTime,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(CustomTexts.ok)),
                          ),
                        ]),
                      ),
                    );
                  });
            },
            validator: (value) {
              if (state.appliedFromTime == null)
                return CustomTexts.promotionStartDateBlank;
              if (state.appliedToTime == null)
                return CustomTexts.promotionEndDateBlank;
            },
          ),
        );
      },
    );
  }
}
