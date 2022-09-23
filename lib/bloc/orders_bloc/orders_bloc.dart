import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/constants.dart';

part 'orders_bloc_event.dart';
part 'orders_bloc_state.dart';

class OrdersBloc extends Bloc<OrdersBlocEvent, OrdersBlocState> {
  OrdersBloc() : super(InitialState()) {
    on<FetchOrders>((event, emit) async {
      emit(LoadingState(message: genericLoadingMessage));
      final response = await OrderRepo.repo.getOrders();
      if (response.statusCode == HttpStatus.ok) {
        final ordersList = (jsonDecode(response.body) as List<dynamic>)
            .map((e) => Order.fromMap(e))
            .toList();
        if (ordersList.isEmpty) {
          emit(LoadingState(message: 'No orders available'));
        } else {
          emit(LoadingState(message: 'Orders updated'));
        }
        emit(LoadedState(ordersList: ordersList));
      } else {
        emit(ErrorState(
            message: '$genericErrorMessage (${response.statusCode})'));
      }
    });
  }
}
