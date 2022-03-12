import 'package:equatable/equatable.dart';

abstract class DealerInfoEvent extends Equatable {}

class EventInitData extends DealerInfoEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeBranch extends DealerInfoEvent {
  final String branchId;

  EventChangeBranch(this.branchId);

  @override
  List<Object?> get props => [];
}
