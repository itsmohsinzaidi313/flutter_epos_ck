import 'package:http/http.dart';
import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/shared/config.dart';

class CategoryRepo {
  static CategoryRepo repo = CategoryRepo._internal();

  CategoryRepo._internal();

  Future<ServerResponse> get rawCategories async =>
      ServerResponse(response: await get(await Config.getCategoryApi).timeout(Duration(seconds: Config.SERVER_TIMEOUT), onTimeout: () => null));
}
