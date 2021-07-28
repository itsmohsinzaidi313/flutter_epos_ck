

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DeviceTable extends SqlCommons{

  static const String tableName = 'devices'; //15

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String outletId = 'outlet_id';
  static const String companyId = 'company_id';
  static const String deviceKey = 'device_key';
  static const String delStatus = 'del_status';
  static const String isInstalled = 'is_installed';
  static const String dateAdded = 'date_added';
  static const String dateModified = 'date_modified';

  static const List<String> columnsName = [
    localId,
    serverId,
    outletId,
    companyId,
    deviceKey,
    delStatus,
    isInstalled,
    dateAdded,
    dateModified
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT
  ];

  DeviceTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}