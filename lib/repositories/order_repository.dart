import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/sales_detail.dart';
import 'package:pos_app/database/models/sales_master.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/shared/app_library.dart';

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
                  '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.ORDER_TYPE} = ? AND ${SalesMasterTable.PAID_AMOUNT} != ${SalesMasterTable.DUE_AMOUNT}',
              whereArgs: [0, orderType])) ??
          [];
    } else if ((orderType == '' && orderNo != '') ||
        (orderType != '' && orderNo != '')) {
      listMSDa = (await db.query(SalesMasterTable.TABLE_NAME,
              where:
                  '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.SALE_NO} = ? AND ${SalesMasterTable.PAID_AMOUNT} != ${SalesMasterTable.DUE_AMOUNT}',
              whereArgs: [0, orderNo])) ??
          [];
    } else if (orderType == '' && orderNo == '') {
      listMSDa = (await db.query(SalesMasterTable.TABLE_NAME,
              where:
                  '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.PAID_AMOUNT} != ${SalesMasterTable.DUE_AMOUNT}',
              whereArgs: [0])) ??
          [];
    }

    for (var item in listMSDa) {
      listDSDa = (await db.rawQuery(
              'SELECT B.${ItemTable.SERVER_ID}, B.${ItemTable.CODE}, B.${ItemTable.CATEGORY_ID}, B.${ItemTable.NAME}, B.${ItemTable.SALE_PRICE}, A.${SalesDetailTable.QUANTITY}, B.${ItemTable.PHOTO} FROM ${SalesDetailTable.TABLE_NAME} A JOIN ${ItemTable.TABLE_NAME} B ON B.${ItemTable.SERVER_ID} = ${SalesDetailTable.FOOD_MENU_ID} WHERE A.${SalesDetailTable.SALES_MASTER_ID} = ?',
              [item[SalesMasterTable.LOCAL_ID]])) ??
          [];
      list.add(Order.fromDB(item, listDSDa));
    }
    return list;
  }

  Future<bool> newOrder({@required Order customerOrder}) async {
    try {
      final db = await LocalDatabase.database.getDatabase();
      await db
          .query(SalesMasterTable.TABLE_NAME)
          .then((value) => log(value.toString()));

      return await db.transaction<bool>((txn) async {
        try {
          if (customerOrder.orderType == '2' ||
              customerOrder.orderType == '3') {
            customerOrder.customer.id =
                (await txn.insert(CustomerTable.TABLE_NAME, {
              CustomerTable.NAME: customerOrder.customer.name,
              CustomerTable.PHONE: customerOrder.customer.contact,
              CustomerTable.ADDRESS: customerOrder.customer.address,
            }))
                    .toString();
          }
          final listOrderNo = await txn.query(SalesMasterTable.TABLE_NAME,
              columns: [
                '(IFNULL(COUNT(${SalesMasterTable.LOCAL_ID}),0) + 1) count'
              ]);
          customerOrder.orderNo =
              await Lib.codeGenerator('ORD', listOrderNo.first['count']);
          final salesMaster = SalesMaster.fromOrder(customerOrder);
          final masterId = await txn.insert(
              SalesMasterTable.TABLE_NAME, salesMaster.getMap());
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

            for (var item in details) {
              txn.insert(
                SalesDetailTable.TABLE_NAME,
                item.getMapInsert(),
                nullColumnHack: '0',
              );
            }

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

  Future<bool> updateOrder(
      {@required Order customerOrder,
      bool delete = false,
      bool uploaded = false}) async {
    try {
      final db = await LocalDatabase.database.getDatabase();
      return await db.transaction<bool>((txn) async {
        try {
          final salesMaster = SalesMaster.fromOrder(customerOrder);
          salesMaster.isDelete = delete ? 1 : 0;
          salesMaster.isUpload = uploaded ? 1 : 0;
          int rowsAffected = await txn.update(
              SalesMasterTable.TABLE_NAME, salesMaster.getMap(),
              where: '${SalesMasterTable.LOCAL_ID} = ?',
              whereArgs: [customerOrder.id]);
          if (rowsAffected > 0) {
            await txn.delete(SalesDetailTable.TABLE_NAME,
                where: '${SalesDetailTable.SALES_MASTER_ID}  = ?',
                whereArgs: [customerOrder.id]);
            final batch = txn.batch();
            List<SalesDetails> details = customerOrder.items
                .map((e) => SalesDetails.fromItem(
                    int.parse(customerOrder.id),
                    int.parse(customerOrder.userId),
                    int.parse(customerOrder.outletId),
                    e))
                .toList();
            for (var item in details) {
              batch.insert(
                SalesDetailTable.TABLE_NAME,
                item.getMapInsert(),
                nullColumnHack: '0',
              );
            }

            batch.commit();
            return true;
          }
          return false;
        } catch (e) {
          log('error', error: e);
          rethrow;
        }
      });
    } catch (e) {
      return false;
    }
  }
}
