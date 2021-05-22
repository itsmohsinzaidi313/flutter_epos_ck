part of 'order_info_bloc.dart';

abstract class OrderInfoState {
  const OrderInfoState({@required this.orderType});
  final ORDERTYPE orderType;
}

class OrderInfoInitial extends OrderInfoState {
  OrderInfoInitial({@required ORDERTYPE type}) : super(orderType: type);
}

class OrderTypeState extends OrderInfoState {
  OrderTypeState({@required ORDERTYPE type}) : super(orderType: type);
}

class WaitersState extends OrderInfoState {
  final List<Waiter> waiters;
  WaitersState({@required this.waiters, @required ORDERTYPE type})
      : super(orderType: type);
}

class InvalidWaiter extends OrderInfoState {
  final String message;
  InvalidWaiter({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}

class TablesState extends OrderInfoState {
  final List<Tables> tables;
  TablesState({@required this.tables, @required ORDERTYPE type})
      : super(orderType: type);
}

class InvalidTables extends OrderInfoState {
  final String message;
  InvalidTables({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}

class ValidCovers extends OrderInfoState {
  final String covers;
  ValidCovers({this.covers, @required ORDERTYPE type}) : super(orderType: type);
}

class InvalidCovers extends OrderInfoState {
  final String message;
  InvalidCovers({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}

class ValidCustomer extends OrderInfoState {
  ValidCustomer({@required ORDERTYPE type}) : super(orderType: type);
}

class InvalidCustomer extends OrderInfoState {
  final String message;
  InvalidCustomer({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}

class ValidContact extends OrderInfoState {
  ValidContact({@required ORDERTYPE type}) : super(orderType: type);
}

class InvalidContact extends OrderInfoState {
  final String message;
  InvalidContact({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}

class ValidAddress extends OrderInfoState {
  ValidAddress({@required ORDERTYPE type}) : super(orderType: type);
}

class InvalidAddress extends OrderInfoState {
  final String message;
  InvalidAddress({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}

class ValidSubmission extends OrderInfoState {
  final Order customerOrder;
  ValidSubmission({@required this.customerOrder, @required ORDERTYPE type})
      : super(orderType: type);
}

class InvalidSubmission extends OrderInfoState {
  final String message;
  InvalidSubmission({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}

class CustomerFound extends OrderInfoState {
  final Customer customer;
  final String message;
  CustomerFound({this.customer, @required ORDERTYPE type, this.message})
      : super(orderType: type);
}

class CustomerNotFound extends OrderInfoState {
  final String message;
  CustomerNotFound({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}

class Nod extends OrderInfoState {
  Nod({@required ORDERTYPE type}) : super(orderType: type);
}

class OrderInfoError extends OrderInfoState {
  final String message;
  OrderInfoError({this.message, @required ORDERTYPE type})
      : super(orderType: type);
}