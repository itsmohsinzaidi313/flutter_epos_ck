

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ItemModifierTable extends SqlCommons {

  static const String tableName = 'item_modifiers'; //9

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String modifierId = 'modifier_id';
  static const String foodMenuId = 'food_menu_id';
  static const String userId = 'user_id';
  static const String outletId = 'outlet_id';
  static const String companyId = 'company_id';
  static const String delStatus = 'name';
  static const String name = 'price';
  static const String price = 'del_status';

  static const List<String> columnsName = [
    localId,
    serverId,
    modifierId,
    foodMenuId,
    userId,
    outletId,
    companyId,
    delStatus,
    name,
    price
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.REAL
  ];

  ItemModifierTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}