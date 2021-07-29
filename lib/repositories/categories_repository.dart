import 'package:http/http.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/server_response.dart';
import 'package:pos_app/shared/config.dart';

class CategoryRepo {
  static CategoryRepo repo = CategoryRepo._internal();

  CategoryRepo._internal();

  Future<List<Category>> rawCategories() async => [];
}
