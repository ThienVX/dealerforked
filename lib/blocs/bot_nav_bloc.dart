import 'package:dealer_app/repositories/events/bot_nav_event.dart';
import 'package:dealer_app/repositories/states/bot_nav_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotNavBloc extends Bloc<BotNavEvent, BotNavState> {
  BotNavBloc(BotNavState initialState) : super(initialState);

  @override
  Stream<BotNavState> mapEventToState(BotNavEvent event) async* {
    if (event is EventTap) yield BotNavState(event.index);
  }
}
