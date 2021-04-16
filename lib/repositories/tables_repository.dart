import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';

class TablesRepo {
  static TablesRepo repo = TablesRepo._internal();
  String _url;
  TablesRepo._internal() {
    _url = Config.getTablesApi;
  }
  Future<ServerResponse> get tables async => ServerResponse(
      response: await get('$_url').timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null));
}
