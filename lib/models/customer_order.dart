import 'package:equatable/equatable.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/models/customer_order_context.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/items_cart.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/enums.dart';

class Order extends OrderContext with EquatableMixin {
  static const String _orderIdKey = 'Id',
      // _MenuKey = 'Menu',
      _itemsKey = 'Items',
      _fixedDealKey = 'FixedDeals',
      _onSpotDealKey = 'OnSpotDeals',
      _waiterKey = 'Waiter',
      _tableKey = 'Table',
      _orderTypeKey = 'OrderType',
      _coversKey = 'Covers',
      _customerKey = 'Customer',
      _orderNoKey = 'OrderNo',
      _orderTimeKey = 'Time',
      _orderDateKey = 'Date',
      _deviceIdKey = 'DeviceId',
      _paidAmountKey = 'PaidAmount',
      _discountAmountKey = 'DiscountAmount',
      _discountPercentageKey = 'DiscountPercentage';

  final ItemsCart cart;

  const Order({
    String id = '',
    String cardNumber = '',
    String covers = '',
    Customer customer = const Customer(),
    OrderStatus orderStatus = OrderStatus.incomplete,
    String date = '',
    String deviceId = '',
    String orderNumber = '',
    OrderType orderType = OrderType.dineIn,
    PaymentMode paymentMode = PaymentMode.cash,
    Waiter waiter = const Waiter(),
    Tables tables = const Tables(),
    String time = '',
    double paidAmount = 0.0,
    double discountAmount = 0.0,
    double discountPercentage = 0.0,
    required this.cart,
  }) : super(
          id: id,
          cardNumber: cardNumber,
          covers: covers,
          customer: customer,
          date: date,
          deviceId: deviceId,
          orderNumber: orderNumber,
          orderStatus: orderStatus,
          orderType: orderType,
          paymentMode: paymentMode,
          table: tables,
          time: time,
          waiter: waiter,
          paidAmount: paidAmount,
          discountAmount: discountAmount,
          discountPercentage: discountPercentage,
        );

  Order.modify(Order order,
      {String? id,
      String? cardNumber,
      String? covers,
      Customer? customer,
      OrderStatus? orderStatus,
      String? date,
      String? deviceId,
      String? orderNumber,
      OrderType? orderType,
      PaymentMode? paymentmode,
      Waiter? waiter,
      Tables? table,
      String? time,
      double? paidAmount,
      double? discountAmount,
      double? discountPercentage,
      ItemsCart? cart})
      : cart = cart ?? order.cart,
        super(
          id: id ?? order.id,
          cardNumber: cardNumber ?? order.cardNumber,
          covers: covers ?? order.covers,
          customer: customer ?? order.customer,
          date: date ?? order.date,
          deviceId: deviceId ?? order.deviceId,
          orderStatus: orderStatus ?? order.orderStatus,
          orderNumber: orderNumber ?? order.orderNumber,
          orderType: orderType ?? order.orderType,
          paymentMode: paymentmode ?? order.paymentMode,
          table: table ?? order.table,
          time: time ?? order.time,
          waiter: waiter ?? order.waiter,
          paidAmount: paidAmount ?? order.paidAmount,
          discountAmount: discountAmount ?? order.discountAmount,
          discountPercentage: discountPercentage ?? order.discountPercentage,
        );

  Order.fromMap(Map<String, dynamic> map)
      : cart = ItemsCart(items: [
          ...(map[_itemsKey] as List<dynamic>)
              .map((e) => FoodItem.fromMap(e))
              .toList(),
          ...(map[_fixedDealKey] as List<dynamic>)
              .map((e) => FixedDeal.fromMap(e))
              .toList(),
          ...(map[_onSpotDealKey] as List<dynamic>)
              .map((e) => OnSpotDeal.fromMap(e))
              .toList()
        ]),
        super(
          id: map[_orderIdKey].toString(),
          waiter: Waiter.fromMap(map[_waiterKey]),
          table: Tables.fromMap(map[_tableKey]),
          covers: map[_coversKey].toString(),
          customer: Customer.fromMap(map[_customerKey]),
          time: map[_orderTimeKey],
          date: map[_orderDateKey],
          deviceId: map[_deviceIdKey],
          orderStatus: OrderStatus.complete,
          paymentMode: PaymentMode.cash,
          cardNumber: '',
          orderNumber: map[_orderNoKey].toString(),
          orderType: map[_orderTypeKey] == '1'
              ? OrderType.dineIn
              : (map[_orderTypeKey] == '2'
                  ? OrderType.takeAway
                  : OrderType.delivery),
          paidAmount: double.tryParse(map[_paidAmountKey] as String? ?? '0') ?? 0,
          discountAmount:
              double.tryParse(map[_discountAmountKey] as String? ?? '0') ?? 0.0,
          discountPercentage:
              double.tryParse(map[_discountPercentageKey] as String? ?? '0') ??
                  0.0,
        );

  Map<String, dynamic> get map {
    List<dynamic> itemsList = [];
    List<dynamic> fixedDealList = [];
    List<dynamic> onSpotDealsList = [];

    for (var item in cart.items) {
      if (item is FoodItem) {
        itemsList.add(item.toMap());
      } else if (item is FixedDeal) {
        fixedDealList.add(item.toMap());
      } else if (item is OnSpotDeal) {
        onSpotDealsList.add(item.toMap());
      } else {}
    }
    return {
      _itemsKey: itemsList,
      _fixedDealKey: fixedDealList,
      _onSpotDealKey: onSpotDealsList,
      _customerKey: customer.map,
      _orderIdKey: id,
      _waiterKey: waiter.id,
      _tableKey: table.id,
      _coversKey: covers,
      _orderTypeKey: (orderType.index + 1).toString(),
      _deviceIdKey: deviceId,
      _orderDateKey: Lib.getDate(),
      _orderTimeKey: Lib.getTime12HR(),
    };
  }

  String get subTotal {
    double amount = 0;
    for (var item in cart.items) {
      amount += item.price * item.quantity;
    }
    return amount.toStringAsFixed(2);
  }

  String get totalTaxedAmount {
    double amount = 0;
    for (var item in cart.items) {
      amount += item.taxAmount * item.quantity;
    }
    return amount.toStringAsFixed(2);
  }

  String get totalTax => ((double.tryParse(totalTaxedAmount) ?? 0) -
          (double.tryParse(subTotal) ?? 0))
      .toStringAsFixed(2);

  void reset() => cart.clear();

  @override
  List<Object> get props => [id, orderNumber, cart.items.length];
}
