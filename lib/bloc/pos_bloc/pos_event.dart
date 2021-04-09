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
class Build extends POSEvents {}

class LoadCategories extends POSEvents {}

class AddItem extends POSEvents {
  final int itemId;
  AddItem({@required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class RemoveItem extends POSEvents {
  final int itemId;
  RemoveItem({@required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class ReduceItem extends POSEvents {
  final int itemId;
  ReduceItem({@required this.itemId});
  // @override
  // List<Object> get props => [item];
}

class AddComment extends POSEvents {
  final int itemId;
  final String comment;
  AddComment({@required this.itemId, @required this.comment});
  // @override
  // List<Object> get props => [item];
}

class PostOrder extends POSEvents {
  
}