import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/constants.dart';

part 'orders_bloc_event.dart';
part 'orders_bloc_state.dart';

class OrdersBloc extends Bloc<OrdersBlocEvent, OrdersBlocState> {
  OrdersBloc() : super(InitialState());
  @override
  Stream<OrdersBlocState> mapEventToState(OrdersBlocEvent event) async* {
    if (event is FetchOrders) {
      yield LoadingState(message: genericLoadingMessage);
      final response = await OrderRepo.repo.getOrders();
      if (response.statusCode == HttpStatus.ok) {
        final ordersList = (jsonDecode(response.body) as List<dynamic>)
                .map((e) => Order.fromMap(e))
                .toList() ??
            <Order>[];
            yield LoadingState(message: 'Orders updated');
        yield LoadedState(ordersList: ordersList);
      } else {
        yield ErrorState(
            message: '$genericErrorMessage (${response.statusCode})');
      }
    }
  }
}
