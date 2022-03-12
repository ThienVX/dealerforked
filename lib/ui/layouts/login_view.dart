import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/login_bloc.dart';
import 'package:dealer_app/repositories/events/login_event.dart';
import 'package:dealer_app/repositories/states/login_state.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        initialState: LoginState(),
      ),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.process == Process.processing) {
            EasyLoading.show();
          } else {
            EasyLoading.dismiss();
            if (state.process == Process.invalid) {
              FunctionalWidgets.showAwesomeDialog(
                context,
                dialogType: DialogType.ERROR,
                desc: CustomTexts.wrongPasswordOrPhone,
                btnOkText: 'Đóng',
              );
            }
            if (state.process == Process.error) {
              FunctionalWidgets.showAwesomeDialog(
                context,
                dialogType: DialogType.ERROR,
                desc: CustomTexts.loginError,
                btnOkText: 'Đóng',
              );
            }
          }
        },
        child: _body(),
      ),
    );
  }

  _body() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //logo
                  Image.asset(
                    CustomAssets.logoAndText,
                    height: 140,
                  ),
                  CustomWidgets.customText(
                    text: CustomTexts.loginToContinue,
                    alignment: Alignment.center,
                    fontSize: 50.sp,
                  ),
                  _phoneNumberField(),
                  _passwordField(),
                  _loginButton(),
                  _forgetPasswordOption(context),
                  // _registerOption(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _phoneNumberField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SizedBox(
          height: 75,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              labelText: CustomTexts.phoneLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => context
                .read<LoginBloc>()
                .add(EventLoginPhoneNumberChanged(phoneNumber: value)),
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.phoneBlank;
              if (!state.isPhoneValid) return CustomTexts.phoneError;
            },
          ),
        );
      },
    );
  }

  _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SizedBox(
          height: 85,
          child: TextFormField(
              obscureText: state.isPasswordObscured,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                labelText: CustomTexts.passwordLabel,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                //show hide pw icon
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on isPasswordVisible of state choose the icon
                    state.isPasswordObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state
                    context.read<LoginBloc>().add(EventShowHidePassword());
                  },
                ),
              ),
              //validate
              onChanged: (value) => context
                  .read<LoginBloc>()
                  .add(EventLoginPasswordChanged(password: value)),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return CustomTexts.passwordBlank;
                if (!state.isPasswordValid) return CustomTexts.passwordError;
              }),
        );
      },
    );
  }

  _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          child: CustomWidgets.customElevatedButton(
            context,
            CustomTexts.loginButton,
            () {
              if (_formKey.currentState!.validate()) {
                context.read<LoginBloc>().add(EventLoginButtonSubmmited());
              }
            },
          ),
        );
      },
    );
  }

  _forgetPasswordOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // CustomWidgets.customText(text: CustomTexts.forgetPassword),
        //TODO: forget password
        Container(
          margin: EdgeInsets.only(top: 50.h),
          child: CustomWidgets.customTextButton(
              text: CustomTexts.forgetPasswordText,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CustomRoutes.forgetPasswordPhoneNumber);
              }),
        ),
      ],
    );
  }

  _registerOption() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomWidgets.customText(text: CustomTexts.register),
            CustomWidgets.customTextButton(
                text: CustomTexts.registerTextButton,
                onPressed: () {
                  Navigator.of(context).pushNamed(CustomRoutes.register);
                }),
          ],
        );
      },
    );
  }
}
