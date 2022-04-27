part of 'items_menu_bloc.dart';

abstract class ItemsMenuState {
  const ItemsMenuState();
}

class InitialState extends ItemsMenuState {}

// class CategoriesLoaded extends ItemsMenuState {
//   final List<Category> list;
//   CategoriesLoaded({this.list});
// }

// class ItemsLoaded extends ItemsMenuState {
//   final List<Item> items;
//   final List<Category> categories;
//   ItemsLoaded({this.items, this.categories});
//   // @override
//   // List<Object> get props => [list];
// }

// class CartItems extends ItemsMenuState {
//   final String totalAmount;
//   final String taxAmount;
//   final String subTotal;
//   final List<Item> list;
//   CartItems({this.list, this.totalAmount, this.taxAmount, this.subTotal});

//   // @override
//   // List<Object> get props => [list];
// }

// class SubmissionValid extends ItemsMenuState {
//   final Order customerOrder;
//   final List<Item> listItems;
//   SubmissionValid({@required this.customerOrder, @required this.listItems});
// }

// class SubmissionInvalid extends ItemsMenuState {
//   final String message;
//   SubmissionInvalid({this.message});
// }

// class OrderPosted extends ItemsMenuState {
//   final String message;
//   OrderPosted({this.message});
// }

// class OrderUpdated extends ItemsMenuState {
//   final String message;
//   OrderUpdated({this.message});
// }

// class OrderPostFailed extends ItemsMenuState {
//   final String message;
//   OrderPostFailed({this.message});
// }

// class POSError extends ItemsMenuState {
//   final String message;
//   POSError({this.message});
// }

// class POSLoading extends ItemsMenuState {
//   final String message;
//   POSLoading({this.message});
// }

// class ItemAdded extends ItemsMenuState {
//   final Item item;
//   ItemAdded({this.item});
// }

// class ItemRemoved extends ItemsMenuState {
//   final Item item;
//   ItemRemoved({this.item});
// }

// class POSMenuLoaded extends ItemsMenuState {
//   final POSMenu menu;
//   POSMenuLoaded({this.menu});
// }

class LoadingState extends ItemsMenuState {
  final String message;
  LoadingState({this.message});
}

class LoadedState extends ItemsMenuState {
  final String subTotal;
  final String taxAmount;
  final String totalAmount;
  final POSMenu menu;
  final List<Item> cartItems;
  final String message;
  final bool orderCompleted;
  LoadedState({
    @required this.menu,
    @required this.cartItems,
    this.subTotal = '0',
    this.taxAmount = '0',
    this.totalAmount = '0',
    this.message,
    this.orderCompleted = false,
  });
}

class ErrorState extends ItemsMenuState {
  final String message;
  ErrorState({this.message});
}
