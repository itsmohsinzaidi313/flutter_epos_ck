part of 'items_menu_bloc.dart';

abstract class ItemsMenuState {
  const ItemsMenuState();
}

class InitialState extends ItemsMenuState {}

class LoadingState extends ItemsMenuState {
  final String? message;
  LoadingState({this.message});
}

class LoadedState extends ItemsMenuState {
  final String subTotal;
  final String taxAmount;
  final String totalAmount;
  final POSMenu menu;
  final Order order;
  final String message;
  final bool orderCompleted;
  LoadedState({
    required this.menu,
    required this.order,
    this.subTotal = '0',
    this.taxAmount = '0',
    this.totalAmount = '0',
    this.message = '',
    this.orderCompleted = false,
  });
}

class ErrorState extends ItemsMenuState {
  final String? message;
  ErrorState({this.message});
}
