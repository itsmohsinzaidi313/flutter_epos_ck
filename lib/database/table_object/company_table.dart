

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class CompanyTable extends SqlCommons{

  static const String tableName = 'company'; //6

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String currency = 'currency';
  static const String timezone = 'timezone';
  static const String dateFormat = 'date_format';
  static const String outletId = 'outlet_id';
  static const String name = 'name';
  static const String email = 'email';
  static const String phone1 = 'phone_1';
  static const String phone2 = 'phone_2';
  static const String address = 'address';
  static const String status = 'status';
  static const String dateAdded = 'date_added';
  static const String expiryDate = 'expiry_date';
  static const String token = 'token';

  static const List<String> columnsName = [
    localId,
    serverId,
    currency,
    timezone,
    dateFormat,
    outletId,
    name,
    email,
    phone1,
    phone2,
    address,
    status,
    dateAdded,
    expiryDate,
    token
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];

  CompanyTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}