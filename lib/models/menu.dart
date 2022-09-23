import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/item.dart';

class POSMenu {
  final List<Category> listCategories;
  final List<Item> listItems;
  const POSMenu({
    this.listCategories = const [],
    this.listItems = const [],
  });
  POSMenu.modify(POSMenu menu, {List<Category>? categories, List<Item>? items})
      : this.listCategories = categories ?? [],
        this.listItems = items ?? [];
}
