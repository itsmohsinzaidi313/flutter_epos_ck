import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';

class TablesRepo {
  static TablesRepo repo = TablesRepo._internal();
  TablesRepo._internal();
  Future<Response> get tables async => await get(await Config.getTablesApi).timeout(
          Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => null);
}
