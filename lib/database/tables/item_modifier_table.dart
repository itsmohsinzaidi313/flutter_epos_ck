

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ItemModifierTable extends SqlCommons {

  static const String TABLE_NAME = 'item_modifiers'; //9

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String MODIFIED_ID = 'modifier_id';
  static const String FOOD_MENU_ID = 'food_menu_id';
  static const String USER_ID = 'user_id';
  static const String OUTLET_ID = 'outlet_id';
  static const String COMPANY_ID = 'company_id';
  static const String DEL_STATUS = 'name';
  static const String NAME = 'price';
  static const String PRICE = 'del_status';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    MODIFIED_ID,
    FOOD_MENU_ID,
    USER_ID,
    OUTLET_ID,
    COMPANY_ID,
    DEL_STATUS,
    NAME,
    PRICE
  ];

  static const List<String> COLUMN_TYPES = [
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

  ItemModifierTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}