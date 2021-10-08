import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/menu_item.dart';

class Menu {
  final List<Category> listCategories;
  final List<MenuItem> listItems;
  final List<FixedDeal> listFixedDeals;
  final List<OnSpotDeals> listOnSpotDeals;
  Menu(
      {this.listCategories,
      this.listItems,
      this.listFixedDeals,
      this.listOnSpotDeals});
}
