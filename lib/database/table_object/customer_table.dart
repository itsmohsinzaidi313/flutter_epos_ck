

import 'package:flutter/cupertino.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class CustomerTable extends SqlCommons{

  static const String TABLE_NAME = 'customers'; //7

  static const String LOCAL_ID = 'local_id';
  static const String SERVER_ID = 'id';
  static const String NAME = 'name';
  static const String PHONE = 'phone';
  static const String EMAIL = 'email';
  static const String ADDRESS = 'address';
  static const String GST_NUMBER = 'gst_number';
  static const String AREA_ID = 'area_id';
  static const String USER_ID = 'user_id';
  static const String COMPANY_ID = 'company_id';
  static const String DEL_STATUS = 'del_status';
  static const String DATE_OF_BIRTH = 'date_of_birth';
  static const String DATE_OF_ANNIVERSARY = 'date_of_anniversary';
  static const String IS_UPLOADED = 'is_uploaded';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    SERVER_ID,
    NAME,
    PHONE,
    EMAIL,
    ADDRESS,
    GST_NUMBER,
    AREA_ID,
    USER_ID,
    COMPANY_ID,
    DEL_STATUS,
    DATE_OF_BIRTH,
    DATE_OF_ANNIVERSARY,
    IS_UPLOADED
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,

  ];

  CustomerTable(Database database, VerboseBloc bloc) : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}