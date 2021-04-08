import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/customer_table.dart';
import 'package:pos_app/models/objects/waiter.dart';
import 'package:pos_app/repositories/tables_repository.dart';
import 'package:pos_app/repositories/waiters_repository.dart';

part 'order_info_event.dart';
part 'order_info_state.dart';

class OrderInfoBloc extends Bloc<OrderInfoEvent, OrderInfoState> {
  OrderInfoBloc() : super(OrderInfoInitial());
  Order customerOrder = Order();
  @override
  Stream<OrderInfoState> mapEventToState(
    OrderInfoEvent event,
  ) async* {
    yield OrderInfoInitial();

    switch (event.orderType) {
      case ORDERTYPE.DINE_IN:
        final dineIn = ORDERTYPE.DINE_IN;
        if (event is OrderTypeChanged) {
          yield OrderTypeState(type: event.orderType);
        } else if (event is WaiterChanged) {
          customerOrder.waiter = event.waiter.id;
          yield TablesState(tables: [], type: dineIn);
        } else if (event is TableChanged) {
          customerOrder.table = event.table.id;
          yield WaitersState(waiters: [], type: dineIn);
        } else if (event is CoversChanged) {
          customerOrder.covers = event.covers.toString();
        } else if (event is Submit) {
          customerOrder.covers = event.covers.toString();
          if (customerOrder.waiter == null || customerOrder.waiter.isEmpty) {
            yield InvalidWaiter(message: 'Please select waiter.', type: dineIn);
          } else if (customerOrder.covers == null ||
              customerOrder.covers.isEmpty) {
            yield InvalidCovers(message: 'Please enter covers.', type: dineIn);
          } else if (customerOrder.table == null ||
              customerOrder.table.isEmpty) {
            yield InvalidTables(message: 'Please select table.', type: dineIn);
          } else {
            yield ValidSubmission(customerOrder: customerOrder, type: dineIn);
          }
        }
        break;
      case ORDERTYPE.TAKE_AWAY:
        final takeAway = ORDERTYPE.TAKE_AWAY;
        if (event is CustomerChanged) {
          customerOrder.customer = event.customerName;
        } else if (event is ContactChanged) {
          customerOrder.contact = event.contact;
        } else if (event is Submit) {
          if (customerOrder.customer == null ||
              customerOrder.customer.isEmpty) {
            yield InvalidCustomer(
                message: 'Please enter customer name.', type: takeAway);
          } else if (customerOrder.contact == null ||
              customerOrder.contact.isEmpty) {
            yield InvalidContact(
                message: 'Please enter contact number.', type: takeAway);
          } else {
            yield ValidSubmission(customerOrder: customerOrder, type: takeAway);
          }
        }
        break;
      case ORDERTYPE.DELIVERY:
        final delivery = ORDERTYPE.DELIVERY;
        if (event is CustomerChanged) {
          customerOrder.customer = event.customerName;
        } else if (event is ContactChanged) {
          customerOrder.contact = event.contact;
        } else if (event is AddressChanged) {
          customerOrder.address = event.address;
        } else if (event is Submit) {
          if (customerOrder.customer == null ||
              customerOrder.customer.isEmpty) {
            yield InvalidCustomer(
                message: 'Please enter customer name.', type: delivery);
          } else if (customerOrder.contact == null ||
              customerOrder.contact.isEmpty) {
            yield InvalidContact(
                message: 'Please enter contact number.', type: delivery);
          } else if (customerOrder.address == null ||
              customerOrder.address.isEmpty) {
            yield InvalidAddress(
                message: 'Please enter address', type: delivery);
          } else {
            yield ValidSubmission(customerOrder: customerOrder, type: delivery);
          }
        }
        break;
      default:
        break;
    }
  }
}
