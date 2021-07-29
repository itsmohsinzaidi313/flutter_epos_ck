

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ErrorDetailTable extends SqlCommons{

  static const String TABLE_NAME = 'error_detail';

  static const String ID = 'id';
  static const String ERROR_MASTER_ID = 'error_master_id';
  static const String ERROR = 'error';

  static const List<String> COLUMN_NAMES = [
    ID,
    ERROR_MASTER_ID,
    ERROR
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT
  ];

  ErrorDetailTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}