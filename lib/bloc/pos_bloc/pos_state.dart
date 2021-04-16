part of 'pos_bloc.dart';

abstract class POSState {
  const POSState();

  // @override
  // List<Object> get props => [];
}

class PosInitial extends POSState {}

class CategoriesLoaded extends POSState {
  final List<Category> list;
  CategoriesLoaded({this.list});
  // @override
  // List<Object> get props => [list];
}

class ItemsLoaded extends POSState {
  final List<MenuItem> list;
  ItemsLoaded({this.list});
  // @override
  // List<Object> get props => [list];
}

class CartItems extends POSState {
  final String totalAmount;
  final List<MenuItem> list;
  CartItems({this.list, this.totalAmount});

  // @override
  // List<Object> get props => [list];
}

class SubmissionValid extends POSState {
  final Order customerOrder;
  final List<MenuItem> listItems;
  SubmissionValid({@required this.customerOrder, @required this.listItems});
}

class SubmissionInvalid extends POSState {
  final String message;
  SubmissionInvalid({this.message});
}

class OrderPosted extends POSState {
  final String message;
  OrderPosted({this.message});
}

class OrderUpdated extends POSState {
  final String message;
  OrderUpdated({this.message});
}

class OrderPostFailed extends POSState {
  final String message;
  OrderPostFailed({this.message});
}

class POSError extends POSState {
  final String message;
  POSError({this.message});
}

class POSLoading extends POSState {}
