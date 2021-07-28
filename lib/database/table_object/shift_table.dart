import 'dart:core';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ShiftTable extends SqlCommons {
  static const String TABLE_NAME = 'shift_data';

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String SHIFT_ID = 'shift_id';
  static const String VOUCHER_NO = 'voucher_no';
  static const String OPEN_DAY = 'openday';
  static const String CLOSING_DAY = 'closingday';
  static const String IS_OPEN = 'is_open';
  static const String USER_ID = 'user_id';
  static const String OUTLET_ID = 'outlet_id';
  static const String COMPANY_ID = 'company_id';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SHIFT_ID,
    VOUCHER_NO,
    OPEN_DAY,
    CLOSING_DAY,
    IS_OPEN,
    USER_ID,
    OUTLET_ID,
    COMPANY_ID,
    SERVER_ID,
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER
  ];

  ShiftTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
