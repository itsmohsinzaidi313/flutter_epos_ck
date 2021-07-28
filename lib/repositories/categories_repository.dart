import 'package:pos_app/models/objects/category.dart';

class CategoryRepo {
  static CategoryRepo repo = CategoryRepo._internal();

  CategoryRepo._internal();

  Future<List<Category>> get getCategories async => [];
}
