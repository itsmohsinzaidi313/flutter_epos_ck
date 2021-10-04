import 'package:http/http.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class UsersRepo {
  static UsersRepo repo = UsersRepo._internal();
  UsersRepo._internal();

  Future<Response> users() async {
    try {
      return await get(await Config.getUsersApi).timeout(
        Duration(seconds: Config.SERVER_TIMEOUT),
        onTimeout: () => Lib.timeOutResponse,
      );
    } catch (e) {
      return Lib.httpErrorResponseHandler(error: e, caller: 'UsersRepo');
    }
  }
}
