import 'package:dealer_app/blocs/authentication_bloc.dart';
import 'package:dealer_app/blocs/profile_bloc.dart';
import 'package:dealer_app/repositories/events/authentication_event.dart';
import 'package:dealer_app/repositories/models/gender_model.dart';
import 'package:dealer_app/repositories/states/profile_state.dart';
import 'package:dealer_app/ui/layouts/profile_layout.dart';
import 'package:dealer_app/ui/layouts/profile_password_edit_layout.dart';
import 'package:dealer_app/ui/widgets/cached_avatar_widget.dart';
import 'package:dealer_app/ui/widgets/custom_text_widget.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0XFFF8F8F8),
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0XFFF8F8F8),
        body: AccountBody(),
      ),
    );
  }
}

class AccountBody extends StatelessWidget {
  const AccountBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        avatar(context),
        options(context),
      ],
    );
  }

  Widget avatar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500.h,
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
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Row(
            children: [
              Container(
                child: CachedAvatarWidget(
                  path: state.image ?? Symbols.empty,
                  isMale: state.gender == Gender.male,
                  width: 250,
                ),
                margin: EdgeInsets.only(
                    left: 70.w, top: 170.h, right: 40.w, bottom: 40.h),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: CustomText(
                        text: state.name,
                        color: AppColors.white,
                        fontSize: 70.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      margin: EdgeInsets.only(
                          top: 170.h, right: 80.w, bottom: 20.h),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text: '${state.phone}',
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget options(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return option(
                'Thông tin tài khoản',
                () {
                  Navigator.of(context).pushNamed(
                    CustomRoutes.profileEdit,
                    arguments: ProfileArgs(
                      name: state.name,
                      imagePath: state.image ?? Symbols.empty,
                      phoneNumber: state.phone,
                      address: state.address ?? Symbols.empty,
                      email: state.email ?? Symbols.empty,
                      gender: state.gender,
                      birthdate: state.birthDate ?? DateTime.now(),
                      idCard: state.idCard,
                    ),
                  );
                },
                Colors.black,
                Icons.arrow_forward_ios,
              );
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return option(
                'Thông tin vựa',
                () {
                  Navigator.of(context).pushNamed(CustomRoutes.dealerInfo);
                },
                Colors.black,
                Icons.arrow_forward_ios,
              );
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return option(
                'Đổi mật khẩu',
                () {
                  Navigator.of(context).pushNamed(
                      CustomRoutes.profilePasswordEdit,
                      arguments: ProfilePasswordEditArgs(state.id));
                },
                Colors.black,
                Icons.arrow_forward_ios,
              );
            },
          ),
          option(
            'Đăng xuất',
            () {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
            },
            Colors.red,
            Icons.logout_outlined,
          ),
        ],
      ),
    );
  }

  Widget option(String name, void Function() onPressed, Color color,
      [IconData? iconData]) {
    return Container(
      color: Colors.white70,
      height: 180.h,
      margin: EdgeInsets.symmetric(
        vertical: 3.h,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.only(
              right: 40.w,
              left: 80.w,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: name,
                    color: color,
                    fontSize: 45.sp,
                  ),
                ),
                Icon(
                  iconData,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
