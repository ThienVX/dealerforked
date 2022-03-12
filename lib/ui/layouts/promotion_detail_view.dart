import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/promotion_detail_bloc.dart';
import 'package:dealer_app/repositories/events/promotion_detail_event.dart';
import 'package:dealer_app/repositories/states/promotion_detail_state.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PromotionDetailView extends StatelessWidget {
  PromotionDetailView({Key? key}) : super(key: key);

  late Map<String, dynamic>? _arguments;

  @override
  Widget build(BuildContext context) {
    _arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (_arguments != null)
      return BlocProvider(
        create: (context) {
          // Show loading
          EasyLoading.show();
          return PromotionDetailBloc(promotionId: _arguments!['id']);
        },
        child: MultiBlocListener(
          listeners: [
            // Close loading dialog
            BlocListener<PromotionDetailBloc, PromotionDetailState>(
              listener: (context, state) {
                EasyLoading.dismiss();
                if (state is ErrorState) {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.ERROR,
                    desc: state.message,
                    btnOkText: 'Đóng',
                  );
                }
                if (state is SuccessState) {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.SUCCES,
                    desc: state.message,
                    btnOkText: 'Đóng',
                    okRoutePress: CustomRoutes.promotionListView,
                  );
                }
                if (state is DeleteState) {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.QUESTION,
                    desc: state.message,
                    btnCancelText: 'Hủy',
                    btnOkText: 'Đồng ý',
                    btnOkOnpress: () {
                      context
                          .read<PromotionDetailBloc>()
                          .add(EventDeletePromotion());
                    },
                  );
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: _appBar(),
            body: _body(),
          ),
        ),
      );
    else
      return CustomWidgets.customErrorWidget();
  }

  _appBar() {
    return AppBar(
      // backgroundColor: Colors.lightGreen,
      elevation: 0,
      title: BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
        builder: (context, state) {
          return Text(
            CustomTexts.promotionDetail,
            style: Theme.of(context).textTheme.headline2,
          );
        },
      ),
    );
  }

  _body() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      builder: (context, state) {
        if (!(state is LoadingState))
          return Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: [
                  _promotionCode(),
                  _promotionName(),
                  _appliedScrapCategory(),
                  _appliedAmount(),
                  _bonusAmount(),
                  _appliedTime(),
                  if (_arguments!['status'] != PromotionStatus.PAST.index)
                    _deleteButton(),
                ],
              ));
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

  _promotionCode() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Mã ưu đãi',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue: state.model.code,
            readOnly: true,
          ),
        );
      },
    );
  }

  _promotionName() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Tên ưu đãi',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue: state.model.promotionName,
            readOnly: true,
          ),
        );
      },
    );
  }

  _appliedScrapCategory() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Áp dụng cho danh mục',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue: state.model.appliedScrapCategory,
            readOnly: true,
          ),
        );
      },
    );
  }

  _appliedAmount() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Mức giá áp dụng ưu đãi',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue:
                CustomFormats.currencyFormat(state.model.appliedAmount),
            readOnly: true,
          ),
        );
      },
    );
  }

  _bonusAmount() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Số tiền ưu đãi',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue: CustomFormats.currencyFormat(state.model.bonusAmount),
            readOnly: true,
          ),
        );
      },
    );
  }

  _appliedTime() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Thời gian áp dụng',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue:
                '${state.model.appliedFromTime} - ${state.model.appliedToTime}',
            readOnly: true,
          ),
        );
      },
    );
  }

  _deleteButton() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      builder: (context, state) {
        return CustomWidgets.customSecondaryButton(
          text: 'Kết thúc ưu đãi',
          action: () {
            context.read<PromotionDetailBloc>().add(EventTapDeleteButton());
          },
          textColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(Colors.red),
        );
      },
    );
  }
}
