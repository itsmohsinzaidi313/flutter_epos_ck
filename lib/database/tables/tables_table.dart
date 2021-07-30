

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TablesTable extends SqlCommons{

  static const String TABLE_NAME = 'tables';

  // static const String RESERVED = 'Reserved', FREE = 'Free';

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String NAME = 'name';
  static const String SIT_CAPACITY = 'sit_capacity';
  static const String POSITION = 'position';
  static const String DESCRIPTION = 'description';
  static const String USER_ID = 'user_id';
  static const String OUTLET_ID = 'outlet_id';
  static const String COMPANY_ID = 'company_id';
  static const String DEL_STATUS = 'del_status';
  static const String OCCUPIED = 'occupied';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    NAME,
    SIT_CAPACITY,
    POSITION,
    DESCRIPTION,
    USER_ID,
    OUTLET_ID,
    COMPANY_ID,
    DEL_STATUS,
    OCCUPIED
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
  ];

  TablesTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
