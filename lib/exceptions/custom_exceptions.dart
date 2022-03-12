import 'package:dealer_app/utils/param_util.dart';

class UnauthorizedException implements Exception {
  final String cause;
  UnauthorizedException([this.cause = Symbols.empty]);
}
