import 'dart:convert';

import 'package:pos_app/database/tables/database_tables.dart';

class Customer {
  String id = '', name = '', contact = '', address = '';
  Customer({this.id, this.name, this.contact, this.address});

  Customer.empty()
      : id = '0',
        name = '',
        contact = '',
        address = '';

  Customer.fromMap(Map<String, dynamic> map)
      : id = map[CustomerTable.REMOTE_ID].toString(),
        name = map[CustomerTable.NAME],
        contact = map[CustomerTable.PHONE].toString(),
        address = map[CustomerTable.ADDRESS];

  String get toJson => {
        jsonEncode(CustomerTable.NAME): jsonEncode(name),
        jsonEncode(CustomerTable.PHONE): jsonEncode(contact),
        jsonEncode(CustomerTable.ADDRESS): jsonEncode(address)
      }.toString();
}
