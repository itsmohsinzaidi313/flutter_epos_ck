import 'package:http/http.dart';
import 'package:pos_app/objects/server_response.dart';
import 'package:pos_app/shared/config.dart';

class UsersRepo {
  static UsersRepo repo = UsersRepo._internal();
  UsersRepo._internal();

  Future<ServerResponse> users() async =>
      ServerResponse(response: await get(await Config.getUsersApi));
}
