import 'package:pos_app/models/item.dart';

class Category  {
  static const IdKey = 'Id';
  static const NameKey = 'Name';
  final String id, name;
  List<Item> items = [];
  double choiceLimit = 0;
  bool selected;
  Category.fromJson(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[NameKey],
        selected = false;
}
