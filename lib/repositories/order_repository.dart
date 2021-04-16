import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/shared/config.dart';

class OrderRepo {
  static OrderRepo repo = OrderRepo._internal();
  OrderRepo._internal() {
    _url = Config.getOrdersApi;
  }
  String _url;

  Future<ServerResponse> getAllOrders(
          {@required String userId, @required String type}) async =>
      ServerResponse(response: await get('$_url?userid=$userId&type=$type'));

  Future<ServerResponse> postOrder({@required Order customerOrder}) async =>
      ServerResponse(
          response: await post(_url,
              headers: {'Content-type': 'application/json'},
              body:
                  '"${jsonEncode(customerOrder.toJson).replaceAll('"', '\\"').toString()}"'));

  Future<ServerResponse> updateOrder({@required Order customerOrder}) async =>
      ServerResponse(
          response:
              await put(_url, headers: {'Content-type': 'application/json'}, body:
                  '"${jsonEncode(customerOrder.toJson).replaceAll('"', '\\"').toString()}"'));
}
