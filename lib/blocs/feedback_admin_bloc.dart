import 'package:dealer_app/log/logger.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/services/transaction_service.dart';
import 'package:dealer_app/repositories/events/feedback_admin_event.dart';
import 'package:dealer_app/repositories/models/feedback_admin_model.dart';
import 'package:dealer_app/repositories/states/feedback_admin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class FeedbackAdminBloc extends Bloc<FeedbackAdminEvent, FeedbackAdminState> {
  late final TransactionService _transactionService;
  FeedbackAdminBloc({
    required String requestId,
    TransactionService? transactionService,
  }) : super(
          FeedbackAdminState(
            requestId: requestId,
          ),
        ) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }

  @override
  Stream<FeedbackAdminState> mapEventToState(FeedbackAdminEvent event) async* {
    if (event is FeedbackAdminChanged) {
      try {
        var feedback = FeedbackAdmin.dirty(event.feedback);
        yield state.copyWith(
          feedbackAdmin: feedback,
          status: Formz.validate([feedback]),
        );
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is FeedbackAdminSubmmited) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );
        var feedback = FeedbackAdmin.dirty(state.feedbackAdmin.value);
        yield state.copyWith(
          feedbackAdmin: feedback,
          status: Formz.validate([feedback]),
        );

        if (state.status.isValid) {
          bool result = await _transactionService.feedbackAdmin(
            state.requestId,
            state.feedbackAdmin.value,
          );

          if (result) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
            );
          } else {
            throw Exception('feedbackAdmin is false');
          }
        } else {
          throw Exception('Feedback admin is not valid');
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
