import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/models/objects/user.dart';

class Order {
  static const OrderIdKey = 'id';
  static const ItemsKey = 'items';
  static const WaiterKey = 'waiter';
  static const TableKey = 'table';
  static const OrderTypeKey = 'orderType';
  static const CoversKey = 'covers';
  static const CustomerKey = 'customer';
  static const ContactKey = 'contact';
  static const AddressKey = 'address';
  static const UserIdKey = 'userId';
  static const OrderNoKey = 'orderNo';
  static const OrderTimeKey = 'time';
  static const OrderDateKey = 'date';
  static const TaxKey = 'tax';

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
      : id = map[OrderIdKey].toString(),
        waiterId = map[WaiterKey],
        tableId = map[TableKey],
        address = map[AddressKey],
        contact = map[ContactKey],
        covers = map[CoversKey].toString(),
        customer = map[CustomerKey],
        orderType = map[OrderTypeKey],
        userId = map[UserIdKey],
        orderNo = map[OrderNoKey].toString(),
        time = map[OrderTimeKey],
        date = map[OrderDateKey],
        tax = map[TaxKey],
        items = (map[ItemsKey] as List<dynamic>)
            .map((e) => MenuItem.fromJson(e))
            .toList();

  Map<String, dynamic> get toJson => {
        ItemsKey: items.map((e) => e.toJson()).toList(),
        OrderIdKey: id ?? '0',
        WaiterKey: waiterId ?? '0',
        TableKey: tableId ?? '0',
        AddressKey: address ?? '0',
        ContactKey: contact ?? '0',
        CoversKey: covers ?? '0',
        CustomerKey: customer ?? '0',
        OrderTypeKey: orderType ?? '0',
        UserIdKey: userId ?? '0',
        User.TiltIdKey: tiltId ?? '0'
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

  String get subTotal {
    double amount = 0;
    items.forEach((e) {
      amount += double.parse(e.price) * e.quantity;
    });
    return amount.toStringAsFixed(2);
  }

  String get totalTaxAmount {
    double amount = 0;
    items.forEach((e) {
      amount += double.parse(e.taxAmount);
    });
    return amount.toStringAsFixed(2);
  }

  String get totalAmount =>
      (double.parse(totalTaxAmount) + double.parse(subTotal))
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
