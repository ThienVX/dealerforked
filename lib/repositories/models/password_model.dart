import 'package:dealer_app/utils/param_util.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

enum PasswordError { invalid }

class CommonPassword extends Equatable {
  const CommonPassword({
    this.value = '',
    this.isHide = true,
  });

  final String value;
  final bool isHide;

  CommonPassword copyWith({String? value, bool? isHide}) {
    return CommonPassword(
      value: value ?? this.value,
      isHide: isHide ?? this.isHide,
    );
  }

  @override
  List<Object?> get props => [value, isHide];
}

class Password extends FormzInput<CommonPassword, PasswordError> {
  const Password.pure({
    CommonPassword password = const CommonPassword(),
  }) : super.pure(
          password,
        );
  Password.dirty({
    CommonPassword password = const CommonPassword(),
  }) : super.dirty(
          password,
        );

  bool _validate(CommonPassword value) {
    return value.value.length >= 6;
  }

  @override
  PasswordError? validator(CommonPassword? value) {
    if (value == null) {
      return PasswordError.invalid;
    }

    return _validate(value) ? null : PasswordError.invalid;
  }
}

enum RepeatPasswordError { invalid }

class RepeatPassword extends FormzInput<CommonPassword, RepeatPasswordError> {
  const RepeatPassword.pure({
    CommonPassword password = const CommonPassword(),
    this.currentPassword = Symbols.empty,
  }) : super.pure(password);

  const RepeatPassword.dirty({
    CommonPassword password = const CommonPassword(),
    this.currentPassword = Symbols.empty,
  }) : super.dirty(password);

  final String currentPassword;

  bool _validate(String value) {
    return value == currentPassword;
  }

  @override
  RepeatPasswordError? validator(CommonPassword value) {
    return _validate(value.value) ? null : RepeatPasswordError.invalid;
  }
}
