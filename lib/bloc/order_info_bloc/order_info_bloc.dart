import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/objects/customer_order.dart';
import 'package:pos_app/objects/customer_table.dart';
import 'package:pos_app/objects/waiter.dart';
import 'package:pos_app/repositories/customer_repository.dart';
import 'package:pos_app/objects/customer.dart';
import 'package:pos_app/repositories/tables_repository.dart';
import 'package:pos_app/repositories/waiters_repository.dart';
import 'package:pos_app/shared/config.dart';

part 'order_info_event.dart';
part 'order_info_state.dart';

class OrderInfoBloc extends Bloc<OrderInfoEvent, OrderInfoState> {
  OrderInfoBloc() : super(OrderInfoInitial(type: null));
  Order customerOrder;
  List<Waiter> listWaiters = [];
  List<Tables> listTables = [];
  @override
  Stream<OrderInfoState> mapEventToState(
    OrderInfoEvent event,
  ) async* {
    try {
      if (event is OrderInfoBuild) {
        customerOrder = Order();
        final waiterResponse = await WaiterRepo.repo.waiters;
        final tablesResponse = await TablesRepo.repo.tables;
        customerOrder.userId = Config.user.id;
        customerOrder.orderType = (ORDERTYPE.DINE_IN.index + 1).toString();
        listWaiters = (waiterResponse.data as List<dynamic>)
            .map((e) => Waiter.fromJson(e))
            .toList();
        listTables = (tablesResponse.data as List<dynamic>)
            .map((e) => Tables.fromJson(e))
            .toList();
        yield OrderTypeState(type: ORDERTYPE.DINE_IN);
        yield WaitersState(waiters: listWaiters, type: ORDERTYPE.DINE_IN);
      }

      switch (event.orderType) {
        case ORDERTYPE.DINE_IN:
          final dineIn = ORDERTYPE.DINE_IN;
          if (event is OrderTypeChanged) {
            customerOrder.orderType = (dineIn.index + 1).toString();
            yield OrderTypeState(type: dineIn);
            yield WaitersState(waiters: listWaiters, type: dineIn);
          } else if (event is WaiterChanged) {
            customerOrder.waiterId = event.waiter.id;
            listWaiters.forEach((e) {
              if (e.id == event.waiter.id) {
                e.selected = true;
              } else {
                e.selected = false;
              }
            });
            yield TablesState(tables: listTables, type: dineIn);
          } else if (event is TableChanged) {
            if (!event.table.reserved) {
              customerOrder.tableId = event.table.id;
              listTables.forEach((e) {
                if (e.id == event.table.id) {
                  e.selected = true;
                } else {
                  e.selected = false;
                }
              });
              yield WaitersState(waiters: listWaiters, type: dineIn);
            } else {
              yield InvalidTables(
                  type: event.orderType, message: 'This table is reserved');
            }
          } else if (event is CoversChanged) {
            customerOrder.covers = event.covers.toString();
          } else if (event is Submit) {
            if (customerOrder.waiterId == null || customerOrder.waiterId.isEmpty) {
              yield InvalidWaiter(
                  message: 'Please select waiter.', type: dineIn);
            } else if (customerOrder.covers == null ||
                customerOrder.covers.isEmpty) {
              yield InvalidCovers(
                  message: 'Please enter covers.', type: dineIn);
            } else if (customerOrder.tableId == null ||
                customerOrder.tableId.isEmpty) {
              yield InvalidTables(
                  message: 'Please select table.', type: dineIn);
            } else {
              yield ValidSubmission(customerOrder: customerOrder, type: dineIn);
            }
          } else {}
          break;
        case ORDERTYPE.TAKE_AWAY:
          final takeAway = ORDERTYPE.TAKE_AWAY;
          if (event is OrderTypeChanged) {
            customerOrder.orderType = (takeAway.index + 1).toString();
            yield OrderTypeState(type: takeAway);
          } else if (event is CustomerChanged) {
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
              yield ValidSubmission(
                  customerOrder: customerOrder, type: takeAway);
            }
          } else if (event is SearchCustomer) {
            if (customerOrder.contact.isEmpty) {
              yield InvalidContact(
                  type: takeAway, message: 'Please enter contact number');
            } else {
              final response = await CustomerRepo.repo
                  .customer(contact: customerOrder.contact);
              if (response.status) {
                List<Customer> list = (response.data as List<dynamic>)
                    .map((e) => Customer.fromJson(e))
                    .toList();

                if (list.isNotEmpty) {
                  Customer customer = list.first;
                  customerOrder.customer = customer.name;
                  customerOrder.contact = customer.contact;
                  yield CustomerFound(
                      type: takeAway,
                      customer: customer,
                      message: 'Customer found.');
                } else {
                  yield CustomerNotFound(
                      type: takeAway, message: 'Customer not found');
                }
              } else {}
            }
          } else {}
          break;
        case ORDERTYPE.DELIVERY:
          final delivery = ORDERTYPE.DELIVERY;
          if (event is OrderTypeChanged) {
            customerOrder.orderType = (delivery.index + 1).toString();
            yield OrderTypeState(type: delivery);
          } else if (event is CustomerChanged) {
            customerOrder.customer = event.customerName;
          } else if (event is ContactChanged) {
            customerOrder.contact = event.contact;
          } else if (event is AddressChanged) {
            customerOrder.address = event.address;
          } else if (event is SearchCustomer) {
            if (customerOrder.contact == null &&
                customerOrder.contact.isEmpty) {
              yield InvalidContact(
                  type: delivery, message: 'Please enter contact number');
            } else {
              final response = await CustomerRepo.repo
                  .customer(contact: customerOrder.contact);
              if (response.status) {
                List<Customer> list = (response.data as List<dynamic>)
                    .map((e) => Customer.fromJson(e))
                    .toList();
                if (list.isNotEmpty) {
                  Customer customer = list.first;
                  customerOrder.customer = customer.name;
                  customerOrder.contact = customer.contact;
                  customerOrder.address = customer.address;
                  yield CustomerFound(
                      type: delivery,
                      customer: customer,
                      message: 'Customer found.');
                } else {
                  yield CustomerNotFound(
                      type: delivery, message: 'Customer not found');
                }
              } else {}
            }
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
              yield ValidSubmission(
                  customerOrder: customerOrder, type: delivery);
            }
          } else {}
          break;
        default:
          break;
      }
      if (event is ResetOrderInfoOrder) {
        customerOrder.reset();
      }
    } catch (e) {
      yield OrderInfoError(type: event.orderType, message: e.toString());
    }
  }
}
