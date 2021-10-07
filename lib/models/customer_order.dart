import 'dart:developer';

import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/models/menu_item.dart';

class Order {
  static const _OrderIdKey = 'id';
  static const _ItemsKey = 'items';
  static const _WaiterKey = 'waiter';
  static const _TableKey = 'table';
  static const _OrderTypeKey = 'orderType';
  static const _CoversKey = 'covers';
  static const _CustomerKey = 'customer';
  static const _ContactKey = 'contact';
  static const _AddressKey = 'address';
  static const _UserIdKey = 'userId';
  static const _OrderNoKey = 'orderNo';
  static const _OrderTimeKey = 'time';
  static const _OrderDateKey = 'date';
  static const _TiltIdKey = 'tiltId';

  List<MenuItem> items = [];
  String id,
      waiterId,
      tableId,
      userId,
      orderType,
      orderNo,
      covers,
      customer,
      contact,
      address,
      time,
      date,
      tax,
      tiltId,
      discountedAmount,
      payment,
      cardNumber;
  PAYMENTMODE paymentmode;
  bool editOrder = false;

  Order(
      {this.id,
      this.waiterId,
      this.tableId,
      this.address,
      this.contact,
      this.covers,
      this.customer,
      this.orderType,
      this.orderNo});

  Order.fromJson(Map<String, dynamic> map)
      : id = map[_OrderIdKey].toString(),
        waiterId = map[_WaiterKey],
        tableId = map[_TableKey],
        address = map[_AddressKey],
        contact = map[_ContactKey],
        covers = map[_CoversKey].toString(),
        customer = map[_CustomerKey],
        orderType = map[_OrderTypeKey],
        userId = map[_UserIdKey],
        orderNo = map[_OrderNoKey].toString(),
        time = map[_OrderTimeKey],
        date = map[_OrderDateKey],
        items = (map[_ItemsKey] as List<dynamic>)
            .map((e) => MenuItem.fromJson(e))
            .toList();

  Map<String, dynamic> get toJson => {
        _ItemsKey: items.map((e) => e.toJson()).toList(),
        _OrderIdKey: id ?? '0',
        _WaiterKey: waiterId ?? '0',
        _TableKey: tableId ?? '0',
        _AddressKey: address ?? '0',
        _ContactKey: contact ?? '0',
        _CoversKey: covers ?? '0',
        _CustomerKey: customer ?? '0',
        _OrderTypeKey: orderType ?? '0',
        _UserIdKey: userId ?? '0',
        _TiltIdKey: tiltId ?? '0'
      };

  List<MenuItem> get cartItems => items ?? [];

  void addCartItem(MenuItem item) {
    if (items == null) items = [];
    bool itemExists = false;
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == item.id) {
        items[i].quantity++;
        itemExists = true;
        break;
      }
    }
    if (!itemExists) {
      items.add(MenuItem.fromItem(item));
    }
  }

  void reduceCartItem(int itemId, {bool removeZeroQuantity = true}) {
    if (items == null) items = [];
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == '$itemId') {
        if (items[i].quantity > 0) {
          items[i].quantity--;
        }
        if (items[i].quantity < 1 && removeZeroQuantity) {
          removeCartItem(itemId);
        }
        break;
      }
    }
  }

  void removeCartItem(int itemId) =>
      items.removeAt(items.indexWhere((element) => element.id == '$itemId'));

  void addItemComment(int itemId, String comment) =>
      items.where((element) => element.id == itemId.toString()).first.comment =
          comment;

  void setItemQuantity(int itemId, double quantity) =>
      items.where((element) => element.id == itemId.toString()).first.quantity =
          quantity;

  String get subTotal {
    double amount = 0;
    for (var item in items) {
      amount += double.parse(item.price) * item.quantity;
    }
    return amount.toStringAsFixed(2);
  }

  String get totalTaxedAmount {
    double amount = 0;
    for (var item in items) {
      amount += double.parse(item.taxAmount) * item.quantity;
    }
    return amount.toStringAsFixed(2);
  }

  String get totalTax => ((double.tryParse(totalTaxedAmount) ?? 0) -
          (double.tryParse(subTotal) ?? 0))
      .toStringAsFixed(2);

  void reset() {
    items = [];
    id = '';
    waiterId = '';
    tableId = '';
    address = '';
    contact = '';
    covers = '';
    cardNumber = '';
    customer = '';
    orderType = '';
    userId = '';
    orderNo = '';
    time = '';
    date = '';
    discountedAmount = '';
  }

  void copyOrder(Order order) {
    items = order.items;
    id = order.id;
    waiterId = order.waiterId;
    tableId = order.tableId;
    address = order.address;
    contact = order.contact;
    covers = order.covers;
    cardNumber = order.cardNumber;
    customer = order.customer;
    orderType = order.orderType;
    userId = order.userId;
    orderNo = order.orderNo;
    time = order.time;
    date = order.date;
    discountedAmount = order.discountedAmount;
  }
}
