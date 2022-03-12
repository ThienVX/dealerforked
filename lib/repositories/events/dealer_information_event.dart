abstract class DealerInformationEvent {
  const DealerInformationEvent();
}

class DealerInformationInitial extends DealerInformationEvent {}

class DealerInformationClear extends DealerInformationEvent {}

class ModifyActivationSwitch extends DealerInformationEvent {}
