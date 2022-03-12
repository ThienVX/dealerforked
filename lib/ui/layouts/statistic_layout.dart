import 'package:dealer_app/blocs/profile_bloc.dart';
import 'package:dealer_app/blocs/statistic_bloc.dart';
import 'package:dealer_app/repositories/events/statistic_event.dart';
import 'package:dealer_app/repositories/states/profile_state.dart';
import 'package:dealer_app/repositories/states/statistic_state.dart';
import 'package:dealer_app/ui/widgets/common_margin_container.dart';
import 'package:dealer_app/ui/widgets/custom_text_widget.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dealer_app/utils/extension_methods.dart';

class StatisticLayout extends StatelessWidget {
  const StatisticLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => StatisticBloc(
            dealerType: state.dealerType,
            dealerId: state.id,
          )..add(
              StatisticIntial(),
            ),
          child: Theme(
            data: ThemeData(
              primarySwatch: Colors.green,
              primaryColor: AppColors.greenFF01C971,
              accentColor: AppColors.greenFF01C971,
            ),
            child: Scaffold(
              body: MainLayout(),
            ),
          ),
        );
      },
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titlePart(context),
        buildDataPart(),
      ],
    );
  }

  Widget buildDataPart() {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        switch (state.status) {
          case FormzStatus.pure:
          case FormzStatus.submissionInProgress:
            return Center(
              child: FunctionalWidgets.getLoadingAnimation(),
            );
          case FormzStatus.submissionSuccess:
            return dataPart();
          case FormzStatus.submissionFailure:
          default:
            return Center(
              child: FunctionalWidgets.getErrorIcon(),
            );
        }
      },
    );
  }

  Widget titlePart(BuildContext context) {
    return Container(
      child: CommonMarginContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 100.h,
            ),
            title(),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, sp) => sp.dealerType == DealerType.manager
                  ? chooseDealer()
                  : SizedBox.shrink(),
            ),
            date(context),
          ],
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            AppColors.greenFF61C53D.withOpacity(0.7),
            AppColors.greenFF39AC8F.withOpacity(0.7),
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      constraints: BoxConstraints(
        minHeight: 500.h,
      ),
      width: double.infinity,
    );
  }

  Widget chooseDealer() {
    var dropDownColor = Colors.white;
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 100.w,
          ),
          height: 180.h,
          child: DropdownSearch<DealerInfo>(
            mode: Mode.BOTTOM_SHEET,
            items: state.listDealer,
            label: null,
            onChanged: (value) {
              if (value != null) {
                context
                    .read<StatisticBloc>()
                    .add(StatisticDealerChanged(value.id));
              }
            },
            dropdownBuilder: (context, selectedItem) {
              if (selectedItem != null) {
                return CustomText(
                  text: selectedItem.name,
                  color: dropDownColor,
                  fontSize: 55.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                );
              }
              return Container();
            },
            dropDownButton: Icon(
              Icons.arrow_drop_down,
              color: dropDownColor,
            ),
            dropdownSearchDecoration: InputDecoration(border: InputBorder.none),
            itemAsString: (item) {
              return item!.name;
            },
            selectedItem:
                state.listDealer.isNotEmpty ? state.listDealer.first : null,
            emptyBuilder: (context, searchEntry) => Center(
              child: CustomText(text: 'Không có vựa nào'),
            ),

          ),
        );
      },
    );
  }

  Widget title() {
    return Container(
      child: CustomText(
        text: 'Thống kê',
        textAlign: TextAlign.left,
        color: AppColors.white,
        fontSize: 80.sp,
        fontWeight: FontWeight.w500,
      ),
      width: double.infinity,
    );
  }

  Widget date(BuildContext context) {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        return InkWell(
          onTap: onDateTap(context, state),
          child: Container(
            margin: EdgeInsets.only(
              top: 50.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text:
                      '${state.fromDate.toStatisticString()}  -  ${state.toDate.toStatisticString()}',
                  fontSize: 55.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 80.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void Function() onDateTap(
    BuildContext context,
    StatisticState state,
  ) {
    return () {
      showDateRangePicker(
        context: context,
        firstDate: DateTime(2021, 1, 1),
        lastDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDateRange: DateTimeRange(
          start: state.fromDate,
          end: state.toDate,
        ),
        locale: Locale(
          Symbols.vietnamLanguageCode,
          Symbols.vietnamISOCode,
        ),
      ).then((value) {
        if (value != null) {
          context
              .read<StatisticBloc>()
              .add(StatisticChanged(value.start, value.end));
        }
      });
    };
  }

  Widget dataPart() {
    return CommonMarginContainer(
      child: Container(
        margin: EdgeInsets.only(top: 60.h),
        padding: EdgeInsets.only(top: 60.h, bottom: 60.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.0.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 1.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: [
            listData(),
            // divider(),
            // conclusion(),
          ],
        ),
      ),
    );
  }

  Widget listData() {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              DataPattern(
                title: 'Tổng thu mua',
                data: state.statisticData.totalCollecting.toAppPrice(),
              ),
              SizedBox(
                height: 70.h,
              ),
              DataPattern(
                title: 'Đơn hoàn thành',
                data: state.statisticData.numOfCompletedTrans.toString(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ConclusionPattern extends StatelessWidget {
  const ConclusionPattern({
    Key? key,
    required this.title,
    required this.quantity,
  }) : super(key: key);
  final String title;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            fontSize: 48.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            height: 30.h,
          ),
          CustomText(
            text: quantity.toString(),
            fontSize: 70.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class DataPattern extends StatelessWidget {
  const DataPattern({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);
  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            fontSize: 53.sp,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: data,
            fontSize: 53.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
