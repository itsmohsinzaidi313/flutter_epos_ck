

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class OrdersTable extends SqlCommons {

  static const String RESERVED = 'Reserved';
  static const String FREE = 'Free';

  static const String tableName = 'orders_table';

  static const String localId = 'local_id';
  static const String persons = 'persons';
  static const String bookingTime = 'booking_time';
  static const String saleId = 'sale_id';
  static const String saleNo = 'sale_no';
  static const String outletId = 'outlet_id';
  static const String tableId = 'table_id';
  static const String delStatus = 'del_status';

  static const List<String> columnsName = [
    localId,
    persons,
    bookingTime,
    saleId,
    saleNo,
    outletId,
    tableId,
    delStatus
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT

  ];

  OrdersTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}
