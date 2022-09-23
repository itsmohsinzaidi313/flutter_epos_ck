import 'package:pos_app/models/customer.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/shared/enums.dart';

abstract class OrderContext {
  final String id;
  final String orderNumber;
  final OrderType orderType;
  final PaymentMode paymentMode;
  final Waiter waiter;
  final Tables table;
  final Customer customer;
  final OrderStatus orderStatus;
  final String covers;
  final String time;
  final String date;
  final String deviceId;
  final String cardNumber;
  final double paidAmount;
  final double discountAmount;
  final double discountPercentage;

  const OrderContext({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    required this.paymentMode,
    required this.waiter,
    required this.table,
    required this.customer,
    required this.orderStatus,
    required this.covers,
    required this.time,
    required this.date,
    required this.cardNumber,
    required this.deviceId,
    required this.paidAmount,
    required this.discountAmount,
    required this.discountPercentage,
  });

  OrderContext.modify(
    OrderContext orderContext, {
    String? id,
    String? orderNumber,
    OrderType? orderType,
    PaymentMode? paymentMode,
    Waiter? waiter,
    Tables? table,
    Customer? customer,
    OrderStatus? orderStatus,
    String? covers,
    String? time,
    String? date,
    String? deviceId,
    String? cardNumber,
    double? paidAmount,
    double? discountAmount,
    double? discountPercentage,
  })  : id = id ?? orderContext.id,
        orderNumber = orderNumber ?? orderContext.orderNumber,
        orderType = orderType ?? orderContext.orderType,
        paymentMode = paymentMode ?? orderContext.paymentMode,
        waiter = waiter ?? orderContext.waiter,
        table = table ?? orderContext.table,
        customer = customer ?? orderContext.customer,
        orderStatus = orderStatus ?? orderContext.orderStatus,
        covers = covers ?? orderContext.covers,
        time = time ?? orderContext.time,
        date = date ?? orderContext.date,
        deviceId = deviceId ?? orderContext.deviceId,
        cardNumber = cardNumber ?? orderContext.cardNumber,
        paidAmount = paidAmount ?? orderContext.paidAmount,
        discountAmount = discountAmount ?? orderContext.discountAmount,
        discountPercentage =
            discountPercentage ?? orderContext.discountPercentage;
}
