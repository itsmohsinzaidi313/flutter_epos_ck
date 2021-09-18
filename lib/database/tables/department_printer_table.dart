import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DepartmentPrinterTable extends SqlCommons {
  static const String TABLE_NAME = 'department_printers';

  static const String LOCAL_ID = 'local_id';
  static const String OUTLET_ID = 'outlet_id';
  static const String PRINTER_IP = 'printer_ip';
  static const String DEL_STATUS = 'del_status';
  static const String DATE_ADDED = 'date_added';
  static const String DATE_MODIFIED = 'date_modified';

  static const List<String> COLUMN_NAMES = [
    LOCAL_ID,
    OUTLET_ID,
    PRINTER_IP,
    DEL_STATUS,
    DATE_ADDED,
    DATE_MODIFIED,
  ];

  static const List<String> COLUMN_TYPES = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];

  DepartmentPrinterTable(Database database, VerboseBloc bloc)
      : super(TABLE_NAME, COLUMN_NAMES, COLUMN_TYPES, database, bloc);
}
