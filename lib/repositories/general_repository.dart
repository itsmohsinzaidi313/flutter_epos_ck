import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:pos_app/models/server_response.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class GeneralRepo {
  static GeneralRepo repo = GeneralRepo._internal();
  GeneralRepo._internal();
  Future<ServerResponse> getInstallationData() async {
    log((await Config.installApi));
    return ServerResponse(
        response: await get(await Config.installApi).timeout(
            Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout));
  }
}
