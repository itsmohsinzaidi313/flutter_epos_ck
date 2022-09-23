import 'package:http/http.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class UsersRepo {
  static UsersRepo repo = UsersRepo._internal();
  UsersRepo._internal();

  Future<Response> users() async =>
      await get(Uri.parse(Config.getUsersApi)).timeout(Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => Lib.timeout)
      .onError(
          (dynamic error, stackTrace) => Lib.httpErrorResponseHandler(error: error));
}
