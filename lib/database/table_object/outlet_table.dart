

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class OutletTable extends SqlCommons{

  static const String tableName = 'outlet'; //11

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String outletName = 'outlet_name';
  static const String outletCode = 'outlet_code';
  static const String address = 'address';
  static const String phone = 'phone';
  static const String invoicePrint = 'invoice_print';
  static const String startingDate = 'starting_date';
  static const String invoiceFooter = 'invoice_footer';
  static const String collectTax = 'collect_tax';
  static const String preOrPostOrder = 'pre_or_post_payment';
  static const String userId = 'user_id';
  static const String companyId = 'company_id';
  static const String delStatus = 'del_status';

  static const List<String> columnsName = [
    localId,
    serverId,
    outletName,
    outletCode,
    address,
    phone,
    invoicePrint,
    startingDate,
    invoiceFooter,
    collectTax,
    preOrPostOrder,
    userId,
    companyId,
    delStatus
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
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT


  ];

  OutletTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}