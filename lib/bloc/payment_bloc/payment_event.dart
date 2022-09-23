part of 'payment_bloc.dart';

abstract class PaymentEvent {
  const PaymentEvent();
}

class PaymentBuild extends PaymentEvent {}

class PaymentModeChanged extends PaymentEvent {
  final PaymentMode mode;
  PaymentModeChanged({required this.mode});
}

class DiscountApplied extends PaymentEvent {
  final String discount;
  DiscountApplied({required this.discount});
}

class PaymentAdded extends PaymentEvent {
  final String amount;
  PaymentAdded({required this.amount});
}

class AddItem extends PaymentEvent {
  final int itemId;
  AddItem({required this.itemId});
}

class RemoveItem extends PaymentEvent {
  final Item item;
  RemoveItem({required this.item});
}

class ReduceItem extends PaymentEvent {
  final Item item;
  ReduceItem({required this.item});
}

class AddComment extends PaymentEvent {
  final int itemId;
  final String? comment;
  AddComment({required this.itemId, required this.comment});
}

class PaymentChanged extends PaymentEvent {
  final double payment;
  PaymentChanged({required this.payment});
}

class DiscountChanged extends PaymentEvent {
  final String? discount;
  DiscountChanged({this.discount});
}

class CardNumberChanged extends PaymentEvent {
  final String? cardNumber;
  CardNumberChanged({this.cardNumber});
}

class SubmitPressed extends PaymentEvent {}

class ResetPaymentOrder extends PaymentEvent {}

class LoadPaymentOrder extends PaymentEvent {
  final Order customerOrder;
  LoadPaymentOrder({required this.customerOrder});
}
