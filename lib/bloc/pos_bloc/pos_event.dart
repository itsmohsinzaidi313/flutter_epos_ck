part of 'pos_bloc.dart';

abstract class POSEvents {
  const POSEvents();

  // @override
  // List<Object> get props => [];
}

class LoadItems extends POSEvents {
  final String categoryId;
  LoadItems({@required this.categoryId});
  // @override
  // List<Object> get props => [categoryId];
}

class POSBuild extends POSEvents {}

class LoadCategories extends POSEvents {}

class CategoryChanged extends POSEvents {
  final String categoryId;
  CategoryChanged({@required this.categoryId});
}

class AddItem extends POSEvents {
  final String code;
  final int itemId;
  AddItem({@required this.code, @required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class AddOnSpotDeal extends POSEvents {
  OnSpotDeal deal;
  AddOnSpotDeal({@required this.deal});
}

class RemoveOnSpotDeal extends POSEvents {
  OnSpotDeal deal;
  RemoveOnSpotDeal({@required this.deal});
}

class ReduceOnSpotDeal extends POSEvents {
  OnSpotDeal deal;
  ReduceOnSpotDeal({@required this.deal});
}

class OnSpotDealQuantityChanged extends POSEvents {
  final OnSpotDeal deal;
  final int quantity;
  OnSpotDealQuantityChanged({this.deal, this.quantity});
}

class RemoveItem extends POSEvents {
  final String code;
  final int itemId;
  RemoveItem({@required this.code, @required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class ReduceItem extends POSEvents {
  final String code;
  final int itemId;
  ReduceItem({@required this.code, @required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class AddComment extends POSEvents {
  final String code;
  final int itemId;
  final String comment;
  AddComment(
      {@required this.code, @required this.itemId, @required this.comment});
  // @override
  // List<Object> get props => [item];
}

class PostOrder extends POSEvents {}

class ResetPOSOrder extends POSEvents {}

class LoadPOSOrder extends POSEvents {
  final Order customerOrder;
  LoadPOSOrder({@required this.customerOrder});
}

class ItemQuantityChanged extends POSEvents {
  final String code;
  final int itemId;
  final double quantity;
  ItemQuantityChanged({this.code, @required this.itemId, this.quantity});
}

class AddOpenItem extends POSEvents {
  final Item openItem;
  AddOpenItem({this.openItem});
}
