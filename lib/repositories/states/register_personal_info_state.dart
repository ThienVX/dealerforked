import 'package:dealer_app/utils/param_util.dart';

class RegisterPersonalInfoState {
  String phone;
  String name;
  String id;
  DateTime? birthdate;
  String address;
  Sex sex;
  String password;
  String rePassword;

  bool get isPasswordValid => password.isNotEmpty && password.length >= 6;
  bool get isRePasswordValid => rePassword == password;

  Process process;

  RegisterPersonalInfoState({
    String? phone,
    String? name,
    String? id,
    DateTime? birthdate,
    String? address,
    Sex? sex,
    String? password,
    String? rePassword,
    Process? process,
  })  : phone = phone ?? '',
        name = name ?? '',
        id = id ?? '',
        birthdate = birthdate,
        address = address ?? '',
        sex = sex ?? Sex.male,
        password = password ?? '',
        rePassword = rePassword ?? '',
        process = process ?? Process.neutral;

  RegisterPersonalInfoState copyWith({
    String? phone,
    String? name,
    String? id,
    DateTime? birthdate,
    String? address,
    Sex? sex,
    String? password,
    String? rePassword,
    Process? process,
  }) {
    return RegisterPersonalInfoState(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      id: id ?? this.id,
      birthdate: birthdate ?? this.birthdate,
      address: address ?? this.address,
      sex: sex ?? this.sex,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      process: process ?? this.process,
    );
  }
}
