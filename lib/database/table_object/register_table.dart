

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class RegisterTable extends SqlCommons {
  static const String tableName = 'register_data';

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String openingBalance = 'opening_balance';
  static const String closingBalance = 'closing_balance';
  static const String openingBalanceDateTime = 'opening_balance_date_time';
  static const String closingBalanceDateTime = 'closing_balance_date_time';
  static const String salePaidAmount = 'sale_paid_amount';
  static const String customerDueReceive = 'customer_due_receive';
  static const String paymentMethodsSale = 'payment_methods_sale';
  static const String registerStatus = 'register_status';
  static const String userId = 'user_id';
  static const String outletId = 'outlet_id';
  static const String companyId = 'company_id';
  static const String registerNo = 'register_no';
  static const String deviceKey = 'device_key';
  static const String isUpload = 'is_upload';

  static const List<String> columnsName = [
    localId,
    serverId,
    openingBalance,
    closingBalance,
    openingBalanceDateTime,
    closingBalanceDateTime,
    salePaidAmount,
    customerDueReceive,
    paymentMethodsSale,
    registerStatus,
    userId,
    outletId,
    companyId,
    registerNo,
    deviceKey,
    isUpload,
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,

  ];

  RegisterTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}
