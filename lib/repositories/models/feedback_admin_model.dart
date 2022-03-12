import 'package:dealer_app/utils/param_util.dart';
import 'package:formz/formz.dart';

enum FeedbackAdminError { invalid }

class FeedbackAdmin extends FormzInput<String, FeedbackAdminError> {
  const FeedbackAdmin.dirty([String value = Symbols.empty])
      : super.dirty(value);
  const FeedbackAdmin.pure([String value = Symbols.empty]) : super.pure(value);

  bool _validate(String value) {
    return value.trim().isNotEmpty;
  }

  @override
  FeedbackAdminError? validator(String value) {
    return _validate(value) ? null : FeedbackAdminError.invalid;
  }
}
