import 'package:pos_app/models/menu_item.dart';

class DealOnSpot extends MenuItem {
  final List<MenuItem> fixedItems;
  final List<DealOnSpotItem> dealItems;
  DealOnSpot({this.dealItems, this.fixedItems});
}

class DealOnSpotItem extends MenuItem {}
