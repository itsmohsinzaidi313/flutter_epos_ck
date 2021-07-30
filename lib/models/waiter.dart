import 'package:pos_app/database/tables/database_tables.dart';

class Waiter {
  String id;
  String name;
  bool selected;
  Waiter({this.id, this.name});
  Waiter.fromMap(Map<String, dynamic> map)
      : id = map[UserTable.SERVER_ID].toString(),
        name = map[UserTable.FULL_NAME],
        selected = false;
}
