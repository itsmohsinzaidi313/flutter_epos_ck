import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/tables/category_table.dart';
import 'package:pos_app/models/items_category.dart';

class CategoryRepo {
  static CategoryRepo repo = CategoryRepo._internal();

  CategoryRepo._internal();

  Future<List<Category>> rawCategories() async {
    final db = await LocalDatabase.database.getDatabase();
    final list = await db.query(CategoryTable.TABLE_NAME);
    final categories = list.map((e) => Category.fromMap(e)).toList();
    return categories;
  }
}
