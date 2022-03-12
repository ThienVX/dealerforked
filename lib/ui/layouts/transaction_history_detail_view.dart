import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/feedback_admin_bloc.dart';
import 'package:dealer_app/blocs/transaction_history_detail_bloc.dart';
import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/repositories/events/feedback_admin_event.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_history_detail_item_model.dart';
import 'package:dealer_app/repositories/states/feedback_admin_state.dart';
import 'package:dealer_app/repositories/states/transaction_history_detail_state.dart';
import 'package:dealer_app/ui/app.dart';
import 'package:dealer_app/ui/widgets/arrow_back_button.dart';
import 'package:dealer_app/ui/widgets/common_margin_container.dart';
import 'package:dealer_app/ui/widgets/custom_text_widget.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class TransactionHistoryDetailView extends StatelessWidget {
  const TransactionHistoryDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? id = ModalRoute.of(context)?.settings.arguments as String;
    if (id != null)
      return BlocProvider(
        create: (context) {
          // Show loading
          return TransactionHistoryDetailBloc(id: id);
        },
        child: MultiBlocListener(
          listeners: [
            // Close loading dialog
            BlocListener<TransactionHistoryDetailBloc,
                TransactionHistoryDetailState>(
              listener: (context, state) {
                if (state is NotLoadedState) {
                  EasyLoading.show();
                } else {
                  EasyLoading.dismiss();
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
      elevation: 0,
      title: BlocBuilder<TransactionHistoryDetailBloc,
          TransactionHistoryDetailState>(
        builder: (context, state) {
          return CustomText(
            text: CustomTexts.transactionHistoryScreenTitle,
            color: AppColors.white,
          );
        },
      ),
      leading: ArrowBackIconButton(
        color: AppColors.white,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment
                .centerLeft, // 10% of the width, so there are ten blinds.
            colors: <Color>[
              AppColors.greenFF61C53D.withOpacity(1),
              AppColors.greenFF39AC8F.withOpacity(1),
            ], // red to yellow
            tileMode:
            TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
      ),
    );
  }

  _getDottedDivider() {
    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 30.h, left: 48.w, right: 48.w),
      child: DottedLine(
        direction: Axis.horizontal,
        dashGapLength: 3.0,
        dashColor: AppColors.greyFFB5B5B5,
      ),
    );
  }

  _body() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 48.w
                    ),
                    child: Row(
                      children: [
                        RadiantGradientMask(
                          child: Icon(
                            Icons.description_outlined,
                            color: AppColors.greenFF01C971,
                            size: 60.sp,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 20.w,
                            ),
                            child: CustomText(
                              text: 'Mã Đơn: ${state.model.transactionCode}',
                              fontWeight: FontWeight.w500,
                              fontSize: 35.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 20.h,
                    height: 100.h,
                    color: AppColors.greyFFEEEEEE,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 48.w
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: 150.r,
                            width: 150.r,
                            child: CustomWidgets.customAvatar(avatar: state.image)
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                text: state.model.collectorName,
                              fontSize: 45.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 20.h,
                    height: 100.h,
                    color: AppColors.greyFFEEEEEE,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 48.w
                      ),
                      margin: EdgeInsets.only(bottom: 30.h),
                      child: CustomText(text: 'Thông tin thu gom')
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 48.w
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RadiantGradientMask(
                            child: Icon(
                                Icons.event,
                              color: AppColors.greenFF01C971,
                            size: 60.sp,
                            ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20.w,
                            top: 5.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  text: 'Thời gian giao dịch',
                                fontSize: 40.sp,
                                color: Colors.grey[600],
                              ),
                              Row(
                                children: [
                                  CustomWidgets.customDateText(
                                      time: state.model.transactionDate),
                                  CustomText(text: ', ' + state.model.transactionTime),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(padding: EdgeInsets.symmetric(
                      horizontal: 48.w
                  ),
                    child: Row(
                      children: [
                        RadiantGradientMask(
                            child: Icon(
                            Icons.list_alt,
                              color: AppColors.greenFF01C971,
                              size: 60.sp,
                          )
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20.w,
                          ),
                          child: CustomText(
                              text: 'Thông tin đơn hàng',
                            fontSize: 40.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _items(),
                  SizedBox(
                    height: 30.h,
                  ),
                  _subTotal(),
                  _promotioBonusnAmount(),
                  SizedBox(
                    height: 30.h,
                  ),
                  _getDottedDivider(),
                  _total(),
                  _getFeedbackToAdmin(context),
                ],
              ));
        else if (state is NotLoadedState) {
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

  Widget _getFeedbackToAdmin(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(
        top: 40.h,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 48.w
      ),
      child: CommonMarginContainer(
        child: BlocBuilder<TransactionHistoryDetailBloc,
            TransactionHistoryDetailState>(
          builder: (context, state) {
            state = state as LoadedState;
            return TextButton(
              onPressed: _feedbackAdminPressed(
                context,
                state.model.complaint.complaintStatus,
                state.model.complaint.complaintContent,
                state.model.complaint.adminReply,
                state.id,
              ),
              child: const CustomText(
                text: 'Phản hồi',
                color: AppColors.orangeFFF5670A,
              ),
              style: TextButton.styleFrom(
                primary: AppColors.orangeFFF5670A,
              ),
            );
          },
        ),
      ),
    );
  }

  void Function() _feedbackAdminPressed(
    BuildContext context,
    int status,
    String? sellingFeedback,
    String? replyAdmin,
    String requestId,
  ) {
    return () {
      FunctionalWidgets.showCustomModalBottomSheet(
        context: context,
        child: _getFeedbackAdminWidget(
          status,
          sellingFeedback,
          replyAdmin,
          requestId,
        ),
        title: 'Phản hồi',
        routeClosed: CustomRoutes.transactionHistoryDetailView,
      ).then((value) {
        if (value != null && value) {
          if (value != null && value) {
            DealerApp.navigatorKey.currentState!.pushNamedAndRemoveUntil(
              CustomRoutes.transactionHistoryDetailView,
              ModalRoute.withName(CustomRoutes.botNav),
              arguments: requestId,
            );
          }
        }
      });
    };
  }

  Widget _getFeedbackAdminWidget(
    int status,
    String? sellingFeedback,
    String? replyAdmin,
    String requestId,
  ) {
    return BlocProvider(
      create: (context) => FeedbackAdminBloc(
        requestId: requestId,
      ),
      child: status == FeedbackToSystemStatus.canGiveFeedback
          ? FeedbackAdminWidget()
          : (status == FeedbackToSystemStatus.haveGivenFeedback ||
                  status == FeedbackToSystemStatus.adminReplied)
              ? FeedbackAdminDoneWidget(
                  status: status,
                  sellingFeedback: sellingFeedback ?? Symbols.empty,
                  adminReply: replyAdmin,
                )
              : const SizedBox.shrink(),
    );
  }

  _items() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 48.w
            ),
            child: ListView.separated(

              padding: EdgeInsets.only(top: 10),
              primary: false,
              shrinkWrap: true,
              itemCount: state.model.itemDetails.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (itemContext, index) =>
                  _itemBulder(item: state.model.itemDetails[index]),
            ),
          );
        else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _itemBulder({required CDTransactionHistoryDetailItemModel item}) {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        return ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          tileColor: Colors.grey[200],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: item.scrapCategoryName ??
                        CustomVar.unnamedScrapCategory.name,
                    fontSize: 42.sp,
                    color: Colors.grey[800],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (item.quantity != 0 && item.unit != null)
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: item.quantity != 0 && item.unit != null
                          ? '${CustomFormats.replaceDotWithComma(CustomFormats.quantityFormat.format(item.quantity))} ${item.unit}'
                          : CustomTexts.emptyString,
                      textAlign: TextAlign.center,
                      fontSize: 42.sp,
                      color: Colors.grey[800],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              if (!(item.quantity != 0 && item.unit != null))
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
                    text: CustomFormats.currencyFormat(item.total),
                    textAlign: TextAlign.right,
                    fontSize: 42.sp,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          subtitle: item.isBonus
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: CustomText(
                        text: CustomTexts.promotionText,
                        fontSize: 40.sp,
                      ),
                    ),
                    CustomText(
                      text: CustomFormats.currencyFormat(item.bonusAmount),
                      fontSize: 40.sp,
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  _subTotal() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 48.w,
              vertical: 12.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: CustomTexts.subTotalText,
                  color: AppColors.black,
                  fontSize: 38.sp,
                ),
                CustomText(
                  text: CustomFormats.currencyFormat(state.model.total),
                  color: AppColors.black,
                  fontSize: 38.sp,
                ),
              ],
            ),
          );
        else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _promotioBonusnAmount() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 48.w,
              vertical: 12.h
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: CustomTexts.promotionText,
                  color: AppColors.black,
                  fontSize: 38.sp,
                ),
                CustomText(
                  text: CustomFormats.currencyFormat(state.model.totalBonus),
                  color: AppColors.black,
                  fontSize: 38.sp,
                ),
              ],
            ),
          );
        else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _total() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 48.w
            ),
            child: Row(
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
            ),
          );
        else
          return CustomWidgets.customErrorWidget();
      },
    );
  }
}

class FeedbackAdminWidget extends StatelessWidget {
  FeedbackAdminWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackAdminBloc, FeedbackAdminState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          EasyLoading.show();
        } else {
          EasyLoading.dismiss();
        }

        if (state.status.isSubmissionSuccess) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.SUCCES,
            desc: 'Bạn đã gửi phản hồi đến hệ thống',
            btnOkText: 'Đóng',
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          );
        }
        if (state.status.isSubmissionFailure) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.WARNING,
            desc: 'Có lỗi đến từ hệ thống',
            btnOkText: 'Đóng',
            isOkBorder: true,
            btnOkColor: AppColors.errorButtonBorder,
            textOkColor: AppColors.errorButtonText,
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);
            },
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 48.0.w,
              vertical: 20.h,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 50.h,
            ),
            color: Colors.orange[900]!.withOpacity(0.2),
            child: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: AppColors.orangeFFF5670A,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 40.w,
                    ),
                    child: CustomText(
                      text:
                          'Vui lòng điền thông tin bạn muốn phản hồi về VeChaiXANH',
                      color: AppColors.orangeFFF5670A,
                      fontSize: 40.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CommonMarginContainer(
            child: TextField(
              onChanged: (value) {
                context.read<FeedbackAdminBloc>().add(
                      FeedbackAdminChanged(value),
                    );
              },
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLength: 200,
              decoration: const InputDecoration(
                hintText: 'Thông tin phản hồi',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              textInputAction: TextInputAction.done,
              autofocus: true,
            ),
          ),
          CommonMarginContainer(
            child: BlocBuilder<FeedbackAdminBloc, FeedbackAdminState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.status.isValid
                      ? () {
                          context
                              .read<FeedbackAdminBloc>()
                              .add(FeedbackAdminSubmmited());
                        }
                      : null,
                  child: CustomText(
                    text: 'Gửi',
                    fontSize: WidgetConstants.buttonCommonFrontSize.sp,
                    fontWeight: WidgetConstants.buttonCommonFrontWeight,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      double.infinity,
                      WidgetConstants.buttonCommonHeight.h,
                    ),
                    primary: AppColors.greenFF01C971,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackAdminDoneWidget extends StatelessWidget {
  FeedbackAdminDoneWidget({
    Key? key,
    required this.status,
    required this.sellingFeedback,
    this.adminReply,
  }) : super(key: key);

  final int status;
  final String sellingFeedback;
  final String? adminReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: CommonMarginContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _content(
              'Phản hồi của bạn:',
              sellingFeedback,
            ),
            adminReply != null && adminReply!.isNotEmpty
                ? _content(
                    'Hồi đáp từ quản trị viên:',
                    adminReply!,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _content(String title, String content) {
    return Container(
      margin: EdgeInsets.only(
        top: 80.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 50.sp,
            fontWeight: FontWeight.w500,
          ),
          Container(
            padding: EdgeInsets.only(left: 50.w, top: 30.h),
            child: CustomText(
              text: content,
              fontSize: 45.sp,
            ),
          ),
        ],
      ),
    );
  }
}
