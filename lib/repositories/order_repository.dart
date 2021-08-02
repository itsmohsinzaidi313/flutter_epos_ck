import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/sales_detail.dart';
import 'package:pos_app/database/models/sales_master.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_order.dart';

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
    List<Map<String, dynamic>> listMSDa = [];
    List<Map<String, dynamic>> listDSDa = [];
    final db = await LocalDatabase.database.getDatabase();

    if (orderType != '' && orderNo == '') {
      listMSDa = (await db.query(SalesMasterTable.TABLE_NAME,
              where:
                  '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.ORDER_TYPE} = ?',
              whereArgs: [0, orderType])) ??
          [];

      return list;
    } else if ((orderType == '' && orderNo != '') ||
        (orderType != '' && orderNo != '')) {
      listMSDa = (await db.query(SalesMasterTable.TABLE_NAME,
              where:
                  '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.SALE_NO} = ?',
              whereArgs: [0, orderNo])) ??
          [];
    } else if (orderType == '' && orderNo == '') {
      listMSDa = (await db.query(SalesMasterTable.TABLE_NAME,
              where: '${SalesMasterTable.IS_DELETED} = ?', whereArgs: [0])) ??
          [];
    }

    for (var item in listMSDa) {
      listDSDa = (await db.query(SalesDetailTable.TABLE_NAME,
              where: '${SalesMasterTable.LOCAL_ID} = ?',
              whereArgs: [item[SalesMasterTable.LOCAL_ID]])) ??
          [];
      list.add(Order.fromDB(item, listDSDa));
    }
    return list;
  }

  Future<bool> newOrder({@required Order customerOrder}) async {
    try {
      final db = await LocalDatabase.database.getDatabase();
      return await db.transaction<bool>((txn) async {
        try {
          final salesMaster = SalesMaster.fromOrder(customerOrder);
          final masterId = await txn.insert(
              SalesMasterTable.TABLE_NAME, salesMaster.getMapForNewOrder());

          List<SalesDetails> details = customerOrder.items
              .map((e) => SalesDetails.fromItem(
                  masterId,
                  int.parse(customerOrder.userId),
                  int.parse(customerOrder.outletId),
                  e))
              .toList();

          if (masterId > 0) {
            await txn.insert(OrdersTable.TABLE_NAME, {
              OrdersTable.PERSONS: customerOrder.covers,
              OrdersTable.BOOKING_TIME: customerOrder.date,
              OrdersTable.SALE_ID: masterId,
              OrdersTable.SALE_NO: customerOrder.orderNo,
              OrdersTable.OUTLET_ID: customerOrder.outletId,
              OrdersTable.TABLE_ID: customerOrder.tableId,
              OrdersTable.DEL_STATUS: 'Live'
            });
            final batch = txn.batch();

            for (var item in details) {
              batch.insert(
                SalesDetailTable.TABLE_NAME,
                item.getMapInsert(),
                nullColumnHack: '0',
              );
            }

            batch.commit();
            return true;
          } else {
            throw Exception('Insertion failed');
          }
        } catch (e) {
          log('error', error: e);
          rethrow;
        }
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrder({@required Order customerOrder}) async => true;

  Future<Order> objectify(
      SalesMaster master, List<SalesDetails> details) async {}
}
