import 'package:pos_app/shared/config.dart';

class OrderRepo {
  static OrderRepo repo = OrderRepo._internal();
  OrderRepo._internal() {
    _url = Config.getOrdersApi;
  }
  String _url;
}
