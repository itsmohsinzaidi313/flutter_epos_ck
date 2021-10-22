import 'dart:developer';

import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/menu.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/shared/app_library.dart';

class Order {
  static const String _OrderIdKey = 'Id',
      _MenuKey = 'Menu',
      _ItemsKey = 'Items',
      _FixedDealKey = 'FixedDeals',
      _OnSpotDealKey = 'OnSpotDeals',
      _WaiterKey = 'Waiter',
      _TableKey = 'Table',
      _OrderTypeKey = 'OrderType',
      _CoversKey = 'Covers',
      _CustomerKey = 'Customer',
      _UserIdKey = 'UserId',
      _OrderNoKey = 'OrderNo',
      _OrderTimeKey = 'Time',
      _OrderDateKey = 'Date',
      _TiltIdKey = 'TiltId';

  List<Item> items = [];
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
      tiltId,
      discountedAmount,
      payment,
      cardNumber;
  Customer customer = Customer();
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

  Order.fromMap(Map<String, dynamic> map)
      : id = map[_OrderIdKey].toString(),
        waiterId = map[_WaiterKey],
        tableId = map[_TableKey],
        covers = map[_CoversKey].toString(),
        customer = Customer.fromMap(map[_CustomerKey]),
        orderType = map[_OrderTypeKey],
        userId = map[_UserIdKey],
        orderNo = map[_OrderNoKey].toString(),
        time = map[_OrderTimeKey],
        date = map[_OrderDateKey],
        tiltId = map[_TiltIdKey] {
    items.addAll(
        (map[_ItemsKey] as List<dynamic>).map((e) => Item.fromMap(e)).toList());
    items.addAll((map[_FixedDealKey] as List<dynamic>)
        .map((e) => FixedDeal.fromMap(e))
        .toList());
    items.addAll((map[_OnSpotDealKey] as List<dynamic>)
        .map((e) => OnSpotDeal.fromMap(e))
        .toList());
  }

  Map<String, dynamic> get map {
    List<dynamic> itemsList = [];
    List<dynamic> fixedDealList = [];
    List<dynamic> onSpotDealsList = [];

    POSMenu menu = POSMenu();

    for (var item in items) {
      if (item is MenuItem) {
        itemsList.add(item.toMap());
      } else if (item is FixedDeal) {
        fixedDealList.add(item.toMap());
      } else if (item is OnSpotDeal) {
        onSpotDealsList.add(item.toMap());
      } else {}
    }
    return {
      _ItemsKey: itemsList,
      _FixedDealKey: fixedDealList,
      _OnSpotDealKey: onSpotDealsList,
      _CustomerKey: customer?.toMap(),
      _OrderIdKey: id ?? '0',
      _WaiterKey: waiterId ?? '0',
      _TableKey: tableId ?? '0',
      _CoversKey: covers ?? '0',
      _OrderTypeKey: orderType ?? '0',
      _UserIdKey: userId ?? '0',
      _TiltIdKey: tiltId ?? '0',
      _OrderDateKey: Lib.getDate(),
      _OrderTimeKey: Lib.getTime12HR(),
    };
  }

  void addCartItem(Item item) {
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
      if (item is MenuItem) {
        items.add(MenuItem.fromMenuItem(item));
      } else if (item is FixedDeal) {
        items.add(FixedDeal.fromDeal(item));
      }
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
      amount += item.price * item.quantity;
    }
    return amount.toStringAsFixed(2);
  }

  String get totalTaxedAmount {
    double amount = 0;
    for (var item in items) {
      amount += item.taxAmount * item.quantity;
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
