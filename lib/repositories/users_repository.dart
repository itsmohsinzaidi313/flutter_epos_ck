import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/shared/config.dart';

class UsersRepo {
  static UsersRepo repo = UsersRepo._internal();
  UsersRepo._internal() {
    _url = Config.getUsersApi;
  }
  String _url;

  Future<ServerResponse> get users async =>
      ServerResponse(response: await get(_url));
}
