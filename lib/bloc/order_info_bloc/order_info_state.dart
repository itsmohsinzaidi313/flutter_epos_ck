part of 'order_info_bloc.dart';

abstract class OrderInfoState {}

class OrderInfoInitial extends OrderInfoState {}

class OrderInfoStateLoad extends OrderInfoBloc {
  final List<Member> members;
  final List<Session> sessions;
  final List<Venue> venues;
  OrderInfoStateLoad({this.members, this.sessions, this.venues});
}

class OrderInfoStateMembers extends OrderInfoState {
  final List<Member> members;
  OrderInfoStateMembers({this.members});
}

class OrderInfoStateSession extends OrderInfoState {
  final List<Session> sessions;
  OrderInfoStateSession({this.sessions});
}

class OrderInfoStateVenues extends OrderInfoState {
  final List<Venue> venues;
  OrderInfoStateVenues({this.venues});
}

class OrderInfoStateTableNo extends OrderInfoState {
  final String tableNo;
  OrderInfoStateTableNo({this.tableNo});
}

class OrderInfoStateWaiterNo extends OrderInfoState {
  final String waiterNo;
  OrderInfoStateWaiterNo({this.waiterNo});
}

class OrderInfoError extends OrderInfoState {
  final String message;
  OrderInfoError({this.message});
}

class OrderInfoValid extends OrderInfoState {
  final Order order;
  OrderInfoValid({this.order});
}
