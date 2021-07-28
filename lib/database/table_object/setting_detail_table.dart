

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SettingDetailTable extends SqlCommons{

  static const String tableName = 'setting_detail';

  // static const String settingMasterId = 'setting_master_id';
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String shiftId = 'shift_id';
  static const String connectionStatus = 'connection_status';
  static const String loginStatus = 'login_status';
  static const String registerStatus = 'register_status';

  static const List<String> columnsName = [
    // settingMasterId,
    id,
    userId,
    shiftId,
    connectionStatus,
    loginStatus,
    registerStatus
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER
  ];

  SettingDetailTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}