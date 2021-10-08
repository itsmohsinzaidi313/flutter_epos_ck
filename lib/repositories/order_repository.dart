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

  /// Gets order from server
  /// To get all orders posted from this device pass [tiltId] and set [type] to [0]
  /// To get single order pass [tiltId], [orderNo] and [orderDate] and set [type] to [1]
  Future<Response> getOrders({String tiltId, String orderNo = '*'}) async =>
      await get(Uri.parse(
              '${await Config.ordersApi}&tiltId=${tiltId ?? Config.user.tiltId}&orderNo=$orderNo'))
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => Lib.timeout);

  Future<Response> newOrder({@required Order customerOrder}) async {
    log(await Config.ordersApi, name: 'newOrder');
    log(jsonEncode(customerOrder.toJson), name: 'newOrder');
    return Lib.timeout;
    return await post(await Config.ordersApi,
            headers: {'Content-type': 'application/json'},
            body: jsonEncode(customerOrder.toJson))
        .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout)
        .onError(
            (error, stackTrace) => Lib.httpErrorResponseHandler(error: error));
  }

  Future<Response> updateOrder({@required Order customerOrder}) async {
    log(await Config.ordersApi, name: 'updateOrder');
    log(jsonEncode(customerOrder.toJson), name: 'updateOrder');
    return Lib.timeout;

    return await put(await Config.ordersApi,
            headers: {'Content-type': 'application/json'},
            body: jsonEncode(customerOrder.toJson))
        .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
            onTimeout: () => Lib.timeout)
        .onError(
            (error, stackTrace) => Lib.httpErrorResponseHandler(error: error));
  }
}
