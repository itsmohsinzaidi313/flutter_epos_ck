import 'package:flutter/foundation.dart';
import 'package:pos_app/models/menu_item.dart';

class FixedDeal extends MenuItem {
  final List<MenuItem> items;
  FixedDeal({@required this.items});
}
