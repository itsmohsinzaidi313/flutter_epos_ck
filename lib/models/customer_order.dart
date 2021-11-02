import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/shared/app_library.dart';

class Order extends ChangeNotifier {
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
      time,
      date,
      tax,
      tiltId,
      discountedAmount,
      payment,
      cardNumber;
  int covers;
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
        covers = map[_CoversKey],
        customer = Customer.fromMap(map[_CustomerKey]),
        orderType = map[_OrderTypeKey],
        userId = map[_UserIdKey],
        orderNo = map[_OrderNoKey].toString(),
        time = map[_OrderTimeKey],
        date = map[_OrderDateKey],
        tiltId = map[_TiltIdKey] {
    items.addAll((map[_ItemsKey] as List<dynamic>)
        .map((e) => MenuItem.fromMap(e))
        .toList());
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
      _CustomerKey: customer?.map,
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
    items = items ?? [];

    if (item is OnSpotDeal) {
      var deal = item;
      bool itemExists = false;
      for (var i in items) {
        if (i is OnSpotDeal && i == deal) {
          itemExists = true;
          i.quantity++;
          break;
        }
      }
      if (!itemExists) {
        items.add(OnSpotDeal.fromOnSpotDeal(deal));
      }
    } else {
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
    notifyListeners();
  }

  void reduceCartItem(Item item, {bool removeZeroQuantity = true}) {
    items = items ?? [];

    if (item is OnSpotDeal) {
      var deal = item;
      for (var i in items) {
        if (i is OnSpotDeal && i == deal && i.quantity > 0) {
          i.quantity--;
        }
        if (i.quantity < 1 && removeZeroQuantity) {
          items.removeAt(items.indexOf(i));
        }
        break;
      }
    } else {
      for (var i = 0; i < items.length; i++) {
        if (items[i].id == '${item.id}') {
          if (items[i].quantity > 0) {
            items[i].quantity--;
          }
          if (items[i].quantity < 1 && removeZeroQuantity) {
            items.removeAt(items.indexOf(items[i]));
          }
          break;
        }
      }
    }
    notifyListeners();
  }

  void addItemComment(Item item, String comment) {
    if (item is OnSpotDeal) {
      var deal = item;
      items
          .where((element) => element is OnSpotDeal && element == deal)
          .first
          .comment = comment;
    } else {
      items.where((element) => element.id == item.id).first.comment = comment;
    }
    notifyListeners();
  }

  void setItemQuantity(Item item, String quantity) {
    if (item is OnSpotDeal) {
      var deal = item;
      items
          .where((element) => element is OnSpotDeal && element == deal)
          .first
          .quantity = double.tryParse(quantity) ?? 0.0;
    } else {
      items.where((element) => element.id == item.id).first.quantity =
          double.tryParse(quantity) ?? 0.0;
    }
    notifyListeners();
  }

  void removeItem(Item item) {
    items = items ?? <Item>[];
    for (var i in items) {
      if (item is OnSpotDeal) {
        if (i == item) {
          items.removeAt(items.indexOf(i));
          break;
        }
      } else {
        if (i.id == item.id) {
          items.removeAt(items.indexOf(i));
          break;
        }
      }
    }
  }

  String get subTotal {
    double amount = 0;
    for (var item in items) {
      amount += item.price * item.quantity;
    }
    return amount.toStringAsFixed(2);
  }

  String get totalTaxAmount {
    double amount = 0;
    for (var item in items) {
      amount += item.taxAmount * item.quantity;
    }
    return amount.toStringAsFixed(2);
  }

  String get totalTax => ((double.tryParse(totalTaxAmount) ?? 0) -
          (double.tryParse(subTotal) ?? 0))
      .toStringAsFixed(2);

  void reset() {
    items = [];
    id = '';
    waiterId = '';
    tableId = '';
    covers = 0;
    cardNumber = '';
    orderType = '';
    userId = '';
    orderNo = '';
    time = '';
    date = '';
    discountedAmount = '';
    notifyListeners();
  }

  void setTable({Tables table}) {
    this.tableId = table.id;
    notifyListeners();
  }

  void setWaiter({Waiter waiter}) {
    this.waiterId = waiter.id;
    notifyListeners();
  }

  void setCustomer(
      {Customer customer, String contact, String name, String address}) {
    if (this.customer == null) {
      this.customer = Customer();
    }
    if (customer != null) this.customer = customer;
    if (contact != null) this.customer.contact = contact;
    if (name != null) this.customer.name = name;
    if (address != null) this.customer.address = address;
    notifyListeners();
  }

  void setCovers({int covers = 0}) {
    this.covers = covers ?? 0;
    notifyListeners();
  }
}
