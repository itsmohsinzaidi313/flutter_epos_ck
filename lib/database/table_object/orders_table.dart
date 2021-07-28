

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class OrdersTable extends SqlCommons {

  static const String RESERVED = 'Reserved';
  static const String FREE = 'Free';

  static const String TABLE_NAME = 'orders_table';

  static const String LOCAL_ID = 'local_id';
  static const String PERSONS = 'persons';
  static const String BOOKING_TIME = 'booking_time';
  static const String SALE_ID = 'sale_id';
  static const String SALE_NO = 'sale_no';
  static const String OUTLET_ID = 'outlet_id';
  static const String TABLE_ID = 'table_id';
  static const String DEL_STATUS = 'del_status';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    PERSONS,
    BOOKING_TIME,
    SALE_ID,
    SALE_NO,
    OUTLET_ID,
    TABLE_ID,
    DEL_STATUS
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT

  ];

  OrdersTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
