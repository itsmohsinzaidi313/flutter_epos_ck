import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/customer.dart';
import 'package:pos_app/models/customer.dart' as cust;
import 'package:pos_app/database/models/sales_detail.dart';
import 'package:pos_app/database/models/sales_master.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/repositories/customer_repository.dart';
import 'package:pos_app/repositories/printing_repository.dart';
import 'package:pos_app/services/printing_service/printing_service.dart';
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
    List<Map<String, dynamic>> listMaster = [];
    List<Map<String, dynamic>> listDetail = [];
    final db = await LocalDatabase.database.getDatabase();

    if (orderType != '' && orderNo == '') {
      listMaster = (await db.query(SalesMasterTable.TABLE_NAME,
              where:
                  '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.ORDER_TYPE} = ? AND ${SalesMasterTable.PAID_AMOUNT} != ${SalesMasterTable.DUE_AMOUNT}',
              whereArgs: [0, orderType])) ??
          [];
    } else if ((orderType == '' && orderNo != '') ||
        (orderType != '' && orderNo != '')) {
      listMaster = (await db.query(SalesMasterTable.TABLE_NAME,
              where:
                  '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.SALE_NO} = ? AND ${SalesMasterTable.PAID_AMOUNT} != ${SalesMasterTable.DUE_AMOUNT}',
              whereArgs: [0, orderNo])) ??
          [];
    } else if (orderType == '' && orderNo == '') {
      listMaster = (await db.query(SalesMasterTable.TABLE_NAME,
              where:
                  '${SalesMasterTable.IS_DELETED} = ? AND ${SalesMasterTable.PAID_AMOUNT} != ${SalesMasterTable.DUE_AMOUNT}',
              whereArgs: [0])) ??
          [];
    }

    for (var masterItem in listMaster) {
      listDetail = (await db.rawQuery(
              'SELECT B.${ItemTable.SERVER_ID}, B.${ItemTable.CODE}, B.${ItemTable.CATEGORY_ID}, B.${ItemTable.NAME}, B.${ItemTable.SALE_PRICE}, A.${SalesDetailTable.QUANTITY}, B.${ItemTable.PHOTO} FROM ${SalesDetailTable.TABLE_NAME} A JOIN ${ItemTable.TABLE_NAME} B ON B.${ItemTable.SERVER_ID} = ${SalesDetailTable.FOOD_MENU_ID} WHERE A.${SalesDetailTable.SALES_MASTER_ID} = ?',
              [masterItem[SalesMasterTable.LOCAL_ID]])) ??
          [];
      final order = Order.fromDB(masterItem, listDetail);
      final x = await db.query(CustomerTable.TABLE_NAME,
          where: '${CustomerTable.REMOTE_ID} = ?',
          whereArgs: [masterItem[SalesMasterTable.CUSTOMER_ID]]);
      order.customer = cust.Customer.fromMap(x.first);
      list.add(order);
    }
    return list;
  }

  Future<bool> newOrder({@required Order customerOrder}) async {
    try {
      final db = await LocalDatabase.database.getDatabase();
      final listOrderNo = await db.query(SalesMasterTable.TABLE_NAME, columns: [
        '(IFNULL(COUNT(${SalesMasterTable.LOCAL_ID}),0) + 1) count'
      ]);
      customerOrder.orderNo =
          await Lib.codeGenerator('ORD', listOrderNo.first['count']);
      customerOrder.date = Lib.getCurrentDateTimeWithFormat().substring(0, 10);
      customerOrder.time = Lib.getCurrentDateTimeWithFormat().substring(11);
      int id = await CustomerRepo.repo
          .insertAndUploadIfExists(customer: customerOrder.customer);
      bool status = await db.transaction<bool>((txn) async {
        try {
          if (customerOrder.orderType == '1') {
            customerOrder.customer.id = '1';
          } else if (customerOrder.orderType == '2' ||
              customerOrder.orderType == '3') {
            customerOrder.customer.id = id.toString();
          }

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
          log('error', error: e, name: 'Order Repository');
          rethrow;
        }
      });
      if (status) {
        await PrintingRepo.repo
            .savePrint(customerOrder: customerOrder, printType: PrintType.kot);
      }
      return status;
    } catch (e) {
      log('Error', error: e, name: 'Order Repository');
      return false;
    }
  }

  Future<bool> updateOrder(
      {@required Order customerOrder,
      bool delete = false,
      bool uploaded = false,
      bool paid = false}) async {
    try {
      final db = await LocalDatabase.database.getDatabase();
      return await db.transaction<bool>((txn) async {
        try {
          final salesMaster = SalesMaster.fromOrder(customerOrder);

          salesMaster.isDelete = delete ? 1 : 0;
          salesMaster.isUpload = uploaded ? 1 : 0;
          salesMaster.orderStatus = paid ? 3 : 1;

          int rowsAffected = await txn.update(
              SalesMasterTable.TABLE_NAME, salesMaster.getMapForDBUpdate(),
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
