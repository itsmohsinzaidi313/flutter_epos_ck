

import 'package:flutter/cupertino.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class CustomerTable extends SqlCommons{

  static const String tableName = 'customers'; //7

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String address = 'address';
  static const String gstNumber = 'gst_number';
  static const String areaId = 'area_id';
  static const String userId = 'user_id';
  static const String companyId = 'company_id';
  static const String delStatus = 'del_status';
  static const String dateOfBirth = 'date_of_birth';
  static const String dateOfAnniversary = 'date_of_anniversary';
  static const String isUpload = 'is_upload';

  static const List<String> columnsName = [
    localId,
    serverId,
    name,
    phone,
    email,
    address,
    gstNumber,
    areaId,
    userId,
    companyId,
    delStatus,
    dateOfBirth,
    dateOfAnniversary,
    isUpload
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
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,

  ];

  CustomerTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}