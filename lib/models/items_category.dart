import 'package:pos_app/database/tables/database_tables.dart';

class Category {
  final String id, name;
  bool selected;
  Category.fromMap(Map<String, dynamic> map)
      : id = map[CategoryTable.LOCAL_ID].toString(),
        name = map[CategoryTable.CATEGORY_NAME],
        selected = false;
}
