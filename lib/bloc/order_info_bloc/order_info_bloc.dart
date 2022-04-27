import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/repositories/customer_repository.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/repositories/tables_repository.dart';
import 'package:pos_app/repositories/waiters_repository.dart';
import 'package:pos_app/shared/config.dart';

part 'order_info_event.dart';
part 'order_info_state.dart';

class OrderInfoBloc extends Bloc<OrderInfoEvent, OrderInfoState> {
  OrderInfoBloc() : super(OrderInfoInitial(type: null));
  Order customerOrder = Order();
  List<Waiter> listWaiters = [];
  List<Tables> listTables = [];

  @override
  Stream<OrderInfoState> mapEventToState(
    OrderInfoEvent event,
  ) async* {
    try {
      if (event is OrderInfoBuild) {
        customerOrder = Order();
        listWaiters = await getWaiters();
        listTables = await getTables();
        customerOrder.userId = Config.user.id;
        customerOrder.orderType = (ORDERTYPE.DINE_IN.index + 1).toString();
        yield LoadedState(
          tables: listTables,
          waiters: listWaiters,
          type: ORDERTYPE.DINE_IN,
          customer: Customer(),
        );
      }

      switch (event.orderType) {
        case ORDERTYPE.DINE_IN:
          {
            final dineIn = ORDERTYPE.DINE_IN;
            if (event is OrderTypeChanged) {
              customerOrder.orderType = (dineIn.index + 1).toString();
            } else if (event is WaiterChanged) {
              customerOrder.waiterId = event.waiter.id;
              listWaiters.forEach((e) {
                if (e.id == event.waiter.id) {
                  e.selected = true;
                } else {
                  e.selected = false;
                }
              });
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
              } else {
                yield ErrorState(
                    type: event.orderType, message: 'This table is reserved');
              }
            } else if (event is CoversChanged) {
              customerOrder.covers = event.covers.toString();
            } else if (event is Submit) {
              if (customerOrder.waiterId == null ||
                  customerOrder.waiterId.isEmpty) {
                yield ErrorState(
                    message: 'Please select waiter.', type: dineIn);
              } else if (customerOrder.covers == null ||
                  customerOrder.covers.isEmpty) {
                yield ErrorState(message: 'Please enter covers.', type: dineIn);
              } else if (customerOrder.tableId == null ||
                  customerOrder.tableId.isEmpty) {
                yield ErrorState(message: 'Please select table.', type: dineIn);
              } else {
                yield LoadedState(
                  validSubmission: true,
                  customerOrder: customerOrder,
                  type: dineIn,
                );
              }
            } else {}
            yield LoadedState(
              tables: listTables,
              waiters: listWaiters,
              type: dineIn,
              customer: Customer(),
            );
            break;
          }
        case ORDERTYPE.TAKE_AWAY:
          {
            final takeAway = ORDERTYPE.TAKE_AWAY;
            if (event is OrderTypeChanged) {
              customerOrder.orderType = (takeAway.index + 1).toString();
              yield LoadedState(type: takeAway);
            } else if (event is CustomerChanged) {
              customerOrder.customer.name = event.customerName;
            } else if (event is ContactChanged) {
              customerOrder.customer.contact = event.contact;
            } else if (event is Submit) {
              if (customerOrder.customer == null ||
                  customerOrder.customer.name.isEmpty) {
                yield ErrorState(
                    message: 'Please enter customer name.', type: takeAway);
              } else if (customerOrder.customer.contact == null ||
                  customerOrder.customer.contact.isEmpty) {
                yield ErrorState(
                    message: 'Please enter contact number.', type: takeAway);
              } else {
                yield LoadedState(
                  validSubmission: true,
                  customerOrder: customerOrder,
                  type: takeAway,
                );
              }
            } else if (event is SearchCustomer) {
              if (customerOrder.customer.contact.isEmpty) {
                yield ErrorState(
                    type: takeAway, message: 'Please enter contact number');
              } else {
                final list = await getCustomers(customerOrder.customer.contact);
                if (list.isNotEmpty) {
                  Customer customer = list.first;
                  customerOrder.customer.name = customer.name;
                  customerOrder.customer.contact = customer.contact;
                  yield LoadedState(
                    waiters: [],
                    tables: [],
                    type: takeAway,
                    customer: customer,
                  );
                } else {
                  yield ErrorState(
                      type: takeAway, message: 'Customer not found');
                }
              }
            } else {}
          }
          break;
        case ORDERTYPE.DELIVERY:
          final delivery = ORDERTYPE.DELIVERY;
          if (event is OrderTypeChanged) {
            customerOrder.orderType = (delivery.index + 1).toString();
            yield LoadedState(type: delivery);
          } else if (event is CustomerChanged) {
            customerOrder.customer.name = event.customerName;
          } else if (event is ContactChanged) {
            customerOrder.customer.contact = event.contact;
          } else if (event is AddressChanged) {
            customerOrder.customer.address = event.address;
          } else if (event is SearchCustomer) {
            if (customerOrder.customer.contact == null &&
                customerOrder.customer.contact.isEmpty) {
              yield ErrorState(
                  type: delivery, message: 'Please enter contact number');
            } else {
              final list = await getCustomers(customerOrder.customer.contact);
              if (list.isNotEmpty) {
                Customer customer = list.first;
                customerOrder.customer.name = customer.name;
                customerOrder.customer.contact = customer.contact;
                customerOrder.customer.address = customer.address;
                yield LoadedState(
                  tables: [],
                  waiters: [],
                  type: delivery,
                  customer: customer,
                );
              } else {
                yield ErrorState(type: delivery, message: 'Customer not found');
              }
            }
          } else if (event is Submit) {
            if (customerOrder.customer == null ||
                customerOrder.customer.name.isEmpty) {
              yield ErrorState(
                  message: 'Please enter customer name.', type: delivery);
            } else if (customerOrder.customer.contact == null ||
                customerOrder.customer.contact.isEmpty) {
              yield ErrorState(
                  message: 'Please enter contact number.', type: delivery);
            } else if (customerOrder.customer.address == null ||
                customerOrder.customer.address.isEmpty) {
              yield ErrorState(message: 'Please enter address', type: delivery);
            } else {
              yield LoadedState(
                validSubmission: true,
                customerOrder: customerOrder,
                type: delivery,
              );
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
      yield ErrorState(type: event.orderType, message: e.toString());
    }
  }

  Future<List<Tables>> getTables() async {
    final response = await TablesRepo.repo.tables();
    if (response.statusCode == HttpStatus.ok) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Tables.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Waiter>> getWaiters() async {
    final response = await WaiterRepo.repo.waiters();
    if (response.statusCode == HttpStatus.ok) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Waiter.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Customer>> getCustomers(String contact) async {
    final response = await CustomerRepo.repo
        .customer(contact: customerOrder.customer.contact);
    if (response.statusCode == HttpStatus.ok) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Customer.fromMap(e))
          .toList();
    }
    return [];
  }
}
