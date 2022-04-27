part of 'items_menu_bloc.dart';

abstract class ItemsMenuEvents {
  const ItemsMenuEvents();

  // @override
  // List<Object> get props => [];
}

class LoadItems extends ItemsMenuEvents {
  final String categoryId;
  LoadItems({@required this.categoryId});
  // @override
  // List<Object> get props => [categoryId];
}

class ItemsMenuBuild extends ItemsMenuEvents {}

class LoadCategories extends ItemsMenuEvents {}

class CategoryChanged extends ItemsMenuEvents {
  final String categoryId;
  CategoryChanged({@required this.categoryId});
}

class AddItem extends ItemsMenuEvents {
  final String code;
  final int itemId;
  AddItem({@required this.code, @required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class AddOnSpotDeal extends ItemsMenuEvents {
  OnSpotDeal deal;
  AddOnSpotDeal({@required this.deal});
}

class RemoveOnSpotDeal extends ItemsMenuEvents {
  OnSpotDeal deal;
  RemoveOnSpotDeal({@required this.deal});
}

class ReduceOnSpotDeal extends ItemsMenuEvents {
  OnSpotDeal deal;
  ReduceOnSpotDeal({@required this.deal});
}

class OnSpotDealQuantityChanged extends ItemsMenuEvents {
  final OnSpotDeal deal;
  final int quantity;
  OnSpotDealQuantityChanged({this.deal, this.quantity});
}

class RemoveItem extends ItemsMenuEvents {
  final String code;
  final int itemId;
  RemoveItem({@required this.code, @required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class ReduceItem extends ItemsMenuEvents {
  final String code;
  final int itemId;
  ReduceItem({@required this.code, @required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class AddComment extends ItemsMenuEvents {
  final String code;
  final int itemId;
  final String comment;
  AddComment(
      {@required this.code, @required this.itemId, @required this.comment});
  // @override
  // List<Object> get props => [item];
}

class PostOrder extends ItemsMenuEvents {}

class ResetPOSOrder extends ItemsMenuEvents {}

class LoadCustomerOrder extends ItemsMenuEvents {
  final Order customerOrder;
  LoadCustomerOrder({@required this.customerOrder});
}

class ItemQuantityChanged extends ItemsMenuEvents {
  final String code;
  final int itemId;
  final double quantity;
  ItemQuantityChanged({this.code, @required this.itemId, this.quantity});
}

class AddOpenItem extends ItemsMenuEvents {
  final Item openItem;
  AddOpenItem({this.openItem});
}
