

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class VatAmountTable extends SqlCommons{

  static const String tableName = 'vat_amount'; //14

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String name = 'name';
  static const String percentage = 'percentage';
  static const String userId = 'user_id';
  static const String companyId = 'company_id';
  static const String delStatus = 'del_status';

  static const List<String> columnsName = [
    localId,
    serverId,
    name,
    percentage,
    userId,
    companyId,
    delStatus
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT
  ];

  VatAmountTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);

}