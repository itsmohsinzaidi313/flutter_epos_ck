

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ErrorMasterTable extends SqlCommons{

  static const String TABLE_NAME = 'error_master';

  static const String ID = 'id';
  static const String CLASS_NAME = 'class_name';
  static const String DATE_TIME = 'date_time';
  static const String TITLE = 'title';

  static const List<String> COLUMN_NAMES = [
    ID,
    CLASS_NAME,
    DATE_TIME,
    TITLE
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT
  ];

  ErrorMasterTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}