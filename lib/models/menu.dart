import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/item.dart';

class POSMenu {
  final List<Category> listCategories;
  final List<Item> listItems;
  POSMenu({
    this.listCategories,
    this.listItems,
  });
}
