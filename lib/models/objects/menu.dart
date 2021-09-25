import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/models/objects/menu_item.dart';

class Menu {
  static const _categoriesKey = 'categories', _itemsKey = 'items';
  List<Category> categories = [];
  List<MenuItem> items = [];

  Menu();

  Menu.fromJson(dynamic data) {
    final List<dynamic> catList = data[_categoriesKey];
    final List<dynamic> itemsList = data[_itemsKey];

    for (dynamic item in catList) {
      categories.add(Category.fromJson(item));
    }

    for (dynamic item in itemsList) {
      items.add(MenuItem.fromJson(item));
    }
  }
}
