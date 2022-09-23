import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/repositories/customer_repository.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/repositories/tables_repository.dart';
import 'package:pos_app/repositories/waiters_repository.dart';
import 'package:pos_app/shared/enums.dart';

part 'order_info_event.dart';
part 'order_info_state.dart';

class OrderInfoBloc extends Bloc<OrderInfoEvent, OrderInfoState> {
  Order order;
  List<Waiter> listWaiters = [];
  List<Tables> listTables = [];
  OrderInfoBloc({required this.order}) : super(OrderInfoInitial()) {
    on<OrderInfoBuild>((event, emit) async {
      listWaiters.clear();
      listTables.clear();
      emit(LoadingState());
      listWaiters.addAll(await getWaiters());
      listTables.addAll(await getTables());
      emit(LoadedState(
        tables: listTables,
        waiters: listWaiters,
        order: order,
      ));
    });
    on<OrderTypeChanged>((event, emit) async {
      order = Order.modify(order, orderType: event.orderType);
      if (event.orderType == OrderType.dineIn) {
        emit(LoadingState());
        listWaiters.addAll(await getWaiters());
        listTables.addAll(await getTables());
      }
      emit(LoadedState(
        order: order,
        waiters: listWaiters,
        tables: listTables,
      ));
    });
    on<WaiterChanged>((event, emit) {
      try {
        for (var i = 0; i < listWaiters.length; i++) {
          if (listWaiters[i].id == event.waiter.id) {
            listWaiters[i] = Waiter.modify(listWaiters[i], selected: true);
          } else {
            listWaiters[i] = Waiter.modify(listWaiters[i], selected: false);
          }
        }
        order = Order.modify(order, waiter: event.waiter);
      } catch (e) {
        log('Error', error: e);
      }
      emit(LoadedState(
        order: order,
        waiters: listWaiters,
        tables: listTables,
      ));
    });
    on<TableChanged>((event, emit) {
      if (!event.table.reserved) {
        order = Order.modify(order, table: event.table);
        for (var i = 0; i < listTables.length; i++) {
          if (listTables[i].id == event.table.id) {
            listTables[i] = Tables.modify(listTables[i], selected: true);
          } else {
            listTables[i] = Tables.modify(listTables[i], selected: false);
          }
        }
        emit(LoadedState(
            order: order, tables: listTables, waiters: listWaiters));
      } else {
        emit(ErrorState(message: 'This table is reserved'));
      }
    });
    on<CoversChanged>((event, emit) {
      order = Order.modify(order, covers: event.covers);
    });
    on<NextPressed>((event, emit) {
      if (order.customer.name.isEmpty &&
          (<OrderType>[OrderType.takeAway, OrderType.delivery]
              .contains(order.orderType))) {
        emit(ErrorState(message: 'Please enter customer name.'));
      } else if (order.customer.contact.isEmpty &&
          (<OrderType>[OrderType.takeAway, OrderType.delivery]
              .contains(order.orderType))) {
        emit(ErrorState(message: 'Please enter contact number.'));
      } else if (order.waiter.name.isEmpty &&
          (<OrderType>[OrderType.dineIn].contains(order.orderType))) {
        emit(ErrorState(message: 'Please select waiter.'));
      } else if (order.table.name.isEmpty &&
          (<OrderType>[OrderType.dineIn].contains(order.orderType))) {
        emit(ErrorState(message: 'Please select table.'));
      } else if (order.customer.address.isEmpty &&
          (<OrderType>[OrderType.delivery].contains(order.orderType))) {
        emit(ErrorState(message: 'Please enter address.'));
      } else {
        emit(LoadedState(
          validSubmission: true,
          order: order,
        ));
      }
    });
    on<SearchCustomer>((event, emit) async {
      if (order.customer.contact.isEmpty) {
        emit(ErrorState(message: 'Please enter contact number'));
      } else {
        final list = await getCustomers(order.customer.contact);
        if (list.isNotEmpty) {
          order = Order.modify(order, customer: list.first);
          emit(LoadedState(
            tables: [],
            waiters: [],
            order: order,
          ));
        } else {
          emit(ErrorState(message: 'Customer not found'));
        }
      }
    });
    on<ResetOrderInfoOrder>((event, emit) {
      order.reset();
    });
  }

  Future<List<Tables>> getTables() async {
    final response = await TablesRepo.repo.tables();
    if (response.statusCode == HttpStatus.ok) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Tables.fromMap(e))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Waiter>> getWaiters() async {
    final response = await WaiterRepo.repo.waiters();
    if (response.statusCode == HttpStatus.ok) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Waiter.fromMap(e))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Customer>> getCustomers(String? contact) async {
    final response =
        await CustomerRepo.repo.customer(contact: order.customer.contact);
    if (response.statusCode == HttpStatus.ok) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Customer.fromMap(e))
          .toList();
    }
    return [];
  }
}
