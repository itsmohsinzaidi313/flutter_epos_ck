import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class CategoryTable extends SqlCommons{

  static const String TABLE_NAME = 'categories';

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String CATEGORY_NAME = 'category_name';
  static const String DESCRIPTION = 'description';
  static const String USER_ID = 'user_id';
  static const String COMPANY_ID = 'company_id';
  static const String DEL_STATUS = 'del_status';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    CATEGORY_NAME,
    DESCRIPTION,
    USER_ID,
    COMPANY_ID,
    DEL_STATUS
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT
  ];

  CategoryTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}