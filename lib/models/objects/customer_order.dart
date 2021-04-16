import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/models/objects/menu_item.dart';

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
      waiter,
      table,
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
      discountedAmount,
      payment,
      cardNumber;
  PAYMENTMODE paymentmode;
  bool editOrder = false;

  Order(
      {this.id,
      this.waiter,
      this.table,
      this.address,
      this.contact,
      this.covers,
      this.customer,
      this.orderType,
      this.orderNo});

  Order.fromJson(Map<String, dynamic> map)
      : id = map[OrderIdKey].toString(),
        waiter = map[WaiterKey],
        table = map[TableKey],
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
        OrderIdKey: id,
        WaiterKey: waiter,
        TableKey: table,
        AddressKey: address,
        ContactKey: contact,
        CoversKey: covers,
        CustomerKey: customer,
        OrderTypeKey: orderType,
        UserIdKey: userId
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

  String get totalAmount {
    double total = 0;
    items.forEach((e) {
      total += double.parse(e.price) * e.quantity;
    });
    return total.toStringAsFixed(2);
  }

  String get totalTaxAmount {
    double totalTax = 0;
    items.forEach((e) {
      totalTax += double.parse(e.taxAmount);
    });
    return totalTax.toStringAsFixed(2);
  }

  void reset() {
    items = [];
    id = '';
    waiter = '';
    table = '';
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
    waiter = order.waiter;
    table = order.table;
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
