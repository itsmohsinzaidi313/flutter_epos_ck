import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';

class OrderRepo {
  static OrderRepo repo = OrderRepo._internal();
  OrderRepo._internal();

  Future<Response> getOrders({String? deviceId, String orderNo = '*'}) async =>
      await get(Uri.parse(
              '${Config.ordersApi}&deviceId=${deviceId ?? (await Config.deviceData)!.androidId}&orderNo=$orderNo'))
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => Lib.timeout)
          .onError((dynamic error, stackTrace) =>
              Lib.httpErrorResponseHandler(error: error));

  Future<Response> newOrder({required Order customerOrder}) async {
    log(Config.ordersApi, name: 'newOrder');
    log(jsonEncode(customerOrder.map), name: 'newOrder');
    return await post(Uri.parse(Config.ordersApi),
            headers: {'Content-type': 'application/json'},
            body: jsonEncode(customerOrder.map))
        .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout)
        .onError(
            (dynamic error, stackTrace) => Lib.httpErrorResponseHandler(error: error));
  }

  Future<Response> updateOrder({required Order customerOrder}) async {
    // log(Config.ordersApi, name: 'updateOrder');
    // log(jsonEncode(customerOrder.map), name: 'updateOrder');
    // return Lib.timeout;
    return await put(Uri.parse(Config.ordersApi),
            headers: {'Content-type': 'application/json'},
            body: jsonEncode(customerOrder.map))
        .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout)
        .onError(
            (dynamic error, stackTrace) => Lib.httpErrorResponseHandler(error: error));
  }
}
