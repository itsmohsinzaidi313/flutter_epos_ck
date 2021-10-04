import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class OrderRepo {
  static OrderRepo repo = OrderRepo._internal();
  OrderRepo._internal();

  Future<Response> getOrders() async {
    try {
      return await get(
              Uri.parse('${await Config.ordersApi}&userId=${Config.user.id}'))
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => Lib.timeOutResponse);
    } catch (e) {
      log('Error', error: e, name: 'LoginRepo');
      return Lib.httpErrorResponseHandler(error: e, caller: 'OrderRepo');
    }
  }

  Future<Response> newOrder({@required Order order}) async {
    try {
      return await post(await Config.ordersApi,
              headers: {'Content-type': 'application/json'},
              body: jsonEncode(order.toMap))
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => Lib.timeOutResponse);
    } catch (e) {
      log('Error', error: e, name: 'LoginRepo');
      return Lib.httpErrorResponseHandler(error: e, caller: 'OrderRepo');
    }
  }

  Future<Response> updateOrder({@required Order customerOrder}) async {
    try {
      return await put(await Config.ordersApi,
              headers: {'Content-type': 'application/json'},
              body: jsonEncode(customerOrder.toMap))
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => Lib.timeOutResponse);
    } catch (e) {
      log('Error', error: e, name: 'LoginRepo');
      return Lib.httpErrorResponseHandler(error: e, caller: 'OrderRepo');
    }
  }

  // Future<Response> newOrder({@required Order order}) async {
  //   log(await Config.ordersApi);
  //   log(jsonEncode(order.toMap), name: 'newOrder');
  //   return null;
  // }

  // Future<Response> updateOrder({@required Order customerOrder}) async {
  //   log(await Config.ordersApi);
  //   log(jsonEncode(customerOrder.toMap));
  //   return null;
  // }
}
