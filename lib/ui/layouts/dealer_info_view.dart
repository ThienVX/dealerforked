import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/authentication_bloc.dart';
import 'package:dealer_app/blocs/dealer_info_bloc.dart';
import 'package:dealer_app/repositories/events/dealer_info_event.dart';
import 'package:dealer_app/repositories/models/get_branches_model.dart';
import 'package:dealer_app/repositories/states/authentication_state.dart';
import 'package:dealer_app/repositories/states/dealer_info_state.dart';
import 'package:dealer_app/ui/widgets/arrow_back_button.dart';
import 'package:dealer_app/ui/widgets/custom_text_widget.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DealerInfoView extends StatelessWidget {
  DealerInfoView({Key? key}) : super(key: key);

  final TextEditingController _dealerNameController = TextEditingController();
  final TextEditingController _dealerPhoneController = TextEditingController();
  final TextEditingController _dealerAddressController =
      TextEditingController();
  final TextEditingController _dealerTimeController = TextEditingController();
  final TextEditingController _dealerBranchNameController =
      TextEditingController();
  final TextEditingController _dealerBranchPhoneController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Show loading
        EasyLoading.show();
        return DealerInfoBloc();
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<DealerInfoBloc, DealerInfoState>(
            listener: (context, state) {
              if (state is LoadingState) EasyLoading.show();
              if (state is ErrorState) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.ERROR,
                  desc: state.message,
                  btnOkText: 'Đóng',
                );
              }
              if (state is LoadedState) {
                EasyLoading.dismiss();
              }
            },
          ),
          BlocListener<DealerInfoBloc, DealerInfoState>(
            listener: (context, state) {
              _dealerNameController.text = state.dealerName;
              _dealerPhoneController.text = state.dealerPhone;
              _dealerAddressController.text = state.dealerAddress;

              var validTime =
                  state.openTime != 'N/A' && state.closeTime != 'N/A';
              _dealerTimeController.text =
                  validTime ? '${state.openTime} - ${state.closeTime}' : '';

              _dealerBranchNameController.text =
                  state.dealerAccountBranch?.name ?? '';
              _dealerBranchPhoneController.text =
                  state.dealerAccountBranch?.phone ?? '';
            },
          ),
        ],
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _appBar(),
          body: _body(),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
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
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
      ),
      title: BlocBuilder<DealerInfoBloc, DealerInfoState>(
        builder: (dealerInfoContext, dealerInfoState) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (authContext, authState) {
            if (authState.user!.roleKey == DealerRoleKey.MAIN_BRANCH.number)
              return chooseDealer();
            else
              return Text(
                dealerInfoState.dealerName,
                style: TextStyle(color: AppColors.white, fontSize: 50.sp),
                overflow: TextOverflow.ellipsis,
              );
          });
        },
      ),
    );
  }

  Widget chooseDealer() {
    var dropDownColor = Colors.white;
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      builder: (context, state) {
        return DropdownSearch<GetBranchesModel>(
          mode: Mode.BOTTOM_SHEET,
          items: state.branches,
          label: null,
          onChanged: (value) {
            if (value != null) {
              context.read<DealerInfoBloc>().add(EventChangeBranch(value.id));
            }
          },
          dropDownButton: Icon(
            Icons.arrow_drop_down,
            color: dropDownColor,
          ),
          dropdownBuilder: (context, selectedItem) {
            if (selectedItem != null) {
              return CustomText(
                text: selectedItem.dealerBranchName,
                color: dropDownColor,
              );
            }
            return Container();
          },
          dropdownSearchDecoration: InputDecoration(border: InputBorder.none),
          itemAsString: (item) {
            return item!.dealerBranchName;
          },
          selectedItem: state.branches.isNotEmpty ? state.branches.first : null,
          emptyBuilder: (context, searchEntry) => Center(
            child: CustomWidgets.customText(text: 'Không có vựa nào'),
          ),
        );
      },
    );
  }

  _body() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
              child: ListView(
            children: [
              if (state.dealerImage != null) _image(),
              ListView(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                primary: false,
                shrinkWrap: true,
                children: [
                  CustomWidgets.customText(
                      text: 'Thông tin vựa', fontWeight: FontWeight.w500),
                  _dealerName(),
                  _dealerPhone(),
                  _dealerAddress(),
                  SizedBox(height: 20),
                  _dealerTime(),
                  if (state.dealerAccountBranch != null)
                    CustomWidgets.customText(
                        text: 'Người quản lý', fontWeight: FontWeight.w500),
                  if (state.dealerAccountBranch != null) _dealerBranchName(),
                  if (state.dealerAccountBranch != null) _dealerBranchPhone(),
                ],
              ),
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

  _image() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 200,
          child: Image(
            image: state.dealerImage!,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  _dealerName() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Tên vựa phế liệu',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerNameController,
            readOnly: true,
          ),
        );
      },
    );
  }

  _dealerPhone() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Số điện thoại',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerPhoneController,
            readOnly: true,
          ),
        );
      },
    );
  }

  _dealerAddress() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 100,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Địa chỉ',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerAddressController,
            readOnly: true,
            maxLines: null,
            minLines: null,
            expands: true,
          ),
        );
      },
    );
  }

  _dealerTime() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Thời gian hoạt động',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerTimeController,
            readOnly: true,
          ),
        );
      },
    );
  }

  _dealerBranchName() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Tên',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerBranchNameController,
            readOnly: true,
          ),
        );
      },
    );
  }

  _dealerBranchPhone() {
    return BlocBuilder<DealerInfoBloc, DealerInfoState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: 'Số điện thoại',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: _dealerBranchPhoneController,
            readOnly: true,
          ),
        );
      },
    );
  }
}
