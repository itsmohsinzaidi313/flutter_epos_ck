import 'package:pos_app/models/objects/user.dart';

class WaiterRepo {
  static WaiterRepo repo = WaiterRepo._internal();
  WaiterRepo._internal();
  Future<List<User>> get waiters async => [];
}
