import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/shared/config.dart';

class CategoryRepo {
  static CategoryRepo repo = CategoryRepo._internal();

  CategoryRepo._internal() {
    _url = Config.getCategoryApi;
  }
  String _url;

  Future<ServerResponse> get categories async =>
      ServerResponse(response: await get(_url));
}
