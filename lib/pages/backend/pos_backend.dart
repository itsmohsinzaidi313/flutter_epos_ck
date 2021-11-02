import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/menu.dart';
import 'package:pos_app/repositories/menu_repository.dart';

class POSBackend {
  static POSBackend instance = POSBackend._();
  POSBackend._();

  Future<POSMenu> getMenu() async {
    Response response = await MenuRepo.repo.getMenu();
    if (response.statusCode == HttpStatus.ok) {
      return POSMenu.fromMap(jsonDecode(response.body));
    } else
      throw Exception(
          'Either there is no menu created or the connection to server is disconnected');
  }

  postOrder(Order order) {}
}
