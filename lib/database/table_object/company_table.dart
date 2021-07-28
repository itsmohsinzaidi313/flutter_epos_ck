

import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class CompanyTable extends SqlCommons{

  static const String TABLE_NAME = 'company'; //6

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String CURRENCY = 'currency';
  static const String TIMEZONE = 'timezone';
  static const String DATEFORMAT = 'date_format';
  static const String OUTLET_ID = 'outlet_id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PHONE1 = 'phone_1';
  static const String PHONE2 = 'phone_2';
  static const String ADDRESS = 'address';
  static const String STATUS = 'status';
  static const String DATE_ADDED = 'date_added';
  static const String EXPIRY_DATE = 'expiry_date';
  static const String TOKEN = 'token';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    CURRENCY,
    TIMEZONE,
    DATEFORMAT,
    OUTLET_ID,
    NAME,
    EMAIL,
    PHONE1,
    PHONE2,
    ADDRESS,
    STATUS,
    DATE_ADDED,
    EXPIRY_DATE,
    TOKEN
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];

  CompanyTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}