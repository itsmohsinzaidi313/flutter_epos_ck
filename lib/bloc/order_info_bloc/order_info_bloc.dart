import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/tables/customer_table.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/repositories/customer_repository.dart';
import 'package:pos_app/models/customer.dart';
import 'package:pos_app/repositories/tables_repository.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/repositories/waiters_repository.dart';

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
        listWaiters = await WaiterRepo.repo.getWaiters();
        listTables = await TablesRepo.repo.tables();
        final user = await UsersRepo.repo.getCurrentUser();
        customerOrder.userId = user.id;
        customerOrder.outletId = user.outletId;
        customerOrder.orderType = (ORDERTYPE.DINE_IN.index + 1).toString();
        customerOrder.customer =
            await CustomerRepo.repo.getCustomer(remoteId: 1);

        yield OrderTypeState(type: ORDERTYPE.DINE_IN);
        yield WaitersState(waiters: listWaiters, type: ORDERTYPE.DINE_IN);
      }

      switch (event.orderType) {
        case ORDERTYPE.DINE_IN:
          final dineIn = ORDERTYPE.DINE_IN;
          if (event is OrderTypeChanged) {
            customerOrder.customer =
            await CustomerRepo.repo.getCustomer(remoteId: 1);
            customerOrder.orderType = (dineIn.index + 1).toString();
            yield OrderTypeState(type: dineIn);
            yield WaitersState(waiters: listWaiters, type: dineIn);
          } else if (event is WaiterChanged) {
            customerOrder.waiterId = event.waiter.id;
            for (var item in listWaiters) {
              if (item.id == event.waiter.id) {
                item.selected = true;
              } else {
                item.selected = false;
              }
            }
            yield TablesState(tables: listTables, type: dineIn);
          } else if (event is TableChanged) {
            if (!event.table.reserved) {
              customerOrder.tableId = event.table.id;
              for (var item in listTables) {
                if (item.id == event.table.id) {
                  item.selected = true;
                } else {
                  item.selected = false;
                }
              }
              yield WaitersState(waiters: listWaiters, type: dineIn);
            } else {
              yield InvalidTables(
                  type: event.orderType, message: 'This table is reserved');
            }
          } else if (event is CoversChanged) {
            customerOrder.covers = event.covers.toString();
          } else if (event is Submit) {
            if (customerOrder.waiterId == null ||
                customerOrder.waiterId.isEmpty) {
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
            customerOrder.customer.name = event.customerName;
          } else if (event is ContactChanged) {
            customerOrder.customer.contact = event.contact;
          } else if (event is Submit) {
            if (customerOrder.customer == null ||
                customerOrder.customer.name.isEmpty) {
              yield InvalidCustomer(
                  message: 'Please enter customer name.', type: takeAway);
            } else if (customerOrder.customer.contact == null ||
                customerOrder.customer.contact.isEmpty) {
              yield InvalidContact(
                  message: 'Please enter contact number.', type: takeAway);
            } else {
              yield ValidSubmission(
                  customerOrder: customerOrder, type: takeAway);
            }
          } else if (event is SearchCustomer) {
            if (customerOrder.customer.contact == '') {
              yield InvalidContact(
                  type: takeAway, message: 'Please enter contact number');
            } else {
              Customer cust = await CustomerRepo.repo
                  .getCustomer(contact: customerOrder.customer.contact);

              if (cust != null) {
                Customer customer = cust;
                customerOrder.customer.name = customer.name;
                customerOrder.customer.contact = customer.contact;
                yield CustomerFound(
                    type: takeAway,
                    customer: customer,
                    message: 'Customer found.');
              } else {
                yield CustomerNotFound(
                    type: takeAway, message: 'Customer not found');
              }
            }
          } else {}
          break;
        case ORDERTYPE.DELIVERY:
          final delivery = ORDERTYPE.DELIVERY;
          if (event is OrderTypeChanged) {
            customerOrder.orderType = (delivery.index + 1).toString();
            yield OrderTypeState(type: delivery);
          } else if (event is CustomerChanged) {
            customerOrder.customer.name = event.customerName;
          } else if (event is ContactChanged) {
            customerOrder.customer.contact = event.contact;
          } else if (event is AddressChanged) {
            customerOrder.customer.address = event.address;
          } else if (event is SearchCustomer) {
            if (customerOrder.customer.contact == null &&
                customerOrder.customer.contact.isEmpty) {
              yield InvalidContact(
                  type: delivery, message: 'Please enter contact number');
            } else {
              Customer cust = await CustomerRepo.repo
                  .getCustomer(contact: customerOrder.customer.contact);
              if (cust != null) {
                Customer customer = cust;
                if (customer != null) customerOrder.customer = customer;
                yield CustomerFound(
                    type: delivery,
                    customer: customer,
                    message: 'Customer found.');
              } else {
                yield CustomerNotFound(
                    type: delivery, message: 'Customer not found');
              }
            }
          } else if (event is Submit) {
            if (customerOrder.customer == null ||
                customerOrder.customer.name.isEmpty) {
              yield InvalidCustomer(
                  message: 'Please enter customer name.', type: delivery);
            } else if (customerOrder.customer.contact == null ||
                customerOrder.customer.contact.isEmpty) {
              yield InvalidContact(
                  message: 'Please enter contact number.', type: delivery);
            } else if (customerOrder.customer.address == null ||
                customerOrder.customer.address.isEmpty) {
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
