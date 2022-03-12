abstract class StatisticEvent {
  const StatisticEvent();
}

class StatisticGet extends StatisticEvent {}

class StatisticIntial extends StatisticEvent {}

class StatisticChanged extends StatisticEvent {
  StatisticChanged(this.fromDate, this.toDate);
  final DateTime fromDate;
  final DateTime toDate;
}

class StatisticDealerChanged extends StatisticEvent {
  StatisticDealerChanged(this.id);
  final String id;
}
