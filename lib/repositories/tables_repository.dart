import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/objects/server_response.dart';

class TablesRepo {
  static TablesRepo repo = TablesRepo._internal();
  TablesRepo._internal();
  Future<ServerResponse> get tables async => ServerResponse(
      response: await get(await Config.getTablesApi).timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null));
}
