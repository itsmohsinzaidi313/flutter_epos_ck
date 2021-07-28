

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class UserTable extends SqlCommons{

  static const String tableName = 'users';

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String fullName = 'full_name';
  static const String phone = 'phone';
  static const String emailAddress = 'email_address';
  static const String password = 'password';
  static const String designation = 'designation';
  static const String willLogin = 'will_login';
  static const String role = 'role';
  static const String outletId = 'outlet_id';
  static const String companyId = 'company_id';
  static const String accountCreationDate = 'account_creation_date';
  static const String language = 'language';
  static const String lastLogin = 'last_login';
  static const String activeStatus = 'active_status';
  static const String delStatus = 'del_status';

  static const List<String> columnsName = [
    localId,
    serverId,
    fullName,
    phone,
    emailAddress,
    password,
    designation,
    willLogin,
    role,
    outletId,
    companyId,
    accountCreationDate,
    language,
    lastLogin,
    activeStatus,
    delStatus
  ];

  static const List<String> columnsType = [
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
    SqlCommons.INTEGER
  ];

  UserTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}