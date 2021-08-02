import 'package:pos_app/database/tables/database_tables.dart';

class User {
  String id, name, outletId;
  User({this.id, this.name, this.outletId});

  User.fromMap(Map<String, dynamic> map)
      : id = map[UserTable.LOCAL_ID].toString(),
        name = map[UserTable.FULL_NAME],
        outletId = map[UserTable.OUTLET_ID].toString();
}
