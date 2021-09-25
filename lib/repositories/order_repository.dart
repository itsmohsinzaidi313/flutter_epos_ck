import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/shared/config.dart';

class OrderRepo {
  static OrderRepo repo = OrderRepo._internal();
  OrderRepo._internal();

  Future<Response> getOrders() async =>
      await get(Uri.parse('${await Config.ordersApi}&userId=${Config.user.id}'))
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => null);

  Future<Response> newOrder({@required Order order}) async => await post(
          await Config.ordersApi,
          headers: {'Content-type': 'application/json'},
          body: jsonEncode(order.toMap))
      .timeout(Duration(seconds: Config.SERVER_TIMEOUT), onTimeout: () => null);

  Future<Response> updateOrder({@required Order customerOrder}) async =>
      await put(await Config.ordersApi,
          headers: {'Content-type': 'application/json'},
          body: jsonEncode(customerOrder.toMap));

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
