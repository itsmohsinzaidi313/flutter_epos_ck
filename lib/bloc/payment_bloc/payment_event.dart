part of 'payment_bloc.dart';

enum PAYMENTMODE { CASH, CREDIT }

abstract class PaymentEvent {
  const PaymentEvent();
}

class PaymentBuild extends PaymentEvent {}

class PaymentModeChanged extends PaymentEvent {
  final PAYMENTMODE mode;
  PaymentModeChanged({@required this.mode});
}

class DiscountApplied extends PaymentEvent {
  final String discount;
  DiscountApplied({@required this.discount});
}

class PaymentAdded extends PaymentEvent {
  final String amount;
  PaymentAdded({@required this.amount});
}

class AddItem extends PaymentEvent {
  final int itemId;
  AddItem({@required this.itemId});
}

class RemoveItem extends PaymentEvent {
  final int itemId;
  RemoveItem({@required this.itemId});
}

class ReduceItem extends PaymentEvent {
  final int itemId;
  ReduceItem({@required this.itemId});
}

class AddComment extends PaymentEvent {
  final int itemId;
  final String comment;
  AddComment({@required this.itemId, @required this.comment});
}

class PaymentChanged extends PaymentEvent {
  final String payment;
  PaymentChanged({this.payment});
}

class DiscountChanged extends PaymentEvent {
  final String discount;
  DiscountChanged({this.discount});
}

class CardNumberChanged extends PaymentEvent {
  final String cardNumber;
  CardNumberChanged({this.cardNumber});
}

class Submit extends PaymentEvent {}

class ResetPaymentOrder extends PaymentEvent {}

class LoadPaymentOrder extends PaymentEvent {
  final Order customerOrder;
  LoadPaymentOrder({@required this.customerOrder});
}
