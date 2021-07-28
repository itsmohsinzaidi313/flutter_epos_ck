

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SettingMasterTable extends SqlCommons{

  static const String tableName = 'setting_master';

  static const String id = 'id';
  static const String title = 'title';

  static const List<String> columnsName = [
    id,
    title
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.TEXT
  ];

  SettingMasterTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}