import 'package:pos_app/models/objects/user.dart';

class UsersRepo {
  static UsersRepo repo = UsersRepo._internal();
  UsersRepo._internal();

  Future<List<User>> users() async => [];
}
