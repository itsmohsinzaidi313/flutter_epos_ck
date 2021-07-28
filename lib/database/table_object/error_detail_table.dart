

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ErrorDetailTable extends SqlCommons{

  static const String tableName = 'error_detail';

  static const String id = 'id';
  static const String errorMasterId = 'error_master_id';
  static const String error = 'error';

  static const List<String> columnsName = [
    id,
    errorMasterId,
    error
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT
  ];

  ErrorDetailTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}