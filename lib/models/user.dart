import 'package:pos_app/database/tables/database_tables.dart';

class User {
  static const String _IdKey = 'Id';
  static const String _NameKey = 'Name';
  static const String _TiltIdKey = 'TiltId';
  final String id;
  final String name;
  final String tiltId;
  User({this.id, this.name, this.tiltId});

  User.fromMap(Map<String, dynamic> map)
      : id = map[UserTable.SERVER_ID],
        name = map[UserTable.FULL_NAME],
        tiltId = map[UserTable.OUTLET_ID];
}
