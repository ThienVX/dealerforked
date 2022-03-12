import 'package:dealer_app/blocs/register_personal_info_bloc.dart';
import 'package:dealer_app/repositories/events/register_personal_info_event.dart';
import 'package:dealer_app/repositories/states/register_personal_info_state.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPersonalInfoView extends StatelessWidget {
  RegisterPersonalInfoView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map _argumentMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return BlocProvider(
      create: (context) {
        return RegisterPersonalInfoBloc(
            initialState:
                RegisterPersonalInfoState(phone: _argumentMap['phone']));
      },
      child: BlocListener<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
        listener: (context, state) {
          if (state.process == Process.valid) {
            Navigator.of(context).pushNamed(CustomRoutes.registerBranchOption,
                arguments: <String, dynamic>{
                  'phone': state.phone,
                  'name': state.name,
                  'id': state.id,
                  'birthdate': state.birthdate,
                  'address': state.address,
                  'sex': state.sex,
                  'password': state.password,
                });
          }
        },
        child: BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
          builder: (context, state) {
            return Scaffold(
              appBar: _appBar(context),
              body: _body(),
            );
          },
        ),
      ),
    );
  }

  _appBar(context) {
    return AppBar(
      title: Text(
        CustomTexts.appBarPersonalInfoText,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  _body() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _textFields(),
                _submitButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  _textFields() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return Column(
          children: [
            _nameField(),
            _idField(),
            _birthDateField(),
            _addressField(),
            _sexField(),
            _passwordField(),
            _rePasswordField(),
          ],
        );
      },
    );
  }

  _nameField() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.nameLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) => context
                .read<RegisterPersonalInfoBloc>()
                .add(EventNameChanged(name: value)),
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.nameBlank;
            },
          ),
        );
      },
    );
  }

  _idField() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.idLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            onChanged: (value) => context
                .read<RegisterPersonalInfoBloc>()
                .add(EventIdChanged(id: value)),
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.idBlank;
            },
          ),
        );
      },
    );
  }

  _birthDateField() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            key: Key(state.birthdate.toString()),
            initialValue: state.birthdate != null
                ? '${state.birthdate!.day.toString()}/${state.birthdate!.month.toString()}/${state.birthdate!.year.toString()}'
                : null,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.birthDateLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            onTap: () {
              _datePickerPopup(context, state.birthdate);
            },
          ),
        );
      },
    );
  }

  _addressField() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.addressLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            onChanged: (value) => context
                .read<RegisterPersonalInfoBloc>()
                .add(EventAddressChanged(address: value)),
          ),
        );
      },
    );
  }

  _sexField() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (selectedValue) {
              context.read<RegisterPersonalInfoBloc>().add(
                    EventSexChanged(
                      sex: sexFormFieldItems.keys.firstWhere((element) =>
                          sexFormFieldItems[element] == selectedValue),
                    ),
                  );
            },
            value: sexFormFieldItems[state.sex],
            items: sexFormFieldItems.values.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  _passwordField() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.passwordLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            onChanged: (value) => context
                .read<RegisterPersonalInfoBloc>()
                .add(EventPasswordChanged(password: value)),
            validator: (value) {
              if (value == null || value.isEmpty)
                return CustomTexts.passwordBlank;
              if (!state.isPasswordValid) return CustomTexts.passwordError;
            },
          ),
        );
      },
    );
  }

  _rePasswordField() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.rePasswordLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            onChanged: (value) => context
                .read<RegisterPersonalInfoBloc>()
                .add(EventRePasswordChanged(rePassword: value)),
            validator: (value) {
              if (value == null || value.isEmpty)
                return CustomTexts.rePasswordBlank;
              if (!state.isRePasswordValid) return CustomTexts.rePasswordError;
            },
          ),
        );
      },
    );
  }

  _submitButton() {
    return BlocBuilder<RegisterPersonalInfoBloc, RegisterPersonalInfoState>(
      builder: (context, state) {
        return CustomWidgets.customElevatedButton(
          context,
          CustomTexts.next,
          () {
            if (_formKey.currentState!.validate())
              context
                  .read<RegisterPersonalInfoBloc>()
                  .add(EventNextButtonPressed());
          },
        );
      },
    );
  }

  _datePickerPopup(BuildContext context, DateTime? initDate) {
    Function(DateTime) _setBirthdate = (pickedDate) => context
        .read<RegisterPersonalInfoBloc>()
        .add(EventBirthdateChanged(birthdate: pickedDate));

    showDatePicker(
      context: context,
      initialDate: initDate ?? DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      helpText: CustomTexts.birthDatePickerHelpText,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        _setBirthdate(pickedDate);
        return;
      }
    });
  }
}
