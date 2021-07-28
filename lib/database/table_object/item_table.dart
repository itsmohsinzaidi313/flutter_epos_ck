

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ItemTable extends SqlCommons{

  static const String tableName = 'item_menus';

  static const String localId = 'local_id';
  static const String serverId = 'id';
  static const String code = 'code';
  static const String name = 'name';
  static const String salePrice = 'sale_price';
  static const String photo = 'photo';
  static const String categoryName = 'category_name';
  static const String percentage = 'percentage';
  static const String quantity = 'quantity';

  static const List<String> columnsName = [
    localId,
    serverId,
    code,
    name,
    salePrice,
    photo,
    categoryName,
    percentage,
    quantity
  ];

  static const List<String> columnsType = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.REAL

  ];

  ItemTable(String dbTableName, List<String> dbColumns, List<String> dbColumnsDataTypes, Database database, VerboseBloc bloc) : super(dbTableName, dbColumns, dbColumnsDataTypes, database, bloc);
}