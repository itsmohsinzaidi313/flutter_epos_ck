import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/sales_detail.dart';
import 'package:pos_app/database/models/sales_master.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/server_response.dart';
import 'package:pos_app/shared/config.dart';

class OrderRepo {
  static OrderRepo repo = OrderRepo._internal();
  OrderRepo._internal();

  /// If no parameters are given list of all orders is returned.
  /// Provide [orderNo] for a specific order.
  /// And passing [orderType] only returs type specific orders
  /// [orderType] for type specific list of orders.
  /// * 1-Dine-In
  /// * 2-Take Away
  /// * 3-Delivery
  /// If both [orderNo] and [orderType] are given [orderType] is ignored
  Future<List<Order>> getOrders(
      {String orderType = '', String orderNo = ''}) async {
    List<Order> list = [];
    List<SalesMaster> masters = [];
    List<SalesDetails> details = [];
    List<Map<String, dynamic>> listMSDa = [];
    final db = await LocalDatabase.database.getDatabase();

    if (orderType != '' && orderNo == '') {
      listMSDa = (await db
              .query(SalesMasterTable.TABLE_NAME, where: '', whereArgs: [])) ??
          [];
    } else if (orderType == '' && orderNo != '') {
    } else if (orderType == '' && orderNo == '') {
    } else if (orderType != '' && orderNo != '') {}
    return list;
  }

  Future<ServerResponse> newOrder({@required Order customerOrder}) async =>
      ServerResponse(
        response: await post(await Config.getOrdersApi,
                headers: {'Content-type': 'application/json'},
                body:
                    '"${jsonEncode(customerOrder.toJson).replaceAll('"', '\\"').toString()}"')
            .timeout(Duration(seconds: Config.SERVER_TIMEOUT),
                onTimeout: () => null),
      );

  Future<ServerResponse> updateOrder({@required Order customerOrder}) async {
    log(await Config.getOrdersApi);
    log('"${jsonEncode(customerOrder.toJson).replaceAll('"', '\\"').toString()}"');
    return ServerResponse(
        response: await put(await Config.getOrdersApi,
            headers: {'Content-type': 'application/json'},
            body:
                '"${jsonEncode(customerOrder.toJson).replaceAll('"', '\\"').toString()}"'));
  }
}
