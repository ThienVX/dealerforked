import 'package:dealer_app/blocs/bot_nav_bloc.dart';
import 'package:dealer_app/blocs/dealer_information_bloc.dart';
import 'package:dealer_app/blocs/notification_bloc.dart';
import 'package:dealer_app/blocs/profile_bloc.dart';
import 'package:dealer_app/repositories/events/bot_nav_event.dart';
import 'package:dealer_app/repositories/events/dealer_information_event.dart';
import 'package:dealer_app/repositories/events/notification_event.dart';
import 'package:dealer_app/repositories/events/profile_event.dart';
import 'package:dealer_app/repositories/states/bot_nav_state.dart';
import 'package:dealer_app/repositories/states/notification_state.dart';
import 'package:dealer_app/ui/layouts/account_layout.dart';
import 'package:dealer_app/ui/layouts/notification_view.dart';
import 'package:dealer_app/ui/layouts/statistic_layout.dart';
import 'package:dealer_app/ui/layouts/transaction_history_view.dart';
import 'package:dealer_app/ui/widgets/custom_text_widget.dart';
import 'package:dealer_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_view.dart';

enum BotNavItem {
  STATISTIC,
  NOTIFICATION,
  HOME,
  ACTIVITY,
  PROFILE,
}

extension BotNavItemExtension on BotNavItem {
  int get index {
    switch (this) {
      case BotNavItem.STATISTIC:
        return 0;
      case BotNavItem.NOTIFICATION:
        return 1;
      case BotNavItem.HOME:
        return 2;
      case BotNavItem.ACTIVITY:
        return 3;
      case BotNavItem.PROFILE:
        return 4;
      default:
        return 2;
    }
  }
}

class BotNavView extends StatefulWidget {
  const BotNavView({Key? key}) : super(key: key);

  @override
  _BotNavViewState createState() => _BotNavViewState();
}

class _BotNavViewState extends State<BotNavView> {
  @override
  void initState() {
    super.initState();

    // Get number of  unread notifcation count
    context.read<NotificationBloc>().add(NotificationUncountGet());

    initProfileBloc();
  }

  void initProfileBloc() {
    //profile
    context.read<ProfileBloc>().add(ProfileClear());
    context.read<ProfileBloc>().add(ProfileInitial());
    //dealer informatiom
    context.read<DealerInformationBloc>().add(DealerInformationClear());
    context.read<DealerInformationBloc>().add(DealerInformationInitial());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BotNavBloc(BotNavState(BotNavItem.HOME.index)),
      child: Scaffold(
        body: _body(),
        bottomNavigationBar: _botnav(),
      ),
    );
  }
}

_body() {
  return BlocBuilder<BotNavBloc, BotNavState>(
    builder: (context, state) {
      if (state.index == BotNavItem.STATISTIC.index) return StatisticLayout();
      if (state.index == BotNavItem.HOME.index) return HomeView();
      if (state.index == BotNavItem.ACTIVITY.index)
        return TransactionHistoryView();
      if (state.index == BotNavItem.NOTIFICATION.index)
        return NotificationView();
      if (state.index == BotNavItem.PROFILE.index)
        return AccountLayout();
      else
        return Container();
    },
  );
}

Widget getWidgetNoti(IconData icon) {
  return BlocBuilder<NotificationBloc, NotificationState>(
    builder: (context, state) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon),
          state.unreadCount > 0
              ? Positioned(
                  // draw a red marble
                  top: -25.0.h,
                  right: -20.0.w,
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: CustomText(
                        color: Colors.white,
                        text: state.unreadCount <= 99
                            ? '${state.unreadCount}'
                            : '99+',
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    },
  );
}

_botnav() {
  return BlocBuilder<BotNavBloc, BotNavState>(
    builder: (context, state) {
      return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.greenFF01C971,
          unselectedFontSize: 23.sp,
          selectedFontSize: 26.sp,
          currentIndex: state.index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Thống kê',
              icon: Icon(Icons.analytics_outlined),
              activeIcon: RadiantGradientMask(child: Icon(Icons.analytics)),
            ),
            BottomNavigationBarItem(
              icon: getWidgetNoti(Icons.notifications_outlined),
              label: 'Thông báo',
              activeIcon: getWidgetNoti(Icons.notifications),
            ),
            BottomNavigationBarItem(
              label: 'Trang chủ',
              icon: Icon(Icons.home_outlined),
              activeIcon: RadiantGradientMask(child: Icon(Icons.home)),
            ),
            BottomNavigationBarItem(
              label: 'Hoạt động',
              icon: Icon(Icons.history_outlined),
              activeIcon: RadiantGradientMask(child: Icon(Icons.history)),
            ),
            BottomNavigationBarItem(
              label: 'Tài khoản',
              icon: Icon(Icons.person_outline),
              activeIcon: RadiantGradientMask(child: Icon(Icons.person)),
            ),
          ],
          onTap: (value) {
            BlocProvider.of<BotNavBloc>(context).add(EventTap(value));
          },
        ),
      );
    },
  );
}
