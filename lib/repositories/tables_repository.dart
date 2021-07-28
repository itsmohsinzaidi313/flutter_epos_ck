import 'package:pos_app/models/objects/table.dart';

class TablesRepo {
  static TablesRepo repo = TablesRepo._internal();
  TablesRepo._internal();
  Future<List<Table>> get tables async => [];
}
