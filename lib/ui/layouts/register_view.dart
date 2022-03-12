import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dealer_app/blocs/register_bloc.dart';
import 'package:dealer_app/repositories/events/register_event.dart';
import 'package:dealer_app/repositories/states/register_state.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegisterView extends StatelessWidget {
  RegisterView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(initialState: RegisterState()),
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state.process == Process.processing) {
                EasyLoading.show();
              } else if (state.process == Process.processed) {
                EasyLoading.dismiss();
              } else if (state.process == Process.error) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.ERROR,
                  desc: CustomTexts.otpErrorMessage,
                  btnOkText: 'Đóng',
                );
              } else if (state.process == Process.valid) {
                Navigator.of(context).pushNamed(CustomRoutes.registerOTP,
                    arguments: {'phone': state.phone});
              }
            },
            child: Scaffold(
              body: _body(),
            ),
          );
        },
      ),
    );
  }

  _body() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 100, 30, 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomWidgets.customText(text: CustomTexts.registerWelcomeText),
                _phoneNumberField(),
                _submitButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  _phoneNumberField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.phoneLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(EventPhoneNumberChanged(phoneNumber: value)),
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.phoneBlank;
              if (!state.isPhoneValid) return CustomTexts.phoneError;
            },
          ),
        );
      },
    );
  }

  _submitButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomWidgets.customElevatedButton(
          context,
          CustomTexts.next,
          () {
            if (_formKey.currentState!.validate())
              context.read<RegisterBloc>().add(EventSendOTP());
          },
        );
      },
    );
  }
}
