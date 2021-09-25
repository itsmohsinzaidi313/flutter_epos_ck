import 'dart:developer';

import 'package:pos_app/models/objects/member.dart';
import 'package:pos_app/models/objects/menu_item.dart';

class Order {
  static const _orderIdKey = 'orderKey',
      _itemsKey = 'items',
      _waiterKey = 'waiterId',
      _tableKey = 'tableId',
      _coversKey = 'covers',
      _userIdKey = 'userId',
      _orderTimeKey = 'time',
      _orderDateKey = 'date',
      _deviceIdKey = 'deviceKey',
      _slipNoKey = 'slipNo',
      _membersKey = 'members',
      _sessionIdKey = 'sessionId',
      _venueIdKey = 'venueId',
      _partyKey = 'isParty',
      _tiltIdKey = 'tiltId';

  List<MenuItem> items = [];
  List<Member> members = [];
  String id,
      waiterId,
      tableId,
      userId,
      sessionId,
      venueId,
      orderNo,
      covers,
      time,
      date,
      tax,
      slipNo,
      deviceKey,
      discountedAmount,
      payment,
      cardNumber,
      tiltId;
  bool party = false;
  bool editOrder = false;

  Order({this.id, this.waiterId, this.tableId, this.covers, this.orderNo});

  Order.fromMap(Map<String, dynamic> map)
      : id = map[_orderIdKey].toString(),
        waiterId = map[_waiterKey],
        tableId = map[_tableKey],
        covers = map[_coversKey].toString(),
        userId = map[_userIdKey],
        time = map[_orderTimeKey],
        date = map[_orderDateKey],
        party = map[_partyKey],
        sessionId = map[_sessionIdKey],
        venueId = map[_venueIdKey],
        orderNo = map[_slipNoKey],
        tiltId = map[_tiltIdKey],
        slipNo = map[_slipNoKey],
        members = (map[_membersKey] as List<dynamic>)
            .map((e) => Member.fromJson(e))
            .toList(),
        items = (map[_itemsKey] as List<dynamic>)
            .map((e) => MenuItem.fromJson(e))
            .toList();

  Map<String, dynamic> get toMap => {
        _membersKey: members.map((e) => e.toMap()).toList(),
        _itemsKey: items.map((e) => e.toMap()).toList(),
        _venueIdKey: venueId ?? '0',
        _sessionIdKey: sessionId ?? '0',
        _waiterKey: waiterId ?? '0',
        _tableKey: tableId ?? '0',
        _userIdKey: userId ?? '0',
        _slipNoKey: slipNo ?? '0',
        _orderIdKey: id ?? '0',
        _coversKey: covers ?? '0',
        _tiltIdKey: tiltId ?? '0',
        _partyKey: party,
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
    members = [];
    id = '';
    waiterId = '';
    tableId = '';
    covers = '';
    cardNumber = '';
    userId = '';
    orderNo = '';
    time = '';
    date = '';
    sessionId = '';
    venueId = '';
    discountedAmount = '';
  }

  void copyOrder(Order order) {
    items = order.items;
    members = order.members;
    id = order.id;
    waiterId = order.waiterId;
    tableId = order.tableId;
    covers = order.covers;
    cardNumber = order.cardNumber;
    userId = order.userId;
    orderNo = order.orderNo;
    time = order.time;
    date = order.date;
    discountedAmount = order.discountedAmount;
  }
}
