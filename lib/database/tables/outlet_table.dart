

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class OutletTable extends SqlCommons{

  static const String TABLE_NAME = 'outlet'; //11

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String OUTLET_NAME = 'outlet_name';
  static const String OUTLET_CODE = 'outlet_code';
  static const String ADDRESS = 'address';
  static const String PHONE = 'phone';
  static const String INVOICE_PRINT = 'invoice_print';
  static const String STARTING_DATE = 'starting_date';
  static const String INVOICE_FOOTER = 'invoice_footer';
  static const String COLLECT_TAX = 'collect_tax';
  static const String PRE_OR_POST_ORDER = 'pre_or_post_payment';
  static const String USER_ID = 'user_id';
  static const String COMPANY_ID = 'company_id';
  static const String DEL_STATUS = 'del_status';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    OUTLET_NAME,
    OUTLET_CODE,
    ADDRESS,
    PHONE,
    INVOICE_PRINT,
    STARTING_DATE,
    INVOICE_FOOTER,
    COLLECT_TAX,
    PRE_OR_POST_ORDER,
    USER_ID,
    COMPANY_ID,
    DEL_STATUS
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT


  ];

  OutletTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}