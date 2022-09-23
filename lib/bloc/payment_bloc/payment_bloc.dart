import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/shared/enums.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  late Order order;
  PaymentBloc() : super(PaymentInitial(totalAmount: '0', totalTaxAmount: '0'));

  final String invalidDiscountMessage = 'Please check the discount amount';
  final String invalidPaymentMessage = 'Please check the payment';
  final String invalidSubmissionMessage =
      'Please check the payment, card number or discount';
  final String invalidCardNumberMessage = 'Please check the card number';

  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {
    if (event is LoadPaymentOrder) {
      order = event.customerOrder;
    } else if (event is PaymentBuild) {
      yield CartItems(
          list: order.cart.items,
          totalAmount: order.subTotal,
          totalTaxAmount: order.totalTaxedAmount);
      yield PaymentType(
          mode: PaymentMode.cash,
          totalAmount: order.subTotal,
          totalTaxAmount: order.totalTaxedAmount);
    } else if (event is PaymentModeChanged) {
      order = Order.modify(order, paymentmode: event.mode);
      yield PaymentType(
          mode: event.mode,
          totalAmount: order.subTotal,
          totalTaxAmount: order.totalTaxedAmount);
    } else if (event is AddItem) {
      order.cart.addItem(order.cart.items
          .where((element) => element.id == '${event.itemId}')
          .first);
      yield CartItems(
          list: order.cart.items,
          totalAmount: order.subTotal,
          totalTaxAmount: order.totalTaxedAmount);
    } else if (event is ReduceItem) {
      order.cart.reduceCartItem(event.item.id, removeZeroQuantity: false);
      yield CartItems(
          list: order.cart.items,
          totalAmount: order.subTotal,
          totalTaxAmount: order.totalTaxedAmount);
    } else if (event is RemoveItem) {
      order.cart.removeCartItem(event.item.id);
      yield CartItems(
          list: order.cart.items,
          totalAmount: order.subTotal,
          totalTaxAmount: order.totalTaxedAmount);
    } else if (event is AddComment) {
      order.cart.addItemComment(event.itemId, event.comment ?? '');
      yield CartItems(
          list: order.cart.items,
          totalAmount: order.subTotal,
          totalTaxAmount: order.totalTaxedAmount);
    } else if (event is PaymentChanged) {
      double? payment = event.payment;
      if (payment <= 0) {
        if (payment > double.parse(order.subTotal) || payment <= 0) {
          yield InvalidPayment(
              message: invalidPaymentMessage,
              totalAmount: order.subTotal,
              totalTaxAmount: order.totalTaxedAmount);
        } else {
          order = Order.modify(order, paidAmount: event.payment);
        }
      } else {
        yield InvalidPayment(
            message: invalidPaymentMessage,
            totalAmount: order.subTotal,
            totalTaxAmount: order.totalTaxedAmount);
      }
      yield AdjustPayment(
          totalAmount: order.subTotal, totalTaxAmount: order.totalTaxedAmount);
    } else if (event is CardNumberChanged) {
      if (int.tryParse(event.cardNumber!) == null) {
        yield InvalidCardNumber(
            message: invalidCardNumberMessage,
            totalAmount: order.subTotal,
            totalTaxAmount: order.totalTaxedAmount);
      }
    } else if (event is DiscountChanged) {
      double? discount = double.tryParse(event.discount!);
      if (discount != null) {
        if (double.parse(order.subTotal) - discount < 0) {
          yield InvalidDiscount(
              message: invalidDiscountMessage,
              totalAmount: order.subTotal,
              totalTaxAmount: order.totalTaxedAmount);
        } else {
          order = Order.modify(order, discountAmount: discount);
        }
      } else {
        yield InvalidDiscount(
            message: invalidDiscountMessage,
            totalAmount: order.subTotal,
            totalTaxAmount: order.totalTaxedAmount);
      }
    } else if (event is SubmitPressed) {
      double discount = order.discountAmount;
      double payment = order.paidAmount;
      if (discount <= 0) {
        yield InvalidDiscount(
            message: invalidDiscountMessage,
            totalAmount: order.subTotal,
            totalTaxAmount: order.totalTaxedAmount);
      }
      if (order.paymentMode == PaymentMode.cash) {
        if (payment <= 0) {
          yield InvalidPayment(
            message: invalidPaymentMessage,
            totalAmount: order.subTotal,
            totalTaxAmount: order.totalTaxedAmount,
          );
        }
        if (discount <= 0) {
          if (payment - discount < 0) {
            yield InvalidDiscount(
              message: invalidDiscountMessage,
              totalAmount: order.subTotal,
              totalTaxAmount: order.totalTaxedAmount,
            );
          } else {
            yield ValidSubmission();
          }
        } else if (order.paymentMode == PaymentMode.credit) {
          if (int.tryParse(order.cardNumber) == null) {
            yield InvalidCardNumber(
              message: invalidCardNumberMessage,
              totalAmount: order.subTotal,
              totalTaxAmount: order.totalTaxedAmount,
            );
          } else {
            yield ValidSubmission();
          }
        }
      }
    } else if (event is ResetPaymentOrder) {
      order.reset();
    }
  }
}
