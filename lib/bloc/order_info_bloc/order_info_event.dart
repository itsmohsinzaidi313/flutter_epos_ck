part of 'order_info_bloc.dart';

enum ORDERTYPE { DINE_IN, TAKE_AWAY, DELIVERY }

abstract class OrderInfoEvent {
  const OrderInfoEvent({this.orderType});
  final ORDERTYPE orderType;
}

class OrderInfoBuild extends OrderInfoEvent {}

class OrderTypeChanged extends OrderInfoEvent {
  OrderTypeChanged({@required ORDERTYPE type}) : super(orderType: type);
}

class WaiterChanged extends OrderInfoEvent {
  final Waiter waiter;
  WaiterChanged({this.waiter, @required ORDERTYPE type})
      : super(orderType: type);
}

class TableChanged extends OrderInfoEvent {
  final Tables table;
  TableChanged({this.table, @required ORDERTYPE type}) : super(orderType: type);
}

class ChangeTable extends OrderInfoEvent {
  ChangeTable({@required ORDERTYPE type}) : super(orderType: type);
}

class CoversChanged extends OrderInfoEvent {
  final String covers;
  CoversChanged({this.covers, @required ORDERTYPE type})
      : super(orderType: type);
}

class CustomerChanged extends OrderInfoEvent {
  final String customerName;
  CustomerChanged({this.customerName, @required ORDERTYPE type})
      : super(orderType: type);
}

class ContactChanged extends OrderInfoEvent {
  final String contact;
  ContactChanged({this.contact, @required ORDERTYPE type})
      : super(orderType: type);
}

class AddressChanged extends OrderInfoEvent {
  final String address;
  AddressChanged({this.address, @required ORDERTYPE type})
      : super(orderType: type);
}

class Submit extends OrderInfoEvent {
  Submit({@required ORDERTYPE type}) : super(orderType: type);
}

class SearchCustomer extends OrderInfoEvent {
  SearchCustomer({@required ORDERTYPE type}) : super(orderType: type);
}

class ResetOrderInfoOrder extends OrderInfoEvent {}
