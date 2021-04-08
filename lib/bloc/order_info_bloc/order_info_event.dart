part of 'order_info_bloc.dart';

abstract class OrderInfoEvent extends Equatable {
  const OrderInfoEvent({this.orderType});
  final ORDERTYPE orderType;
  @override
  List<Object> get props => [];
}

enum ORDERTYPE { DINE_IN, TAKE_AWAY, DELIVERY }

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
  final String contact;
  final String address;
  final String customerName;
  final String covers;
  final Waiter waiter;
  final Tables table;
  Submit({@required ORDERTYPE type, this.covers, this.waiter, this.table, this.contact, this.address, this.customerName}) : super(orderType: type);
}
