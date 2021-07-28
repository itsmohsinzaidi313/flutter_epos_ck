

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TablesTable extends SqlCommons{

  static const String tableName = 'tables';
  static const RESERVED = 'Reserved';
  static const FREE = 'Free';


  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String name = 'name';
  static const String sitCapacity = 'sit_capacity';
  static const String position = 'position';
  static const String description = 'description';
  static const String userId = 'user_id';
  static const String outletId = 'outlet_id';
  static const String companyId = 'company_id';
  static const String delStatus = 'del_status';

  static const List<String> columnsName = [
    localId,
    serverId,
    name,
    sitCapacity,
    position,
    description,
    userId,
    outletId,
    companyId,
    delStatus
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT
  ];

  TablesTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}
