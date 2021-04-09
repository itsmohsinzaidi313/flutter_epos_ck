import 'package:meta/meta.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/models/objects/customer.dart';

class CustomerRepo {
  static CustomerRepo repo = CustomerRepo._internal();

  CustomerRepo._internal() {
    _url = Config.getCustomerApi;
  }
  String _url;

  Future<ServerResponse> customer({@required String contact}) async =>
      ServerResponse(response: await get('$_url?contact=$contact'));

  Future<ServerResponse> postCustomer({@required Customer customer}) async =>
      ServerResponse(
          response: await post(_url,
              headers: {'Content-type': 'application/json'},
              body: '"${customer.toJson.replaceAll('"', '\\"')}"'));
}
