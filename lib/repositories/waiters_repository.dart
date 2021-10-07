import 'dart:developer';

import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';

class WaiterRepo {
  static WaiterRepo repo = WaiterRepo._internal();
  WaiterRepo._internal();
  Future<Response> get waiters async => await get(await Config.getWaitersApi).timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null);
}
