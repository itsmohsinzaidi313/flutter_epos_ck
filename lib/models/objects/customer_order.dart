import 'dart:convert';

import 'package:pos_app/models/objects/menu_item.dart';

class Order {
  static const ItemsKey = 'items';
  static const WaiterKey = 'waiter';
  static const TableKey = 'table';
  static const OrderTypeKey = 'orderType';
  static const CoversKey = 'covers';
  static const CustomerKey = 'customer';
  static const ContactKey = 'contact';
  static const AddressKey = 'address';
  static const UserIdKey = 'userId';

  List<MenuItem> _items = [];
  String waiter;
  String table;
  String userId;
  String orderType;
  String covers;
  String customer;
  String contact;
  String address;

  Order(
      {this.waiter,
      this.table,
      this.address,
      this.contact,
      this.covers,
      this.customer,
      this.orderType,
      this.userId});

  Order.fromJson(Map<String, dynamic> map)
      : _items = (map[ItemsKey] as List<dynamic>)
            .map((e) => MenuItem.fromJson(e))
            .toList(),
        waiter = map[WaiterKey],
        table = map[TableKey],
        address = map[AddressKey],
        contact = map[ContactKey],
        covers = map[CoversKey],
        customer = map[CustomerKey],
        orderType = map[OrderTypeKey],
        userId = map[UserIdKey];

  String get toJson => {
        jsonEncode(ItemsKey): jsonEncode(_items),
        jsonEncode(WaiterKey): jsonEncode(waiter),
        jsonEncode(TableKey): jsonEncode(table),
        jsonEncode(AddressKey): jsonEncode(address),
        jsonEncode(ContactKey): jsonEncode(contact),
        jsonEncode(CoversKey): jsonEncode(covers),
        jsonEncode(CustomerKey): jsonEncode(customer),
        jsonEncode(OrderTypeKey): jsonEncode(orderType),
        jsonEncode(UserIdKey): jsonEncode(userId)
      }.toString();

  List<MenuItem> get cartItems => _items ?? [];

  void addCartItem(MenuItem item) {
    if (_items == null) _items = [];
    bool itemExists = false;
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == item.id) {
        _items[i].quantity++;
        itemExists = true;
        break;
      }
    }
    if (!itemExists) {
      _items.add(MenuItem.fromItem(item));
    }
  }

  void reduceCartItem(int itemId) {
    if (_items == null) _items = [];
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == '$itemId') {
        _items[i].quantity--;
        if (_items[i].quantity < 1) {
          removeCartItem(itemId);
        }
        break;
      }
    }
  }

  void removeCartItem(int itemId) =>
      _items.removeAt(_items.indexWhere((element) => element.id == '$itemId'));

  void addItemComment(int itemId, String comment) =>
      _items.where((element) => element.id == itemId.toString()).first.comment =
          comment;

  String get totalAmount {
    double total = 0;
    _items.forEach((e) {
      total += double.parse(e.price) * e.quantity;
    });
    return total.toStringAsFixed(2);
  }

  String get totalTaxAmount {
    double totalTax = 0;
    _items.forEach((e) {
      totalTax += double.parse(e.taxPrice) * e.quantity;
    });
    return totalTax.toStringAsFixed(2);
  }
}
