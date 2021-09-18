import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class PrintingDetailTable extends SqlCommons {
  static const String TABLE_NAME = 'printing_detail';

  static const String ID = 'id',
      MASTER_ID = 'master_id',
      ITEM_NAME = 'item_name',
      ITEM_QTY = 'quantity',
      UNIT_PRICE = 'unit_price',
      TAX = 'tax',
      DEPARTMENT = 'department',
      PRINTER_IPs = 'printer_ips';

  static const List<String> COLUMN_NAMES = [
    ID,
    MASTER_ID,
    ITEM_NAME,
    ITEM_QTY,
    UNIT_PRICE,
    TAX,
    DEPARTMENT,
    PRINTER_IPs
  ];
  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];

  PrintingDetailTable(Database database, VerboseBloc bloc)
      : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
