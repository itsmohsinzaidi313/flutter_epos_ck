import 'dart:developer';

import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/models/menu_item.dart';

class Order {
  List<MenuItem> items = [];
  Customer customer;
  String id,
      waiterId,
      tableId,
      userId,
      orderType,
      orderNo,
      covers,
      time,
      date,
      tax,
      outletId,
      discountedAmount,
      payment,
      cardNumber;
  PAYMENTMODE paymentmode;
  bool editOrder = false;

  Order(
      {this.id,
      this.waiterId,
      this.tableId,
      this.covers,
      this.customer,
      this.orderType,
      this.orderNo});

  Order.fromMap(Map<String, dynamic> map, Map<String, dynamic> customerMap, List<Map<String, dynamic>> itemsList)
      : id = map[SalesMasterTable.SERVER_ID].toString(),
        waiterId = map[SalesMasterTable.WAITER_ID],
        tableId = map[SalesMasterTable.TABLE_ID],
        covers = map[OrdersTable.PERSONS].toString(),
        orderType = map[SalesMasterTable.ORDER_TYPE],
        userId = map[SalesMasterTable.USER_ID],
        orderNo = map[SalesMasterTable.SALE_NO].toString(),
        time = map[SalesMasterTable.ORDER_TIME],
        date = map[SalesMasterTable.SALE_DATE],
        customer = Customer.fromJson(customerMap),
        items = itemsList.map((e) => MenuItem.fromMap(e)).toList();

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
    covers = '';
    cardNumber = '';
    customer = Customer();
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
