import 'package:meta/meta.dart';
import 'package:http/http.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/models/customer.dart';

class CustomerRepo {
  static CustomerRepo repo = CustomerRepo._internal();

  CustomerRepo._internal();

  Future<Response> customer({@required String contact}) async =>
      await get('${await Config.getCustomerApi}?contact=$contact')
              .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                  onTimeout: () => null);

  Future<Response> postCustomer({@required Customer customer}) async =>
       await post(await Config.getCustomerApi,
                  headers: {'Content-type': 'application/json'},
                  body: '"${customer.toJson.replaceAll('"', '\\"')}"')
              .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                  onTimeout: () => null);
}
