import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/models/objects/customer_order.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final Order customerOrder;
  PaymentBloc({this.customerOrder}) : super(PaymentInitial());

  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {}
}
