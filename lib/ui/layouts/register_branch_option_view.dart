import 'package:dealer_app/blocs/register_branch_option_bloc.dart';
import 'package:dealer_app/repositories/events/register_branch_option_event.dart';
import 'package:dealer_app/repositories/states/register_branch_option_state.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';

class RegisterBranchOptionView extends StatelessWidget {
  RegisterBranchOptionView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map _argumentMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (context) {
        return RegisterBranchOptionBloc(
            initialState: RegisterBranchOptionState(
          phone: _argumentMap['phone'],
          name: _argumentMap['name'],
          id: _argumentMap['id'],
          birthdate: _argumentMap['birthdate'],
          address: _argumentMap['address'],
          sex: _argumentMap['sex'],
          password: _argumentMap['password'],
        ));
      },
      child: BlocListener<RegisterBranchOptionBloc, RegisterBranchOptionState>(
        listener: (context, state) {
          if (state.process == Process.valid) {
            Navigator.of(context)
                .pushNamed(CustomRoutes.registerStoreInfo, arguments: {
              'phone': state.phone,
              'name': state.name,
              'id': state.id,
              'birthdate': state.birthdate,
              'address': state.address,
              'sex': state.sex,
              'password': state.password,
              'isBranch': state.isBranch,
              'mainBranchId': state.mainBranchId,
            });
          }
        },
        child: BlocBuilder<RegisterBranchOptionBloc, RegisterBranchOptionState>(
          builder: (context, state) {
            return Scaffold(
              appBar: _appBar(context),
              body: Container(
                child: _body(),
              ),
            );
          },
        ),
      ),
    );
  }

  _appBar(context) {
    return AppBar(
      title: Text(
        CustomTexts.appBarBranchOptionText,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  _body() {
    return BlocBuilder<RegisterBranchOptionBloc, RegisterBranchOptionState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomWidgets.customText(text: CustomTexts.isBranchText),
                _radioButtons(),
                if (state.isBranch) _mainBranchIdField(),
                _submitButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  _radioButtons() {
    return BlocBuilder<RegisterBranchOptionBloc, RegisterBranchOptionState>(
      builder: (context, state) {
        return Column(
          children: [
            ListTile(
              title: Text(
                isBranchRadioOptions[false] ?? '',
              ),
              leading: Radio(
                  value: false,
                  groupValue: state.isBranch,
                  onChanged: (bool? value) {
                    if (value != null)
                      context
                          .read<RegisterBranchOptionBloc>()
                          .add(EventIsBranchChanged(isBranch: value));
                  }),
            ),
            ListTile(
              title: Text(
                isBranchRadioOptions[true] ?? '',
              ),
              leading: Radio(
                  value: true,
                  groupValue: state.isBranch,
                  onChanged: (bool? value) {
                    if (value != null)
                      context
                          .read<RegisterBranchOptionBloc>()
                          .add(EventIsBranchChanged(isBranch: value));
                  }),
            ),
          ],
        );
      },
    );
  }

  _mainBranchIdField() {
    return BlocBuilder<RegisterBranchOptionBloc, RegisterBranchOptionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownSearch(
            mode: Mode.MENU,
            showSelectedItems: true,
            showSearchBox: true,
            onFind: (String? filter) => _getData(filter),
            label: CustomTexts.mainBranchIdLabel,
            selectedItem: _mainBracnhIdFormFieldItems[state.mainBranchId],
            validator: (value) {
              if (state.isBranch && (value == null || value == ''))
                return CustomTexts.mainBranchIdBlank;
            },
            onChanged: (selectedValue) {
              context.read<RegisterBranchOptionBloc>().add(
                    EventMainBranchChanged(
                      mainBranchId: _mainBracnhIdFormFieldItems.keys.firstWhere(
                          (element) =>
                              _mainBracnhIdFormFieldItems[element] ==
                              selectedValue),
                    ),
                  );
            },
          ),
        );
      },
    );
  }

  _submitButton() {
    return BlocBuilder<RegisterBranchOptionBloc, RegisterBranchOptionState>(
      builder: (context, state) {
        return CustomWidgets.customElevatedButton(
          context,
          CustomTexts.next,
          () {
            if (_formKey.currentState!.validate())
              context
                  .read<RegisterBranchOptionBloc>()
                  .add(EventNextButtonPressed());
          },
        );
      },
    );
  }

//TODO getdata

//main branch dropdown form field
  static const Map<int, String> _mainBracnhIdFormFieldItems = {
    1: 'Vựa ve chai Lê Văn Việt',
    2: 'Vựa ve chai 69',
    3: 'Vựa ve chai FPT chi nhánh 1',
  };

  Future<List<String>> _getData(filter) async {
    final data = _mainBracnhIdFormFieldItems.values.toList();
    if (data != null) {
      return data;
    }
    return [];
  }
}
