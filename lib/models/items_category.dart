import 'package:pos_app/database/tables/database_tables.dart';

class Category {
  static const IdKey = 'Id';
  static const NameKey = 'Name';
  final String id, name;
  bool selected;
  Category.fromMap(Map<String, dynamic> map)
      : id = map[CategoryTable.SERVER_ID],
        name = map[CategoryTable.CATEGORY_NAME],
        selected = false;
}
