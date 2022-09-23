part of 'order_info_bloc.dart';

abstract class OrderInfoEvent {}

class OrderInfoBuild extends OrderInfoEvent {
  OrderInfoBuild({required OrderType orderType});
}

class OrderTypeChanged extends OrderInfoEvent {
  final OrderType orderType;
  OrderTypeChanged({required this.orderType});
}

class WaiterChanged extends OrderInfoEvent {
  final Waiter waiter;
  WaiterChanged({required this.waiter});
}

class TableChanged extends OrderInfoEvent {
  final Tables table;
  TableChanged({required this.table});
}

class ChangeTable extends OrderInfoEvent {
  ChangeTable({required OrderType type});
}

class CoversChanged extends OrderInfoEvent {
  final String covers;
  CoversChanged({required this.covers});
}

class CustomerChanged extends OrderInfoEvent {
  final String customerName;
  CustomerChanged({required this.customerName});
}

class ContactChanged extends OrderInfoEvent {
  final String contact;
  ContactChanged({required this.contact});
}

class AddressChanged extends OrderInfoEvent {
  final String address;
  AddressChanged({required this.address});
}

class NextPressed extends OrderInfoEvent {
  NextPressed({required OrderType orderType});
}

class SearchCustomer extends OrderInfoEvent {
  SearchCustomer({required OrderType type});
}

class ResetOrderInfoOrder extends OrderInfoEvent {
  ResetOrderInfoOrder({required OrderType orderType});
}
