part of 'order_info_bloc.dart';

abstract class OrderInfoState {}

class OrderInfoInitial extends OrderInfoState {
  OrderInfoInitial();
}

// class ValidSubmission extends OrderInfoState {
//   final Order customerOrder;
//   ValidSubmission({@required this.customerOrder, @required ORDERTYPE type})
//       : super(orderType: type);
// }

class LoadedState extends OrderInfoState {
  final List<Tables> tables;
  final List<Waiter> waiters;
  final bool validSubmission;
  final Order order;

  LoadedState({
    this.tables = const [],
    this.waiters = const [],
    required this.order,
    this.validSubmission = false,
  });
}

class LoadingState extends OrderInfoState {
  final String message;
  LoadingState({
    this.message = '',
  });
}

class ErrorState extends OrderInfoState {
  final int level;
  final String message;
  ErrorState({
    this.message = '',
    this.level = 0,
  });
}
