abstract class FeedbackAdminEvent {
  const FeedbackAdminEvent();
}

class FeedbackAdminChanged extends FeedbackAdminEvent {
  const FeedbackAdminChanged(this.feedback);

  final String feedback;
}

class FeedbackAdminSubmmited extends FeedbackAdminEvent {}
