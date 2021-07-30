import 'package:pos_app/models/items_category.dart';

class CategoryRepo {
  static CategoryRepo repo = CategoryRepo._internal();

  CategoryRepo._internal();

  Future<List<Category>> rawCategories() async {
    return [];
  }
}
