import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class RegisterTable extends SqlCommons {
  static const String TABLE_NAME = 'register_data';

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String REMOTE_ID = 'remote_id';
  static const String OPENING_BALANCE = 'opening_balance';
  static const String CLOSING_BALANCE = 'closing_balance';
  static const String OPENING_BALANCE_DATE_TIME = 'opening_balance_date_time';
  static const String CLOSING_BALANCE_DATE_TIME = 'closing_balance_date_time';
  static const String SALE_PAID_AMOUNT = 'sale_paid_amount';
  static const String CUSTOMER_DUE_RECEIVE = 'customer_due_receive';
  static const String PAYMENT_METHODS_SALE = 'payment_methods_sale';
  static const String REGISTER_STATUS = 'register_status';
  static const String USER_ID = 'user_id';
  static const String OUTLET_ID = 'outlet_id';
  static const String COMPANY_ID = 'company_id';
  static const String REGISTER_NO = 'register_no';
  static const String DEVICE_KEY = 'device_key';
  static const String IS_UPLOADED = 'is_uploaded';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    REMOTE_ID,
    OPENING_BALANCE,
    CLOSING_BALANCE,
    OPENING_BALANCE_DATE_TIME,
    CLOSING_BALANCE_DATE_TIME,
    SALE_PAID_AMOUNT,
    CUSTOMER_DUE_RECEIVE,
    PAYMENT_METHODS_SALE,
    REGISTER_STATUS,
    USER_ID,
    OUTLET_ID,
    COMPANY_ID,
    REGISTER_NO,
    DEVICE_KEY,
    IS_UPLOADED,
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
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

  RegisterTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
