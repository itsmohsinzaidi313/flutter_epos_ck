import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DeviceTable extends SqlCommons {
  static const String TABLE_NAME = 'devices'; //15

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String OUTLET_ID = 'outlet_id';
  static const String COMPANY_ID = 'company_id';
  static const String DEVICE_KEY = 'device_key';
  static const String DEL_STATUS = 'del_status';
  static const String IS_INSTALLED = 'is_installed';
  static const String DATE_ADDED = 'date_added';
  static const String DATE_MODIFIED = 'date_modified';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    OUTLET_ID,
    COMPANY_ID,
    DEVICE_KEY,
    DEL_STATUS,
    IS_INSTALLED,
    DATE_ADDED,
    DATE_MODIFIED
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT
  ];

  DeviceTable(Database database, VerboseBloc bloc)
      : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
