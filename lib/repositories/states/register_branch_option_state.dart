import 'package:dealer_app/utils/param_util.dart';

class RegisterBranchOptionState {
  String phone;
  String name;
  String id;
  DateTime? birthdate;
  String address;
  Sex sex;
  String password;
  String rePassword;

  bool isBranch;
  int? mainBranchId;

  Process process;

  bool get isPhoneValid => RegExp(CustomRegexs.phoneRegex).hasMatch(phone);

  RegisterBranchOptionState({
    String? phone,
    String? name,
    String? id,
    DateTime? birthdate,
    String? address,
    Sex? sex,
    String? password,
    String? rePassword,
    Process? process,
    bool? isBranch,
    int? mainBranchId,
  })  : phone = phone ?? '',
        name = name ?? '',
        id = id ?? '',
        birthdate = birthdate,
        address = address ?? '',
        sex = sex ?? Sex.male,
        password = password ?? '',
        rePassword = rePassword ?? '',
        process = process ?? Process.neutral,
        isBranch = isBranch ?? false,
        mainBranchId = mainBranchId;

  RegisterBranchOptionState copyWith({
    String? phone,
    String? name,
    String? id,
    DateTime? birthdate,
    String? address,
    Sex? sex,
    String? password,
    String? rePassword,
    Process? process,
    bool? isBranch,
    int? mainBranchId,
  }) {
    return RegisterBranchOptionState(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      id: id ?? this.id,
      birthdate: birthdate ?? this.birthdate,
      address: address ?? this.address,
      sex: sex ?? this.sex,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      process: process ?? this.process,
      isBranch: isBranch ?? this.isBranch,
      mainBranchId: mainBranchId ?? this.mainBranchId,
    );
  }
}
