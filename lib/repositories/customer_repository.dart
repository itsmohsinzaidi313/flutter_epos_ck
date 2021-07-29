import 'package:meta/meta.dart';
import 'package:http/http.dart';
import 'package:pos_app/objects/server_response.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/objects/customer.dart';

class CustomerRepo {
  static CustomerRepo repo = CustomerRepo._internal();

  CustomerRepo._internal();

  Future<ServerResponse> customer({@required String contact}) async =>
      ServerResponse(
          response: await get('${await Config.getCustomerApi}?contact=$contact')
              .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                  onTimeout: () => null));

  Future<ServerResponse> postCustomer({@required Customer customer}) async =>
      ServerResponse(
          response: await post(await Config.getCustomerApi,
                  headers: {'Content-type': 'application/json'},
                  body: '"${customer.toJson.replaceAll('"', '\\"')}"')
              .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                  onTimeout: () => null));
}
