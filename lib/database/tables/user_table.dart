

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class UserTable extends SqlCommons{

  static const String TABLE_NAME = 'users';

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String FULL_NAME = 'full_name';
  static const String PHONE = 'phone';
  static const String EMAIL = 'email_address';
  static const String PASSWORD = 'password';
  static const String DESIGNATION = 'designation';
  static const String WILL_LOGIN = 'will_login';
  static const String ROLE = 'role';
  static const String OUTLET_ID = 'outlet_id';
  static const String COMPANY_ID = 'company_id';
  static const String ACCOUNT_CREATED_DATE = 'account_creation_date';
  static const String LANGUAGE = 'language';
  static const String LAST_LOGIN = 'last_login';
  static const String ACTIVE_STATUS = 'active_status';
  static const String DEL_STATUS = 'del_status';
  static const String LOGIN_STATUS = 'login_status';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    FULL_NAME,
    PHONE,
    EMAIL,
    PASSWORD,
    DESIGNATION,
    WILL_LOGIN,
    ROLE,
    OUTLET_ID,
    COMPANY_ID,
    ACCOUNT_CREATED_DATE,
    LANGUAGE,
    LAST_LOGIN,
    ACTIVE_STATUS,
    DEL_STATUS,
    LOGIN_STATUS
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
  ];

  UserTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}