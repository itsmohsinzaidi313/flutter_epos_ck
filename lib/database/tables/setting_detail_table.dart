

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SettingDetailTable extends SqlCommons{

  static const String TABLE_NAME = 'setting_detail';

  // static const String settingMasterId = 'setting_master_id';
  static const String LOCAL_ID = 'id';
  static const String USER_ID = 'user_id';
  static const String SHIFT_ID = 'shift_id';
  static const String CONNECTION_STATUS = 'connection_status';
  static const String LOGIN_STATUS = 'login_status';
  static const String REGISTER_STATUS = 'register_status';

  static const List<String> COLUMN_NAMES = [
    // settingMasterId,
    LOCAL_ID,
    USER_ID,
    SHIFT_ID,
    CONNECTION_STATUS,
    LOGIN_STATUS,
    REGISTER_STATUS
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER
  ];

  SettingDetailTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}