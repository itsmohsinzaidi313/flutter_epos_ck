import 'package:http/http.dart';
import 'package:pos_app/shared/config.dart';

class UsersRepo {
  static UsersRepo repo = UsersRepo._internal();
  UsersRepo._internal();

  Future<Response> users() async =>
      await get(await Config.getUsersApi);
}
