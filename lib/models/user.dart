import 'package:pos_app/database/tables/database_tables.dart';

class User {
  final String id;
  final String name;
  final String outletId;
  User({this.id, this.name, this.outletId});

  User.fromMap(Map<String, dynamic> map)
      : id = map[UserTable.LOCAL_ID],
        name = map[UserTable.FULL_NAME],
        outletId = map[UserTable.OUTLET_ID];
}
