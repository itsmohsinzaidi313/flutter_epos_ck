part of 'items_menu_bloc.dart';

abstract class ItemsMenuEvents {
  const ItemsMenuEvents();
}

class LoadItems extends ItemsMenuEvents {
  final String categoryId;
  LoadItems({required this.categoryId});
}

class ItemsMenuBuild extends ItemsMenuEvents {
  ItemsMenuBuild();
}

class LoadCategories extends ItemsMenuEvents {}

class CategoryChanged extends ItemsMenuEvents {
  final String categoryId;
  CategoryChanged({required this.categoryId});
}

class UpdateCart extends ItemsMenuEvents {
  final ItemsCart cart;
  UpdateCart({required this.cart});
}

class PostOrder extends ItemsMenuEvents {}

class ResetPOSOrder extends ItemsMenuEvents {}

class LoadCustomerOrder extends ItemsMenuEvents {
  final Order customerOrder;
  LoadCustomerOrder({required this.customerOrder});
}

class AddMenuItem extends ItemsMenuEvents {
  final Item item;
  AddMenuItem({required this.item});
}

class IncreaseItem extends ItemsMenuEvents {
  final int index;
  IncreaseItem({required this.index});
}

class DecreaseItem extends ItemsMenuEvents {
  final int index;
  DecreaseItem({required this.index});
}

class RemoveItem extends ItemsMenuEvents {
  final int index;
  RemoveItem({required this.index});
}

class AddComment extends ItemsMenuEvents {
  final int index;
  final String value;
  AddComment({
    required this.index,
    required this.value,
  });
}

class UpdateItemsMenu extends ItemsMenuEvents {}
