import 'dart:developer';

import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/printing_detail.dart';
import 'package:pos_app/database/models/printing_master.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/database/tables/order_printing_detail_table.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/order_print.dart';
import 'package:pos_app/repositories/tables_repository.dart';
import 'package:pos_app/repositories/waiters_repository.dart';
import 'package:pos_app/services/printing_service/printing_service.dart';

class PrintingRepo {
  static PrintingRepo repo = PrintingRepo._internal();
  PrintingRepo._internal();

  Future<void> savePrint({Order customerOrder, PrintType printType}) async {
    final db = await LocalDatabase.database.getDatabase();
    final waiter = await WaiterRepo.repo
        .getWaiters(waiterId: int.parse(customerOrder.waiterId));
    final table =
        await TablesRepo.repo.tables(tableId: int.parse(customerOrder.tableId));
    await db.transaction((txn) async {
      try {
        final printMaster = PrintingMaster.fromOrder(
            order: customerOrder,
            printType: printType.toString().split('.').last,
            waiter: waiter.first.name,
            table: table.first.tableName);

        final masterId = await txn.insert(
            PrintingMasterTable.TABLE_NAME, printMaster.toMap());

        for (var item in customerOrder.items) {
          final detail =
              PrintingDetail.fromItem(masterId: masterId, item: item);
          await txn.insert(PrintingDetailTable.TABLE_NAME, detail.getMap());
        }
        return true;
      } catch (e) {
        log('Error', error: e, name: 'Printing Repository');
        rethrow;
      }
    });
  }

  Future<List<OrderPrint>> getPrints() async {
    final db = await LocalDatabase.database.getDatabase();
    final masterList = await db.query(PrintingMasterTable.TABLE_NAME);
    final List<OrderPrint> prints = [];
    for (var master in masterList) {
      final list = await db.query(PrintingDetailTable.TABLE_NAME,
          where: '${PrintingDetailTable.MASTER_ID} = ?',
          whereArgs: [master[PrintingMasterTable.ID]]);

      final detailList =
          list.map((e) => PrintingDetail.fromMap(map: e)).toList();
      prints.add(OrderPrint(
          master: PrintingMaster.fromMap(map: master), details: detailList));
    }
    return prints;
  }

  Future<void> deletePrint({int id}) async {
    final db = await LocalDatabase.database.getDatabase();
    await db.delete(PrintingMasterTable.TABLE_NAME,
        where: '${PrintingMasterTable.ID} = ?', whereArgs: [id]);
    await db.delete(PrintingDetailTable.TABLE_NAME,
        where: '${PrintingDetailTable.MASTER_ID} = ?', whereArgs: [id]);
  }
}
