import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class PrintingMasterTable extends SqlCommons {
  static const String TABLE_NAME = 'printing_master';

  static const String ID = 'id',
      ORDER_NO = 'order_no',
      DATE_TIME = 'date_time',
      ORDER_TYPE = 'order_type',
      PRINT_TYPE = 'print_type',
      AMOUNT = 'amount',
      DISCOUNT = 'discount',
      TABLE = 'table_name',
      COVERS = 'covers',
      WAITER_NAME = 'waiter_name',
      CUSTOMER_NAME = 'customer_name',
      CUSTOMER_CONTACT = 'customer_contact',
      CUSTOMER_ADDRESS = 'customer_address',
      PRINTER_IPs = 'printer_ips';

  static const List<String> COLUMN_NAMES = [
    ID,
    ORDER_NO,
    DATE_TIME,
    ORDER_TYPE,
    PRINT_TYPE,
    AMOUNT,
    DISCOUNT,
    COVERS,
    TABLE,
    WAITER_NAME,
    CUSTOMER_NAME,
    CUSTOMER_CONTACT,
    CUSTOMER_ADDRESS,
    PRINTER_IPs
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];

  PrintingMasterTable(Database database, VerboseBloc bloc)
      : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
