part of 'payment_bloc.dart';

abstract class PaymentState {
  final String totalAmount;
  final String totalTaxAmount;
  const PaymentState({required this.totalAmount, required this.totalTaxAmount});
}

class PaymentInitial extends PaymentState {
  PaymentInitial({required totalAmount, required totalTaxAmount})
      : super(totalAmount: totalAmount, totalTaxAmount: totalTaxAmount);
}

class PaymentType extends PaymentState {
  final PaymentMode mode;
  PaymentType(
      {required this.mode, required totalAmount, required totalTaxAmount})
      : super(totalAmount: totalAmount, totalTaxAmount: totalTaxAmount);
}

class CartItems extends PaymentState {
  final List<Item>? list;
  CartItems({this.list, required totalAmount, required totalTaxAmount})
      : super(totalAmount: totalAmount, totalTaxAmount: totalTaxAmount);
}

class AdjustPayment extends PaymentState {
  AdjustPayment({required totalAmount, required totalTaxAmount})
      : super(totalAmount: totalAmount, totalTaxAmount: totalTaxAmount);
}

class InvalidDiscount extends PaymentState {
  final String? discount;
  final String? message;
  InvalidDiscount(
      {this.discount,
      this.message,
      required totalAmount,
      required totalTaxAmount})
      : super(totalAmount: totalAmount, totalTaxAmount: totalTaxAmount);
}

class InvalidPayment extends PaymentState {
  final String? payment;
  final String? message;
  InvalidPayment(
      {this.payment,
      this.message,
      required totalAmount,
      required totalTaxAmount})
      : super(totalAmount: totalAmount, totalTaxAmount: totalTaxAmount);
}

class InvalidCardNumber extends PaymentState {
  final String? message;
  InvalidCardNumber(
      {this.message, required totalAmount, required totalTaxAmount})
      : super(totalAmount: totalAmount, totalTaxAmount: totalTaxAmount);
}

class ValidSubmission extends PaymentState {
  const ValidSubmission()
      : super(
          totalAmount: '0',
          totalTaxAmount: '0',
        );
}

class InvalidSubmission extends PaymentState {
  final String message;
  const InvalidSubmission({
    required this.message,
  }) : super(
          totalAmount: '0',
          totalTaxAmount: '0',
        );
}
