import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:http/http.dart';

class TablesRepo {
  static TablesRepo repo = TablesRepo._internal();
  TablesRepo._internal();
  Future<Response> tables() async => await get(Uri.parse(Config.getTablesApi))
      .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
          onTimeout: () => Lib.timeout)
      .onError(
          (dynamic error, stackTrace) => Lib.httpErrorResponseHandler(error: error));
}
