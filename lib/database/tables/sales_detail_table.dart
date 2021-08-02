import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SalesDetailTable extends SqlCommons {
  static const String TABLE_NAME = 'sales_details'; //5

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String FOOD_MENU_ID = 'food_menu_id';
  static const String MENU_NAME = 'menu_name';
  static const String QUANTITY = 'quantity';
  static const String MENU_PRICE_WITHOUT_DISCOUNT =
      'menu_price_without_discount';
  static const String MENU_PRICE_WITH_DISCOUNT = 'menu_price_with_discount';
  static const String MENU_UNIT_PRICE = 'menu_unit_price';
  static const String MENU_VAT_PERCENTAGE = 'menu_vat_percentage';
  static const String MENU_TAXES = 'menu_taxes';
  static const String MENU_DISCOUNT_VALUE = 'menu_discount_value';
  static const String DISCOUNT_TYPE = 'discount_type';
  static const String MENU_NOTE = 'menu_note';
  static const String DISCOUNT_AMOUNT = 'discount_amount';
  static const String ITEM_TYPE = 'item_type';
  static const String COOKING_STATUS = 'cooking_status';
  static const String COOKING_START_TIME = 'cooking_start_time';
  static const String COOKING_DONE_TIME = 'cooking_done_time';
  static const String PREVIOUS_ID = 'previous_id';
  static const String SALES_MASTER_ID = 'sales_id';
  static const String ORDER_STATUS = 'order_status';
  static const String USER_ID = 'user_id';
  static const String OUTLET_ID = 'outlet_id';
  static const String DEL_STATUS = 'del_status';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    FOOD_MENU_ID,
    MENU_NAME,
    QUANTITY,
    MENU_PRICE_WITHOUT_DISCOUNT,
    MENU_PRICE_WITH_DISCOUNT,
    MENU_UNIT_PRICE,
    MENU_VAT_PERCENTAGE,
    MENU_TAXES,
    MENU_DISCOUNT_VALUE,
    DISCOUNT_TYPE,
    MENU_NOTE,
    DISCOUNT_AMOUNT,
    ITEM_TYPE,
    COOKING_STATUS,
    COOKING_START_TIME,
    COOKING_DONE_TIME,
    PREVIOUS_ID,
    SALES_MASTER_ID,
    ORDER_STATUS,
    USER_ID,
    OUTLET_ID,
    DEL_STATUS,
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
  ];

  SalesDetailTable(Database database, VerboseBloc bloc)
      : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
