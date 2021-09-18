import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/database/models/device.dart';
import 'package:pos_app/database/models/register.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/models/menu_item.dart';

class Order {
  static const String DINEIN = '1';
  static const String TAKEAWAY = '2';
  static const String DELIVERY = '3';
  List<MenuItem> items = [];
  Register register = Register();
  Customer customer = Customer();
  Device device = Device();

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
      discountedAmount = '0.0',
      payment,
      cardNumber;
  PAYMENTMODE paymentMode;
  bool editOrder = false;

  Order(
      {this.id,
      this.waiterId,
      this.tableId,
      this.covers,
      this.customer,
      this.orderType,
      this.orderNo});

  Order.fromMap(Map<String, dynamic> map, Map<String, dynamic> customerMap,
      List<Map<String, dynamic>> itemsList)
      : id = map[SalesMasterTable.SERVER_ID].toString(),
        waiterId = map[SalesMasterTable.WAITER_ID],
        tableId = map[SalesMasterTable.TABLE_ID],
        covers = map[OrdersTable.PERSONS].toString(),
        orderType = map[SalesMasterTable.ORDER_TYPE],
        userId = map[SalesMasterTable.USER_ID],
        orderNo = map[SalesMasterTable.SALE_NO].toString(),
        time = map[SalesMasterTable.ORDER_TIME],
        date = map[SalesMasterTable.SALE_DATE],
        customer = Customer.fromMap(customerMap),
        items = itemsList.map((e) => MenuItem.fromMap(e)).toList();

  Order.fromDB(Map<String, dynamic> master, List<Map<String, dynamic>> details)
      : id = master[SalesMasterTable.LOCAL_ID].toString(),
        tableId = master[SalesMasterTable.TABLE_ID].toString(),
        waiterId = master[SalesMasterTable.WAITER_ID].toString(),
        userId = master[SalesMasterTable.USER_ID].toString(),
        orderType = master[SalesMasterTable.ORDER_TYPE],
        orderNo = master[SalesMasterTable.SALE_NO].toString(),
        time = master[SalesMasterTable.DATETIME].toString().substring(11),
        date = master[SalesMasterTable.DATETIME].toString().substring(0, 10),
        tax = master[SalesMasterTable.SUBTOTAL].toString(),
        outletId = master[SalesMasterTable.OUTLET_ID].toString(),
        discountedAmount =
            master[SalesMasterTable.TOTAL_DISCOUNT_AMOUNT] == null
                ? '0.0'
                : master[SalesMasterTable.TOTAL_DISCOUNT_AMOUNT].toString(),
        payment = master[SalesMasterTable.PAID_AMOUNT].toString() ?? '0.0',
        cardNumber = '0',
        items = details.map((e) => MenuItem.fromDB(e)).toList();

  List<MenuItem> get cartItems => items ?? [];

  void addCartItem(MenuItem item) {
    items ??= [];
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
    items ??= [];
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
