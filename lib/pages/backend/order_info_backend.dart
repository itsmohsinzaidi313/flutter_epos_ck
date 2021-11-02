import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/menu.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/repositories/customer_repository.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/repositories/tables_repository.dart';
import 'package:pos_app/repositories/waiters_repository.dart';
import 'package:provider/src/provider.dart';

class OrderInfoBackend {
  static OrderInfoBackend instance = OrderInfoBackend._();
  OrderInfoBackend._();
  Future<List<dynamic>> getValues(int viewType) async {
    if (viewType == 0) {
      Response response = await WaiterRepo.repo.getWaiters();
      if (response.statusCode == HttpStatus.ok) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((e) => Waiter.fromJson(e))
            .toList();
      } else {
        return <Waiter>[];
      }
    } else {
      Response response = await TablesRepo.repo.getTables();
      if (response.statusCode == HttpStatus.ok) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((e) => Tables.fromJson(e))
            .toList();
      } else {
        return <Tables>[];
      }
    }
  }

  Future<void> nextPage(BuildContext context) async {
    return Navigator.of(context).pushNamed('/pos');
  }

  Future<String> findCustomer(BuildContext context,
      {String contact = ''}) async {
    Response response = await CustomerRepo.repo.customer(contact: contact);
    if (response.statusCode == HttpStatus.ok) {
      List<Customer> list = (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Customer.fromMap(e))
          .toList();
      if (list.length >= 1) {
        return list.first.name;
      }
    }
    return '';
  }
}
