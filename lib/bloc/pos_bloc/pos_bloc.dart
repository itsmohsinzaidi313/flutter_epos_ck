import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/models/objects/menu.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/config.dart';
part 'pos_event.dart';
part 'pos_state.dart';

class POSBloc extends Bloc<POSEvents, POSState> {
  Order customerOrder;
  Menu menu = Menu();
  bool requestSubmitted = false;
  POSBloc() : super(PosInitial());

  @override
  Stream<POSState> mapEventToState(
    POSEvents event,
  ) async* {
    try {
      if (event is POSBuild) {
        if (customerOrder == null) {
          customerOrder = Order();
        }
        final menuResponse = await MenuRepo.repo.getMenu();
        if (menuResponse.statusCode == HttpStatus.ok) {
          final json = jsonDecode(menuResponse.body);
          menu = Menu.fromJson(json);
          menu.categories.first.selected = true;
          yield CategoriesLoaded(list: menu.categories);
          yield ItemsLoaded(
              list: menu.items
                  .where((e) => e.categoryId == menu.categories.first.id)
                  .toList());

          yield CartItems(
            list: customerOrder.cartItems,
            subTotal: customerOrder.subTotal,
            totalAmount: customerOrder.totalTaxedAmount,
            taxAmount: customerOrder.totalTax,
          );
        } else {
          yield POSError(message: 'Connection failed');
        }
      } else if (event is CategoryChanged) {
        menu.categories.forEach((e) {
          if (e.id == event.categoryId) {
            e.selected = true;
          } else {
            e.selected = false;
          }
        });
        yield CategoriesLoaded(list: menu.categories);
        yield ItemsLoaded(
            list: menu.items
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is LoadItems) {
        yield ItemsLoaded(
            list: menu.items
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is AddItem) {
        customerOrder.addCartItem(menu.items
            .where((element) => element.code == '${event.code}')
            .first);
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is ReduceItem) {
        if (customerOrder.editOrder) {
          double qty = 0;
          customerOrder.cartItems.forEach((element) => qty += element.quantity);
          if (qty > 1) {
            customerOrder.reduceCartItem(event.itemId);
          } else {
            yield SubmissionInvalid(
                message: 'There should be atleast on item in cart');
          }
        } else {
          customerOrder.reduceCartItem(event.itemId);
        }
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is ItemQuantityChanged) {
        if (event.quantity > 0) {
          customerOrder.setItemQuantity(event.itemId, event.quantity);
        } else {
          yield SubmissionInvalid(
              message: 'Quantity should be greater than zero(0)');
        }
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is RemoveItem) {
        if (customerOrder.editOrder) {
          if (customerOrder.cartItems.length > 1) {
            customerOrder.removeCartItem(event.itemId);
          } else {
            yield SubmissionInvalid(
                message: 'There should be atleast one item in cart');
          }
        } else {
          customerOrder.removeCartItem(event.itemId);
        }
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is AddComment) {
        customerOrder.addItemComment(event.itemId, event.comment);
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is PostOrder) {
        yield POSLoading(message: 'Saving order please wait...');
        customerOrder.deviceKey = Config.user.tiltId;
        if (isOrderValid(customerOrder)) {
          Response response;
          if (!requestSubmitted) {
            requestSubmitted = true;
            if (customerOrder.editOrder) {
              // if (false)
              response = await OrderRepo.repo
                  .updateOrder(customerOrder: customerOrder);
            } else {
              // if (false)
              response = await OrderRepo.repo.newOrder(order: customerOrder);
            }
            requestSubmitted = false;
          } else {
            yield POSLoading(message: 'Submitting order please wait...');
          }
          if (response.statusCode == HttpStatus.created) {
            if (customerOrder.editOrder) {
              yield OrderUpdated(message: 'Order Updated');
            } else {
              yield OrderPosted(message: 'Order Saved');
            }
          } else {
            final message = jsonDecode(response.body)['Message'];
            yield OrderPostFailed(
                message:
                    'Order Save/Update Failed\nStatusCode: ${response.statusCode}\n$message');
          }
        } else {
          yield SubmissionInvalid(
              message: 'Please add some items in your cart');
        }
      } else if (event is ResetPOSOrder) {
        customerOrder.reset();
      } else if (event is LoadPOSOrder) {
        customerOrder = event.customerOrder;
      }
    } catch (e) {
      yield POSError(message: e.toString());
    }
  }

  bool isOrderValid(Order order) {
    if (order.cartItems.length <= 0) {
      return false;
    }

    for (var item in order.cartItems) {
      if (item.quantity <= 0) {
        return false;
      }
    }
    return true;
  }
}
