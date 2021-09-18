import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/menu_item.dart';

class PrintingDetail {
  final int id, masterId;
  final String itemName, department;
  final double quantity, unitPrice, tax;

  PrintingDetail(
      {this.id,
      this.masterId,
      this.itemName,
      this.department,
      this.quantity,
      this.unitPrice,
      this.tax});

  PrintingDetail.fromItem({this.id = 0, this.masterId = 0, MenuItem item})
      : itemName = item.name,
        quantity = item.quantity,
        unitPrice = double.parse(item.price ?? '0.0'),
        tax = double.parse(item.taxAmount),
        department = '';

  PrintingDetail.fromMap({Map<String, dynamic> map})
      : id = map[PrintingDetailTable.ID],
        masterId = map[PrintingDetailTable.MASTER_ID],
        itemName = map[PrintingDetailTable.ITEM_NAME],
        quantity = double.parse(map[PrintingDetailTable.ITEM_QTY].toString()),
        unitPrice = map[PrintingDetailTable.UNIT_PRICE],
        tax = map[PrintingDetailTable.TAX],
        department = map[PrintingDetailTable.DEPARTMENT];

  Map<String, dynamic> getMap() => {
        PrintingDetailTable.MASTER_ID: masterId,
        PrintingDetailTable.ITEM_NAME: itemName,
        PrintingDetailTable.ITEM_QTY: quantity,
        PrintingDetailTable.UNIT_PRICE: unitPrice,
        PrintingDetailTable.TAX: tax,
        PrintingDetailTable.DEPARTMENT: department,
      };
}
