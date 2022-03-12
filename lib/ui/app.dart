import 'package:dealer_app/blocs/authentication_bloc.dart';
import 'package:dealer_app/blocs/dealer_information_bloc.dart';
import 'package:dealer_app/blocs/notification_bloc.dart';
import 'package:dealer_app/blocs/profile_bloc.dart';
import 'package:dealer_app/constants/common_constants.dart';
import 'package:dealer_app/repositories/handlers/authentication_handler.dart';
import 'package:dealer_app/repositories/handlers/user_handler.dart';
import 'package:dealer_app/repositories/states/authentication_state.dart';
import 'package:dealer_app/ui/layouts/add_promotion_view.dart';
import 'package:dealer_app/ui/layouts/category_detail_view.dart';
import 'package:dealer_app/ui/layouts/category_list_view.dart';
import 'package:dealer_app/ui/layouts/create_transaction_view.dart';
import 'package:dealer_app/ui/layouts/dealer_info_view.dart';
import 'package:dealer_app/ui/layouts/forget_password_new_password_layout.dart';
import 'package:dealer_app/ui/layouts/forget_password_otp_layout.dart';
import 'package:dealer_app/ui/layouts/forget_password_phone_number_layout.dart';
import 'package:dealer_app/ui/layouts/login_view.dart';
import 'package:dealer_app/ui/layouts/profile_layout.dart';
import 'package:dealer_app/ui/layouts/profile_password_edit_layout.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'layouts/add_category_view.dart';
import 'layouts/bot_nav_view.dart';
import 'layouts/promotion_detail_view.dart';
import 'layouts/promotion_list_view.dart';
import 'layouts/register_branch_option_view.dart';
import 'layouts/register_complete_view.dart';
import 'layouts/register_otp_view.dart';
import 'layouts/register_personal_info_view.dart';
import 'layouts/register_store_info_view.dart';
import 'layouts/register_view.dart';
import 'layouts/transaction_history_detail_view.dart';
import 'layouts/transaction_history_view.dart';

class DealerApp extends StatelessWidget {
  final AuthenticationHandler authenticationHandler;
  final UserHandler userHandler;

  static final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigatorKey.currentState!;

  DealerApp({
    Key? key,
    required this.authenticationHandler,
    required this.userHandler,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          DeviceConstants.logicalWidth, DeviceConstants.logicalHeight),
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(),
          ),
          BlocProvider(
            create: (context) => DealerInformationBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _themeData(),
          navigatorKey: navigatorKey,
          routes: {
            CustomRoutes.addCategory: (_) => AddCategoryView(),
            CustomRoutes.categoryDetail: (_) => CategoryDetailView(),
            CustomRoutes.botNav: (_) => BotNavView(),
            CustomRoutes.register: (_) => RegisterView(),
            CustomRoutes.registerOTP: (_) => RegisterOTPView(),
            CustomRoutes.registerPersonalInfo: (_) =>
                RegisterPersonalInfoView(),
            CustomRoutes.registerBranchOption: (_) =>
                RegisterBranchOptionView(),
            CustomRoutes.registerStoreInfo: (_) => RegisterStoreInfoView(),
            CustomRoutes.registerComplete: (_) => RegisterCompleteView(),
            CustomRoutes.login: (_) => LoginView(),
            CustomRoutes.createTransaction: (_) => CreateTransactionView(),
            CustomRoutes.transactionHistory: (_) => TransactionHistoryView(),
            CustomRoutes.transactionHistoryDetailView: (_) =>
                TransactionHistoryDetailView(),
            CustomRoutes.promotionListView: (_) => PromotionListView(),
            CustomRoutes.promotionDetailView: (_) => PromotionDetailView(),
            CustomRoutes.categoryList: (_) => CategoryListView(),
            CustomRoutes.addPromotion: (_) => AddPromotionView(),
            CustomRoutes.profilePasswordEdit: (_) =>
                const ProfilePasswordEditLayout(),
            CustomRoutes.profileEdit: (_) => ProfileLayout(),
            CustomRoutes.forgetPasswordPhoneNumber: (_) =>
                const ForgetPasswordPhoneNumberLayout(),
            CustomRoutes.forgetPasswordOTP: (_) =>
                const ForgetPasswordOTPLayout(),
            CustomRoutes.forgetPasswordNewPassword: (_) =>
                const ForgetPasswordNewPasswordLayout(),
            CustomRoutes.dealerInfo: (_) => DealerInfoView(),
          },
          home: LoginView(),
          builder: (context, child) {
            Widget error = Text('...rendering error...');
            if (child is Scaffold || child is Navigator)
              error = Scaffold(body: Center(child: error));
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;

            return FlutterEasyLoading(
              child: BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      _navigator.pushNamedAndRemoveUntil(
                          CustomRoutes.botNav, (route) => false);
                      break;
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushNamedAndRemoveUntil(
                          CustomRoutes.login, (route) => false);
                      break;
                    default:
                      break;
                  }
                },
                child: child,
              ),
            );
          },
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('vi'),
          ],
          locale: const Locale('vi'),
        ),
      ),
    );
  }

  _themeData() {
    return ThemeData(
      primarySwatch: Colors.green,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        iconTheme: IconThemeData(size: 25),
        actionsIconTheme: IconThemeData(size: 25),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.green,
        unselectedLabelColor: Colors.black,
      ),
      dividerTheme: DividerThemeData(
        color: Color.fromARGB(255, 20, 20, 21),
        thickness: 0.2,
        space: 30,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 25,
          color: Color.fromARGB(255, 20, 20, 21),
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 20, 20, 21),
          fontWeight: FontWeight.w500,
        ),
        bodyText1: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 20, 20, 21),
          fontWeight: FontWeight.w500,
        ),
        // orange subtitle
        bodyText2: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 20, 20, 21),
          // fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
