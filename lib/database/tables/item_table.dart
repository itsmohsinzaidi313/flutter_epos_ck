

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ItemTable extends SqlCommons{

  static const String TABLE_NAME = 'item_menus';

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String CODE = 'code';
  static const String NAME = 'name';
  static const String SALE_PRICE = 'sale_price';
  static const String PHOTO = 'photo';
  static const String CATEGORY_NAME = 'category_name';
  static const String PERCENTAGE = 'percentage';
  static const String QUANTITY = 'quantity';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    CODE,
    NAME,
    SALE_PRICE,
    PHOTO,
    CATEGORY_NAME,
    PERCENTAGE,
    QUANTITY
  ];

  static const List<String> COLUMN_TYPES = [
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

  ItemTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}