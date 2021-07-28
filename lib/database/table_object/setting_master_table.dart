

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SettingMasterTable extends SqlCommons{

  static const String TABLE_NAME = 'setting_master';

  static const String LOCAL_ID = 'id';
  static const String TITLE = 'title';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    TITLE
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.TEXT
  ];

  SettingMasterTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}