import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/menu_item.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  Order customerOrder;
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
      customerOrder = event.customerOrder;
    } else if (event is PaymentBuild) {
      yield CartItems(
          list: customerOrder.cartItems,
          totalAmount: customerOrder.subTotal,
          totalTaxAmount: customerOrder.totalTaxedAmount);
      yield PaymentType(
          mode: PAYMENTMODE.CASH,
          totalAmount: customerOrder.subTotal,
          totalTaxAmount: customerOrder.totalTaxedAmount);
    } else if (event is PaymentModeChanged) {
      customerOrder.paymentmode = event.mode;
      yield PaymentType(
          mode: event.mode,
          totalAmount: customerOrder.subTotal,
          totalTaxAmount: customerOrder.totalTaxedAmount);
    } else if (event is AddItem) {
      customerOrder.addCartItem(customerOrder.items
          .where((element) => element.id == '${event.itemId}')
          .first);
      yield CartItems(
          list: customerOrder.cartItems,
          totalAmount: customerOrder.subTotal,
          totalTaxAmount: customerOrder.totalTaxedAmount);
    } else if (event is ReduceItem) {
      customerOrder.reduceCartItem(event.itemId, removeZeroQuantity: false);
      yield CartItems(
          list: customerOrder.cartItems,
          totalAmount: customerOrder.subTotal,
          totalTaxAmount: customerOrder.totalTaxedAmount);
    } else if (event is RemoveItem) {
      customerOrder.removeCartItem(event.itemId);
      yield CartItems(
          list: customerOrder.cartItems,
          totalAmount: customerOrder.subTotal,
          totalTaxAmount: customerOrder.totalTaxedAmount);
    } else if (event is AddComment) {
      customerOrder.addItemComment(event.itemId, event.comment);
      yield CartItems(
          list: customerOrder.cartItems,
          totalAmount: customerOrder.subTotal,
          totalTaxAmount: customerOrder.totalTaxedAmount);
    } else if (event is PaymentChanged) {
      double payment = double.tryParse(event.payment);
      if (payment != null) {
        if (payment > double.parse(customerOrder.subTotal) || payment <= 0) {
          yield InvalidPayment(
              message: invalidPaymentMessage,
              totalAmount: customerOrder.subTotal,
              totalTaxAmount: customerOrder.totalTaxedAmount);
        } else {
          customerOrder.payment = event.payment;
        }
      } else {
        yield InvalidPayment(
            message: invalidPaymentMessage,
            totalAmount: customerOrder.subTotal,
            totalTaxAmount: customerOrder.totalTaxedAmount);
      }
      yield AdjustPayment(
          totalAmount: customerOrder.subTotal,
          totalTaxAmount: customerOrder.totalTaxedAmount);
    } else if (event is CardNumberChanged) {
      if (int.tryParse(event.cardNumber) == null) {
        yield InvalidCardNumber(
            message: invalidCardNumberMessage,
            totalAmount: customerOrder.subTotal,
            totalTaxAmount: customerOrder.totalTaxedAmount);
      }
    } else if (event is DiscountChanged) {
      double discount = double.tryParse(event.discount);
      if (discount != null) {
        if (double.parse(customerOrder.subTotal) - discount < 0) {
          yield InvalidDiscount(
              message: invalidDiscountMessage,
              totalAmount: customerOrder.subTotal,
              totalTaxAmount: customerOrder.totalTaxedAmount);
        } else {
          customerOrder.discountedAmount = event.discount;
        }
      } else {
        yield InvalidDiscount(
            message: invalidDiscountMessage,
            totalAmount: customerOrder.subTotal,
            totalTaxAmount: customerOrder.totalTaxedAmount);
      }
    } else if (event is Submit) {
      double discount = double.tryParse(customerOrder.discountedAmount);
      double payment = double.tryParse(customerOrder.payment);
      if (discount == null) {
        yield InvalidDiscount(
            message: invalidDiscountMessage,
            totalAmount: customerOrder.subTotal,
            totalTaxAmount: customerOrder.totalTaxedAmount);
      }
      if (customerOrder.paymentmode == PAYMENTMODE.CASH) {
        if (payment == null) {
          yield InvalidPayment(
              message: invalidPaymentMessage,
              totalAmount: customerOrder.subTotal,
              totalTaxAmount: customerOrder.totalTaxedAmount);
        }
        if (payment != null && discount != null) {
          if (payment - discount < 0) {
            yield InvalidDiscount(
                message: invalidDiscountMessage,
                totalAmount: customerOrder.subTotal,
                totalTaxAmount: customerOrder.totalTaxedAmount);
          } else {
            yield ValidSubmission();
          }
        } else if (customerOrder.paymentmode == PAYMENTMODE.CREDIT) {
          if (int.tryParse(customerOrder.cardNumber) == null) {
            yield InvalidCardNumber(
                message: invalidCardNumberMessage,
                totalAmount: customerOrder.subTotal,
                totalTaxAmount: customerOrder.totalTaxedAmount);
          } else {
            yield ValidSubmission();
          }
        }
      }
    } else if (event is ResetPaymentOrder) {
      customerOrder.reset();
    }
  }
}
