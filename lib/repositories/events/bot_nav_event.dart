import 'package:equatable/equatable.dart';

abstract class BotNavEvent extends Equatable {}

class EventTap extends BotNavEvent {
  final int index;

  EventTap(this.index);

  @override
  List<Object?> get props => [index];
}
