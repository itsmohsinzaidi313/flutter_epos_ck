part of 'order_info_bloc.dart';

abstract class OrderInfoState {
  const OrderInfoState({@required this.orderType});
  final ORDERTYPE orderType;
}

class OrderInfoInitial extends OrderInfoState {
  OrderInfoInitial({@required ORDERTYPE type}) : super(orderType: type);
}

// class ValidSubmission extends OrderInfoState {
//   final Order customerOrder;
//   ValidSubmission({@required this.customerOrder, @required ORDERTYPE type})
//       : super(orderType: type);
// }

class LoadedState extends OrderInfoState {
  final String message;
  final Customer customer;
  final List<Tables> tables;
  final List<Waiter> waiters;
  final bool validSubmission;
  final Order customerOrder;

  LoadedState({
    this.tables = const [],
    this.waiters = const [],
    this.customer,
    this.message,
    this.validSubmission = false,
    this.customerOrder,
    @required ORDERTYPE type,
  }) : super(orderType: type);
}

class LoadingState extends OrderInfoState {
  final String message;
  LoadingState({
    this.message = '',
    @required ORDERTYPE type,
  }) : super(orderType: type);
}

class ErrorState extends OrderInfoState {
  final int level;
  final String message;
  ErrorState({
    this.message = '',
    this.level = 0,
    @required ORDERTYPE type,
  }) : super(orderType: type);
}
