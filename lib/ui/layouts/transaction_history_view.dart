import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/transaction_history_bloc.dart';
import 'package:dealer_app/repositories/events/transaction_history_event.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/repositories/states/transaction_history_state.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionHistoryView extends StatelessWidget {
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // category screen
    return BlocProvider(
      create: (context) => TransactionHistoryBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
            listener: (context, state) {
              //process
              if (state.process == TransactionHistoryProcess.processing) {
                EasyLoading.show();
              }
              if (state.process == TransactionHistoryProcess.processed) {
                EasyLoading.dismiss();
              }
              if (state.process == TransactionHistoryProcess.invalid) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.ERROR,
                  desc: CustomTexts.generalErrorMessage,
                  btnOkText: 'Đóng',
                );
              }
              if (state.process == TransactionHistoryProcess.valid) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.SUCCES,
                  desc: CustomTexts.createTransactionSuccessfullyText,
                  btnOkText: 'Đóng',
                );
              }
            },
          ),
          // Date listener
          BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
              listenWhen: (previous, current) {
            return current.fromDate != previous.fromDate ||
                current.toDate != previous.toDate;
          }, listener: (context, state) {
            var date;
            if (state.fromDate == null && state.toDate == null) date = '';
            if (state.fromDate == null && state.toDate != null)
              date =
                  'Đén ngày ${DateFormat('dd/MM/yyyy').format(state.toDate!)}';
            if (state.fromDate != null && state.toDate == null)
              date =
                  'Từ ngày ${DateFormat('dd/MM/yyyy').format(state.fromDate!)}';
            if (state.fromDate != null && state.toDate != null)
              date =
                  '${DateFormat('dd/MM/yyyy').format(state.fromDate!)} - ${DateFormat('dd/MM/yyyy').format(state.toDate!)}';

            _dateController.text = date;
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
      elevation: 0,
      title: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
          return Text(
            CustomTexts.transactionHistoryScreenTitle,
            style: Theme.of(context).textTheme.headline1,
          );
        },
      ),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          // _searchAndFilter(),
          _transactionList(),
        ],
      ),
    );
  }

  _searchAndFilter() {
    return Container(
      height: 70,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 8,
            child: _searchField(),
          ),
          Flexible(
            flex: 2,
            child: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
              builder: (context, state) {
                return InkWell(
                  onTap: () {
                    _showFilter(context);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.filter_alt,
                        size: 35,
                        color: AppColors.greenFF61C53D,
                      ),
                      Text('Bộ lọc'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _searchField() {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              labelText: 'Tìm tên người bán...',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              fillColor: Colors.grey[200],
              filled: true,
            ),
            onChanged: (value) {
              context
                  .read<TransactionHistoryBloc>()
                  .add(EventChangeSearchName(searchName: value));
            },
          ),
        );
      },
    );
  }

  _showFilter(blocBuilderContext) {
    showModalBottomSheet(
      context: blocBuilderContext,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: BlocProvider.of<TransactionHistoryBloc>(blocBuilderContext),
          child: Container(
            padding: EdgeInsets.all(30),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              children: [
                _datePicker(),
                CustomWidgets.customText(text: 'Tiền'),
                _priceRangeSlider(),
                _resetFilterButton(sheetContext),
                _filterButton(sheetContext),
              ],
            ),
          ),
        );
      },
    );
  }

  _datePicker() {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextField(
            textAlign: TextAlign.center,
            controller: _dateController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Thời gian',
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
                                  .read<TransactionHistoryBloc>()
                                  .add(EventChangeDate(
                                    fromDate:
                                        onSelectionChanged.value.startDate,
                                    toDate: onSelectionChanged.value.endDate,
                                  ));
                            },
                            selectionMode: DateRangePickerSelectionMode.range,
                            initialSelectedRange: PickerDateRange(
                              state.fromDate,
                              state.toDate,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Đồng ý')),
                          ),
                        ]),
                      ),
                    );
                  });
            },
          ),
        );
      },
    );
  }

  _priceRangeSlider() {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return SizedBox(
          height: 70,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                bottom: 50,
                child: Text(CustomFormats.currencyFormat(state.totalMin)),
              ),
              Positioned(
                right: 10,
                bottom: 50,
                child: Text(CustomFormats.currencyFormat(state.totalMax)),
              ),
              RangeSlider(
                values: RangeValues(
                    state.fromTotal.toDouble(), state.toTotal.toDouble()),
                onChanged: (RangeValues newRange) {
                  context
                      .read<TransactionHistoryBloc>()
                      .add(EventChangeTotalRange(
                        startValue: newRange.start,
                        endValue: newRange.end,
                      ));
                },
                min: state.totalMin.toDouble(),
                max: state.totalMax.toDouble(),
                divisions: state.getDivision,
                labels: RangeLabels(
                    '${CustomFormats.currencyFormat(state.fromTotal)}',
                    '${CustomFormats.currencyFormat(state.toTotal)}'),
              ),
            ],
          ),
        );
      },
    );
  }

  _filterButton(sheetContext) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return CustomWidgets.customElevatedButton(
          context,
          'Lọc',
          () {
            context.read<TransactionHistoryBloc>().add(EventInitData());
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  _resetFilterButton(sheetContext) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return CustomWidgets.customSecondaryButton(
          text: 'Thiết lập lại',
          action: () {
            context.read<TransactionHistoryBloc>().add(EventResetFilter());
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  _transactionList() {
    return Flexible(
      child: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
          if (state.transactionList.isNotEmpty)
            return LazyLoadScrollView(
              scrollDirection: Axis.vertical,
              onEndOfPage: () {
                print('load more');
                _loadMoreTransactions(context);
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  print('init');
                  context.read<TransactionHistoryBloc>().add(EventInitData());
                },
                child: Container(
                  child: GroupedListView<CollectDealTransactionModel, DateTime>(
                    physics: AlwaysScrollableScrollPhysics(),
                    elements: _sortList(state.filteredTransactionList),
                    order: GroupedListOrder.DESC,
                    groupBy: (CollectDealTransactionModel element) => DateTime(
                        element.transactionDateTime.year,
                        element.transactionDateTime.month,
                        element.transactionDateTime.day),
                    groupSeparatorBuilder: (DateTime element) =>
                        _groupSeparatorBuilder(time: element),
                    itemBuilder: (context, element) =>
                        _listTileBuilder(model: element, context: context),
                    separator: SizedBox(height: 5),
                  ),
                ),
              ),
            );
          else
            return Center(
              child: Text('Không có giao dịch'),
            );
        },
      ),
    );
  }

  _groupSeparatorBuilder({required DateTime time}) {
    return Container(
        color: Colors.white, child: CustomWidgets.customDateText(time: time));
  }

  _listTileBuilder({
    required CollectDealTransactionModel model,
    required BuildContext context,
  }) {
    return ListTile(
      leading: CustomWidgets.customAvatar(avatar: model.image),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      tileColor: CustomColors.lightGray,
      title: Text(model.collectorName),
      subtitle: Text(CustomFormats.currencyFormat(model.total)),
      trailing: Text(
          '${model.transactionDateTime.hour.toString().padLeft(2, '0')}:${model.transactionDateTime.minute.toString().padLeft(2, '0')}'),
      onTap: () => Navigator.pushNamed(
        context,
        CustomRoutes.transactionHistoryDetailView,
        arguments: model.id,
      ),
    );
  }

  Future _loadMoreTransactions(BuildContext context) async {
    context.read<TransactionHistoryBloc>().add(EventLoadMoreTransactions());
  }

  List<CollectDealTransactionModel> _sortList(
      List<CollectDealTransactionModel> list) {
    List<CollectDealTransactionModel> newList = List.from(list);
    newList.sort((transA, transB) =>
        transA.transactionDateTime.compareTo(transB.transactionDateTime));
    return newList;
  }
}
