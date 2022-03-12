import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/promotion_list_bloc.dart';
import 'package:dealer_app/repositories/events/promotion_list_event.dart';
import 'package:dealer_app/repositories/models/get_promotion_model.dart';
import 'package:dealer_app/repositories/states/promotion_list_state.dart';
import 'package:dealer_app/ui/widgets/custom_text_widget.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromotionListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromotionListBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<PromotionListBloc, PromotionListState>(
            listener: (context, state) {
              if (state is NotLoadedState) {
                EasyLoading.show();
              } else {
                EasyLoading.dismiss();
                if (state is ErrorState) {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.ERROR,
                    desc: state.errorMessage,
                    btnOkText: 'Đóng',
                    okRoutePress: CustomRoutes.botNav,
                  );
                }
              }
            },
          ),
        ],
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: _appBar(context),
            body: _body(
              child: TabBarView(
                children: [
                  _list(status: PromotionStatus.FUTURE),
                  _list(status: PromotionStatus.CURRENT),
                  _list(status: PromotionStatus.PAST),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        CustomTexts.promotion,
        style: Theme.of(context).textTheme.headline1,
      ),
      bottom: TabBar(
        tabs: [
          Tab(text: CustomTexts.upcoming),
          Tab(text: CustomTexts.ongoing),
          Tab(text: CustomTexts.finished),
        ],
      ),
      actions: [
        BlocBuilder<PromotionListBloc, PromotionListState>(
          buildWhen: (p, c) => false,
          builder: (blocContext, state) {
            return InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(CustomRoutes.addPromotion)
                  .then((value) {
                blocContext.read<PromotionListBloc>().add(EventInitData());
              }),
              child: Container(
                width: 60,
                child: Center(
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _body({required Widget child}) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: _searchField(),
          ),
          Flexible(
            child: child,
          ),
        ],
      ),
    );
  }

  _searchField() {
    return BlocBuilder<PromotionListBloc, PromotionListState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          color: Colors.white,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              hintText: CustomTexts.searchPromotionName,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              fillColor: Colors.grey[200],
              filled: true,
            ),
            onChanged: (value) {
              context
                  .read<PromotionListBloc>()
                  .add(EventChangeSearchName(searchName: value));
            },
          ),
        );
      },
    );
  }

  _list({required PromotionStatus status}) {
    return BlocBuilder<PromotionListBloc, PromotionListState>(
      builder: (blocContext, state) {
        if (state is LoadedState) {
          if (state.filteredPromotionList.isNotEmpty) {
            return RefreshIndicator(
                onRefresh: () async {
                  print('init');
                  blocContext.read<PromotionListBloc>().add(EventInitData());
                },
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  itemCount: state.filteredPromotionList
                      .where((element) => element.status == status.statusInt)
                      .length,
                  itemBuilder: (context, index) => _cardBuilder(
                    model: state.filteredPromotionList
                        .where((element) => element.status == status.statusInt)
                        .elementAt(index),
                    context: context,
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 5),
                ));
          } else {
            return Center(
              child: Text(CustomTexts.noPromotion),
            );
          }
        } else {
          if (state is NotLoadedState) {
            return Center(
              child: Text(CustomTexts.noPromotion),
            );
          } else {
            return CustomWidgets.customErrorWidget();
          }
        }
      },
    );
  }

  _cardBuilder({required GetPromotionModel model, required context}) {
    return BlocBuilder<PromotionListBloc, PromotionListState>(
        builder: (blocContext, state) {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            CustomRoutes.promotionDetailView,
            arguments: <String, dynamic>{
              'id': model.id,
              'status': model.status,
            },
          ).then((value) =>
              blocContext.read<PromotionListBloc>().add(EventInitData()));
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                // SizedBox(
                //   width: 80,
                //   height: 80,
                //   child: Center(
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(5.0),
                //       child: Stack(
                //         children: [
                //           const SizedBox(
                //             width: 80,
                //             height: 80,
                //             child: const DecoratedBox(
                //               decoration:
                //               const BoxDecoration(color: Colors.green),
                //             ),
                //           ),
                //           if (model.image != null)
                //             Positioned(
                //               width: 80,
                //               height: 80,
                //               child: Image(
                //                 image: model.image!,
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 50.w,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: model.promotionName,
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          CustomText(
                            text: 'Loại phế liệu: ',
                            fontSize: 43.sp,
                          ),
                          CustomText(
                            text: model.appliedScrapCategory,
                            fontSize: 43.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.orangeFFF5670A,
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          CustomText(
                            text: 'Thưởng ',
                            fontSize: 43.sp,
                          ),
                          CustomText(
                            text:
                                CustomFormats.currencyFormat(model.bonusAmount),
                            color: AppColors.orangeFFF5670A,
                            fontSize: 43.sp,
                          ),
                          CustomText(
                            text: ' khi bán đủ ',
                            fontSize: 43.sp,
                          ),
                          CustomText(
                            text: CustomFormats.currencyFormat(
                                model.appliedAmount),
                            color: AppColors.orangeFFF5670A,
                            fontSize: 43.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      CustomText(
                        text:
                            'Thời gian: ${model.appliedFromTime} đến ${model.appliedToTime}',
                        fontSize: 43.sp,
                      ),
                      // Text(
                      //     '${CustomFormats.currencyFormat.format(model.bonusAmount)} thưởng'),
                      // Text(
                      //     '${model.appliedScrapCategory} tối thiếu ${model.appliedAmount}'),
                      // Text('${model.appliedFromTime} - ${model.appliedToTime}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
