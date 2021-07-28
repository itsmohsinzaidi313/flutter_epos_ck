

import 'dart:core';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ShiftTable extends SqlCommons {
    static const String tableName = 'shift_data';
    // CREATE TABLE `tbl_shift` (
    // `shift_id` int(11) NOT NULL,
    // `voucher_no` varchar(255) DEFAULT NULL,
    // `openday` datetime DEFAULT NULL,
    // `closingday` datetime DEFAULT NULL,
    // `is_open` varchar(10) DEFAULT NULL,
    // `user_id` int(11) DEFAULT NULL,
    // `outlet_id` int(11) DEFAULT NULL,
    // `company_id` int(11) DEFAULT NULL
    // ) ENGINE=InnoDB DEFAULT CHARSET=latin1

    static const String localId = 'local_id';
    static const String shiftId = 'shift_id';
    static const String voucherNo= 'voucher_no';
    static const String openDay = 'openday';
    static const String closingDay= 'closingday';
    static const String isOpen = 'is_open';
    static const String userId= 'user_id';
    static const String outletId= 'outlet_id';
    static const String companyId= 'company_id';

    static const String serverId = 'id';


  static const List<String> columnsName = [
    localId,
    shiftId,
    voucherNo,
    openDay,
    closingDay,
    isOpen,
    userId,
    outletId,
    companyId,

    serverId,

  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER

  ];

  ShiftTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}
