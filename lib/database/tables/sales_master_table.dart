

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SalesMasterTable extends SqlCommons{

  static const String TABLE_NAME = 'sales_master';

  static const String LOCAL_ID = 'local_id';
  static const String CUSTOMER_ID = 'customer_id';
  static const String SALE_NO = 'sale_no';
  static const String TOTAL_ITEMS = 'total_items';
  static const String SUBTOTAL = 'sub_total';
  static const String PAID_AMOUNT = 'paid_amount';
  static const String DUE_AMOUNT = 'due_amount';
  static const String DESCRIPTION = 'disc';
  static const String DISC_ACTUAL = 'disc_actual';
  static const String VAT = 'vat';
  static const String TOTAL_PAYABLE = 'total_payable';
  static const String PAYMENT_METHOD_ID = 'payment_method_id';
  static const String CLOSE_TIME = 'close_time';
  static const String TABLE_ID = 'table_id';
  static const String TOTAL_ITEM_DISCOUNT_AMOUNT = 'total_item_discount_amount';
  static const String SUBTOTAL_WITH_DISCOUNT = 'sub_total_with_discount';
  static const String SUBTOTAL_DISCOUNT_AMOUNT = 'sub_total_discount_amount';
  static const String TOTAL_DISCOUNT_AMOUNT = 'total_discount_amount';
  static const String DELIVERY_CHARGE = 'delivery_charge';
  static const String SUBTOTAL_DISCOUNT_VALUE = 'sub_total_discount_value';
  static const String SUBTOTAL_DISCOUNT_TYPE = 'sub_total_discount_type';
  static const String SALE_DATE = 'sale_date';
  static const String DATETIME = 'date_time';
  static const String ORDER_TIME = 'order_time';
  static const String COOKING_START_TIME = 'cooking_start_time';
  static const String COOKING_DONE_TIME = 'cooking_done_time';
  static const String MODIFIED = 'modified';
  static const String USER_ID = 'user_id';
  static const String WAITER_ID = 'waiter_id';
  static const String OUTLET_ID = 'outlet_id';
  static const String ORDER_STATUS = 'order_status';
  static const String ORDER_TYPE = 'order_type';
  static const String DEL_STATUS = 'del_status';
  static const String SALE_VAT_OBJECTS = 'sale_vat_objects';
  static const String DEVICE_KEY = 'device_key';
  static const String SERVER_ID = 'id';
  static const String COMPANY_ID = 'company_id';
  static const String IS_DELETED = 'is_delete';
  static const String IS_UPLOADED = 'is_uploaded';
  static const String SHIFT = 'shift';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    CUSTOMER_ID,
    SALE_NO,
    TOTAL_ITEMS,
    SUBTOTAL,
    PAID_AMOUNT,
    DUE_AMOUNT,
    DESCRIPTION,
    DISC_ACTUAL,
    VAT,
    TOTAL_PAYABLE,
    PAYMENT_METHOD_ID,
    CLOSE_TIME,
    TABLE_ID,
    TOTAL_ITEM_DISCOUNT_AMOUNT,
    SUBTOTAL_WITH_DISCOUNT,
    SUBTOTAL_DISCOUNT_AMOUNT,
    TOTAL_DISCOUNT_AMOUNT,
    DELIVERY_CHARGE,
    SUBTOTAL_DISCOUNT_VALUE,
    SUBTOTAL_DISCOUNT_TYPE,
    SALE_DATE,
    DATETIME,
    ORDER_TIME,
    COOKING_START_TIME,
    COOKING_DONE_TIME,
    MODIFIED,
    USER_ID,
    WAITER_ID,
    OUTLET_ID,
    ORDER_STATUS,
    ORDER_TYPE,
    DEL_STATUS,
    SALE_VAT_OBJECTS,
    DEVICE_KEY,
    SERVER_ID,
    COMPANY_ID,
    IS_DELETED,
    IS_UPLOADED,
    SHIFT
  ];

    static const List<String> COLUMN_TYPES = [
      SqlCommons.INT_PRIMARYKEY,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.REAL,
      SqlCommons.REAL,
      SqlCommons.REAL,
      SqlCommons.TEXT,
      SqlCommons.REAL,
      SqlCommons.REAL,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.TEXT,
      SqlCommons.INTEGER,
      SqlCommons.REAL,
      SqlCommons.REAL,
      SqlCommons.REAL,
      SqlCommons.REAL,
      SqlCommons.REAL,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.TEXT,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.INTEGER,
      SqlCommons.TEXT
    ];

  SalesMasterTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}