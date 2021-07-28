

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ErrorMasterTable extends SqlCommons{

  static const String tableName = 'error_master';

  static const String id = 'id';
  static const String className = 'class_name';
  static const String dateTime = 'date_time';
  static const String title = 'title';

  static const List<String> columnsName = [
    id,
    className,
    dateTime,
    title
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT
  ];

  ErrorMasterTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}