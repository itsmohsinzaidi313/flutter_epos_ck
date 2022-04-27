part of 'orders_bloc.dart';

abstract class OrdersBlocState {
  const OrdersBlocState();
}

class InitialState extends OrdersBlocState {
  const InitialState();
}

class LoadedState extends OrdersBlocState {
  final List<Order> ordersList;
  const LoadedState({this.ordersList});
}

class LoadingState extends OrdersBlocState {
  final String message;
  const LoadingState({this.message});
}

class ErrorState extends OrdersBlocState {
  final String message;
  const ErrorState({this.message});
}
