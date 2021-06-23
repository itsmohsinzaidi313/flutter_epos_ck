import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/shared/config.dart';

class OrderRepo {
  static OrderRepo repo = OrderRepo._internal();
  OrderRepo._internal();

  /// Gets order from server
  /// To get all orders posted from this device pass [tiltId] and set [type] to [0]
  /// To get single order pass [tiltId], [orderNo] and [orderDate] and set [type] to [1]
  Future<ServerResponse> getOrders(
      {String tiltId,
      String type = '',
      String orderNo = ''}) async => ServerResponse(
      response: await get(Uri.parse(
              '${await Config.getOrdersApi}?tiltId=${tiltId ?? Config.user.tiltId}&type=$type&orderNo=$orderNo'))
          .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
              onTimeout: () => null),
    );

  Future<ServerResponse> postOrder({@required Order customerOrder}) async => ServerResponse(
        response: await post(await Config.getOrdersApi,
                headers: {'Content-type': 'application/json'},
                body:
                    '"${jsonEncode(customerOrder.toJson).replaceAll('"', '\\"').toString()}"')
            .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                onTimeout: () => null));

  Future<ServerResponse> updateOrder({@required Order customerOrder}) async => ServerResponse(
        response: await put(await Config.getOrdersApi,
            headers: {'Content-type': 'application/json'},
            body:
                '"${jsonEncode(customerOrder.toJson).replaceAll('"', '\\"').toString()}"'));
}
