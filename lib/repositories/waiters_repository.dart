import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';

class WaiterRepo {
  static WaiterRepo repo = WaiterRepo._internal();
  WaiterRepo._internal();
  Future<Response> waiters() async => await get(Uri.parse(Config.getWaitersApi))
      .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => Lib.timeout)
      .onError(
          (dynamic error, stackTrace) => Lib.httpErrorResponseHandler(error: error));
}
