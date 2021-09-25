part of 'order_info_bloc.dart';

abstract class OrderInfoEvent {
  const OrderInfoEvent();
}

class OrderInfoBuild extends OrderInfoEvent {}

class OrderInfoMemberAdded extends OrderInfoEvent {
  final Member member;
  OrderInfoMemberAdded({this.member});
}

class OrderInfoMemberRemoved extends OrderInfoEvent {
  final Member member;
  OrderInfoMemberRemoved({this.member});
}

class OrderInfoTableNoChanged extends OrderInfoEvent {
  final String tableNo;
  OrderInfoTableNoChanged({this.tableNo});
}

class OrderInfoWaiterNoChanged extends OrderInfoEvent {
  final String waiterNo;
  OrderInfoWaiterNoChanged({this.waiterNo});
}

class OrderInfoVenueChanged extends OrderInfoEvent {
  final Venue venue;
  OrderInfoVenueChanged({this.venue});
}

class OrderInfoSessionChanged extends OrderInfoEvent {
  final Session session;
  OrderInfoSessionChanged({this.session});
}

class OrderInfoCoversChanged extends OrderInfoEvent {
  final String covers;
  OrderInfoCoversChanged({this.covers});
}

class OrderInfoPartyChanged extends OrderInfoEvent {
  final bool party;
  OrderInfoPartyChanged({this.party});
}

class OrderInfoGetMembers extends OrderInfoEvent {}

class OrderInfoSubmit extends OrderInfoEvent {}

class ResetOrderInfoOrder extends OrderInfoEvent {}
