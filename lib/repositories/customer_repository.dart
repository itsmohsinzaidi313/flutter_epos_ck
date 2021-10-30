import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/models/customer.dart';

class CustomerRepo {
  static CustomerRepo repo = CustomerRepo._internal();

  CustomerRepo._internal();

  Future<Response> customer({@required String contact}) async =>
      await get('${await Config.getCustomerApi}?contact=$contact')
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => Lib.timeout)
          .onError((error, stackTrace) =>
              Lib.httpErrorResponseHandler(error: error));

  Future<Response> postCustomer({@required Customer customer}) async =>
      await post(await Config.getCustomerApi,
              headers: {'Content-type': 'application/json'},
              body: jsonEncode(customer.map))
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => Lib.timeout)
          .onError((error, stackTrace) =>
              Lib.httpErrorResponseHandler(error: error));
}
